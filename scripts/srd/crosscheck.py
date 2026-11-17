# Part of scripts/srd (see README.md).
# Rebuild each adversary's SRD text from our data and diff it with the
# cleaned SRD extraction. Prints OK or the first mismatch per adversary.
#
#   crosscheck.py <data.json> <clean.txt>
#
# Independent of parse_adversaries.py on purpose: it finds each block by its
# uppercase heading and ends it at the SRD's own block separator (a line of
# spaces), so a parser that swallowed or dropped text shows up as a diff.
import sys, json, re
data = json.load(open(sys.argv[1], encoding='utf-8'))
raw = open(sys.argv[2], encoding='utf-8').read()

# Drop page footers ("97" / "Daggerheart SRD") and chapter headings, but
# remember each line's page and keep the block separators.
lines, page = [], None
for l in raw.split('\n'):
    m = re.fullmatch(r'=====PAGE (\d+)=====', l)
    if m:
        page = int(m.group(1))
        continue
    s = l.strip()
    if re.fullmatch(r'\d+|Daggerheart SRD|TIER \d ADVERSARIES \(LEVELS? [\d–-]+\)', s):
        continue
    lines.append((page, l))

# A hyphen ending a line joins the next without a space ("Jack-o’-" +
# "Lantern"); the SRD has no soft hyphenation in stat blocks.
norm = lambda s: re.sub(r'\s+', ' ', re.sub(r'(\S)-[ \t]*\n\s*', r'\1-', s)).strip()
# Extraction artifact: a space before a colon ("Corrupted Staff : Far"); the
# printed book has none and our data strips it.
norm_srd = lambda s: re.sub(r' :', ':', norm(s))
signed = lambda n: n if isinstance(n, str) else (('−' + str(-n)) if n < 0 else '+' + str(n))
def th(t):
    f = lambda v: 'None' if v is None else str(v)
    return 'None' if t['major'] is None and t['severe'] is None else f(t['major']) + '/' + f(t['severe'])

def srd_block(name):
    """The SRD text of the block headed `name` and the page of its heading."""
    words = name.upper().split()
    for i in range(len(lines)):
        if not lines[i][1].strip():
            continue                                # a heading never starts on a blank line
        for k in (1, 2):
            if ' '.join(x.strip() for _, x in lines[i:i + k]).split() == words and i + k < len(lines) \
                    and re.match(r'Tier \d ', lines[i + k][1].strip()):
                out = []
                for _, l in lines[i + k:]:
                    s = l.strip()
                    if s == '' and l != '':          # separator: a line of spaces
                        break
                    if out and re.fullmatch(r"[A-Z0-9 ’'&:,()\-–]+", s) and sum(c.isalpha() for c in s) > 2 \
                            and 'FEATURES' in '\n'.join(out):
                        break                       # a chapter heading after the block
                    out.append(l)
                return lines[i][0], '\n'.join(out)
    return None, None

ok = True
notes = []
for a in data:
    kind = a['type'] + (f" ({a['creatures-per-hp']}/HP)" if a.get('creatures-per-hp') else '')
    at = a['attack']
    dmg = at['damage'] + (' direct' if at['direct'] else '') + ' ' + at['damage-type']
    stress = a.get('stress')
    lines_ = [f"Tier {a['tier']} {kind}", a['description'],
              'Motives & Tactics: ' + a['motives'],
              f"Difficulty: {a['difficulty']} | Thresholds: {th(a['thresholds'])} | HP: {a['hp']} | Stress: {'None' if stress is None else stress}",
              f"ATK: {signed(at['modifier'])} | {at['name']}: {at['range']} | {dmg}"]
    if a['experiences']:
        lines_.append('Experience: ' + ', '.join(f"{x['name']} {signed(x['bonus'])}" for x in a['experiences']))
    lines_.append('FEATURES')
    lines_ += [f"{f['name']} - {f['kind']}: {f['body']}" for f in a['features']]
    ours = norm('\n'.join(lines_))
    page, text = srd_block(a['name'])
    if text is None:
        ok = False
        print(f"MISS  {a['id']}: no SRD block headed {a['name'].upper()!r}")
        continue
    theirs = norm_srd(text)
    if ' :' in norm(text):
        notes.append(f"{a['id']} (p. {page}): extracted text has a space before a colon; compared without it")
    # Known SRD typo: an en dash instead of the minus sign in an ATK line.
    if re.search(r'ATK: –', theirs):
        notes.append(f"{a['id']} (p. {page}): SRD prints 'ATK: –' (en dash); compared as a minus sign")
        theirs = theirs.replace('ATK: –', 'ATK: −')
    pg_ok = a['flags']['source']['page'] == page
    if ours == theirs and pg_ok:
        print(f"OK    {a['id']} (p. {page})")
    else:
        ok = False
        i = next((i for i, (x, y) in enumerate(zip(ours, theirs)) if x != y), min(len(ours), len(theirs)))
        print(f"DIFF  {a['id']} page ours={a['flags']['source']['page']} srd={page}\n  ours:   ...{ours[max(0,i-40):i+60]}\n  theirs: ...{theirs[max(0,i-40):i+60]}")
for n in notes:
    print('NOTE ', n)
print(f"{sum(1 for _ in data)} adversaries checked: {'all OK' if ok else 'DIFFERENCES FOUND'}")
sys.exit(0 if ok else 1)
