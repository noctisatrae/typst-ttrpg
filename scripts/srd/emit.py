# Part of scripts/srd (see README.md).
# Turn JSON from environments.py / loot.py into daggerheart-srd Typst data.
# Text goes into Typst string literals (#"..."), so no SRD wording can be
# read as markup; bullet lists become Typst lists. Review the output and run
# checkdata.py before committing.
#
# Usage:
#   python -I emit.py environments <in.json> <tier> > tier-N.typ
#   python -I emit.py items|consumables <in.json> > items.typ
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import structure  # noqa: E402

HEADER = """// {title}, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Extracted with scripts/srd ({tool}, emit.py) and cross-checked against
// the SRD text with checkdata.py. Text is verbatim except: line breaks
// joined; the SRD's inline emphasis is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": {imports}

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))
"""


def lit(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'


def slug(name):
    s = name.lower().replace('’', '').replace("'", '')
    return re.sub(r'[^a-z0-9]+', '-', s).strip('-')


def ident(name):
    # Typst identifiers can't start with a digit.
    s = slug(name)
    return s if not s[0].isdigit() else 'n-' + s


def option_lines(text, pad):
    """Markup lines for a paragraph; numbered options and roll-table rows
    (structure.py) become a list after their intro, words unchanged."""
    o = structure.options(text)
    if not o:
        return [pad + '  #' + lit(text)]
    kind, intro, items = o
    lines = [pad + '  #' + lit(intro), ''] if intro else []
    for label, t in items:
        lines.append(pad + (f'  {label}. #' + lit(t) if kind == 'numbered' else '  - #' + lit(f'{label}: {t}')))
    return lines


def body(blocks, indent):
    """One string, or a content block with paragraphs and lists."""
    if len(blocks) == 1 and 'text' in blocks[0] and not structure.options(blocks[0]['text']):
        return None, lit(blocks[0]['text'])
    pad = ' ' * indent
    lines = ['[']
    for i, b in enumerate(blocks):
        if i:
            lines.append('')
        if 'text' in b:
            lines += option_lines(b['text'], pad)
        else:
            lines += [pad + '  - #' + lit(x) for x in b['bullets']]
    lines.append(pad + ']')
    return '\n'.join(lines), None


def environments(data, tier):
    out = [HEADER.format(title=f'Tier {tier} environments', tool='environments.py',
                         imports='environment, environment-type, feature-kind, feature')]
    names = []
    for e in data:
        if e['tier'] != tier:
            continue
        n = ident(e['name'])
        names.append(n)
        diff = str(e['difficulty']) if isinstance(e['difficulty'], int) else lit(e['difficulty'])
        out.append(f'#let {n} = environment(')
        out.append(f'  id: {lit(slug(e["name"]))},')
        out.append(f'  name: {lit(e["name"])},')
        out.append(f'  tier: {e["tier"]},')
        out.append(f'  type: environment-type.{e["type"].lower()},')
        out.append(f'  description: {lit(e["description"])},')
        out.append(f'  impulses: {lit(e["impulses"])},')
        out.append(f'  difficulty: {diff},')
        out.append(f'  potential-adversaries: {lit(e["potential-adversaries"])},')
        out.append('  features: (')
        for f in e['features']:
            block, text = body(f['body'], 4)
            args = f'{lit(f["name"])}, kind: feature-kind.{f["kind"].lower()}, questions: {lit(f["questions"])}'
            if block:
                out.append(f'    feature({args}){block},')
            else:
                out.append(f'    feature({args}, {text}),')
        out.append('  ),')
        out.append(f'  flags: source({e["page"]}),')
        out.append(')\n')
    out.append('/// Every environment in this file, in SRD order.')
    out.append('#let entries = (' + ', '.join(names) + ',)')
    return '\n'.join(out) + '\n'


def loot(data, kind):
    title = {'item': 'Loot items', 'consumable': 'Consumables'}[kind]
    out = [HEADER.format(title=title, tool='loot.py', imports=f'{kind}, loot-collection')]
    names = []
    coll = {'Daggerheart Core Set': 'core-set', 'Hope & Fear Expansion Set': 'hope-and-fear'}
    for r in data:
        n = ident(r['name'])
        names.append(n)
        if len(r['paragraphs']) == 1:
            desc = lit(r['paragraphs'][0])
        else:
            desc = '[' + ' \\ '.join('#' + lit(p) for p in r['paragraphs']) + ']'
        out.append(f'#let {n} = {kind}(')
        out.append(f'  id: {lit(slug(r["name"]))},')
        out.append(f'  name: {lit(r["name"])},')
        out.append(f'  collection: loot-collection.{coll[r["collection"]]},')
        out.append(f'  roll: {lit(r["roll-text"])},')
        out.append(f'  description: {desc},')
        out.append(f'  flags: source({r["page"]}),')
        out.append(')\n')
    out.append(f'/// Every {kind} in this file, in SRD table order.')
    out.append('#let entries = (' + ', '.join(names) + ',)')
    return '\n'.join(out) + '\n'


if __name__ == '__main__':
    what, path = sys.argv[1], sys.argv[2]
    data = json.load(open(path, encoding='utf-8'))
    if what == 'environments':
        print(environments(data, int(sys.argv[3])), end='')
    else:
        print(loot(data, {'items': 'item', 'consumables': 'consumable'}[what]), end='')
