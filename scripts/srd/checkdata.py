# Part of scripts/srd (see README.md).
# Cross-check environments and loot in daggerheart-srd against the SRD text.
# Rebuilds each block's text from our data and looks for it in the plain
# extraction (extract.py output, cleaned with runs.clean). The data was
# parsed from font runs, so this compares two extraction paths, and also
# checks that the Typst data says what the parser read.
#
# Export the data first with a .typ file that puts this in a metadata
# element (plain text for content bodies; list items prefixed "• "):
#   (environments: (...), items: (...), consumables: (...))
# then: typst query <export.typ> metadata --field value --one > data.json
#
# Usage: python -I checkdata.py <data.json> <raw.txt>
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runs import clean  # noqa: E402


HYPHEN_JOINS = []


def norm(s):
    return re.sub(r'\s+', ' ', s).strip()


def srd_text(raw):
    """Cleaned SRD text with page markers kept and footers removed, as one
    normalized string; also a list of (offset, page) to map hits to pages."""
    text, pages, pos = [], [], 0
    for chunk in re.split(r'=====PAGE (\d+)=====', raw)[1:]:
        if chunk.isdigit():
            page = int(chunk)
            continue
        lines = [l for l in clean(chunk).splitlines()
                 if l.strip() not in ('Daggerheart SRD', str(page))]
        # A line ending in a hyphen continues a compound ("2-foot-" / "deep");
        # every such join is listed for human review.
        joined = '\n'.join(lines)
        for m in re.finditer(r'(\S+-)[ \t]*\n\s*(\S+)', joined):
            HYPHEN_JOINS.append((page, m.group(1) + m.group(2)))
        body = norm(re.sub(r'-[ \t]*\n\s*', '-', joined)) + ' '
        pages.append((pos, page))
        text.append(body)
        pos += len(body)
    return ''.join(text), pages


def page_at(pages, offset):
    return [p for o, p in pages if o <= offset][-1]


def env_text(e):
    parts = [e['name'].upper(), f"Tier {e['tier']} {e['type']}", e['description'],
             'Impulses: ' + e['impulses'], f"Difficulty: {e['difficulty']}",
             'Potential Adversaries: ' + e['potential-adversaries'], 'FEATURES']
    for f in e['features']:
        parts.append(f"{f['name']} - {f['kind']}: {f['body']} {f['questions']}")
    return norm(' '.join(parts))


def loot_text(r):
    roll = f"{r['roll']:02d}" if r['collection'] == 'Daggerheart Core Set' else str(r['roll'])
    return norm(f"{roll} {r['name']} {r['description']}")


def check(label, ours, srd, pages, page, start=0):
    i = srd.find(ours, start)
    if i >= 0 and page_at(pages, i) == page:
        return True, i + len(ours)
    if i >= 0:
        print(f'PAGE  {label}: found on p. {page_at(pages, i)}, data says p. {page}')
        return False, start
    # Show where it diverges from the closest start.
    head = ours[:40]
    j = srd.find(head, start)
    if j < 0:
        print(f'MISS  {label}: start not found: {head!r}')
        return False, start
    k = next((n for n, (a, b) in enumerate(zip(ours, srd[j:])) if a != b), len(ours))
    print(f'DIFF  {label} (p. {page})\n  ours: ...{ours[max(0, k - 50):k + 50]!r}\n  srd:  ...{srd[j + max(0, k - 50):j + k + 50]!r}')
    return False, start


def main():
    data = json.load(open(sys.argv[1], encoding='utf-8'))
    srd, pages = srd_text(open(sys.argv[2], encoding='utf-8').read())
    ok = n = 0
    for e in data['environments']:
        good, _ = check(e['id'], env_text(e), srd, pages, e['flags']['source']['page'])
        ok += good
        n += 1
    for kind in ('items', 'consumables'):
        pos = 0
        for r in data[kind]:
            good, pos = check(f"{kind}/{r['id']}", loot_text(r), srd, pages,
                              r['flags']['source']['page'], pos)
            ok += good
            n += 1
    checked = {e['flags']['source']['page'] for e in data['environments']}
    checked |= {r['flags']['source']['page'] for k in ('items', 'consumables') for r in data[k]}
    joins = [(p, w) for p, w in HYPHEN_JOINS if p in checked]
    if joins:
        print('Review: line-end hyphens joined as compounds:')
        for p, w in joins:
            print(f'  p. {p}: {w}')
    print(f'{ok}/{n} OK')
    sys.exit(0 if ok == n else 1)


if __name__ == '__main__':
    main()
