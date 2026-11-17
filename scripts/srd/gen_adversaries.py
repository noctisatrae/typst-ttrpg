# Part of scripts/srd (see README.md).
# Write one Typst file of adversaries per tier from parse_adversaries.py's
# JSON, in the order of the SRD's tier lists.
#
#   gen_adversaries.py <parsed.json> <tier> <out.typ>
#
# If <out.typ> already exists, entries whose id is unchanged are copied from
# it verbatim, so hand-checked entries stay byte-identical. Run crosscheck.py
# on the result before committing.
import sys, re, json, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import structure  # noqa: E402

parsed = json.load(open(sys.argv[1], encoding='utf-8'))
tier = int(sys.argv[2])
out_path = sys.argv[3]

KEYWORDS = {'none', 'auto', 'true', 'false', 'let', 'set', 'show', 'if', 'else', 'for', 'in', 'while',
            'break', 'continue', 'return', 'import', 'include', 'as', 'not', 'and', 'or', 'context'}

def slug(name):
    """Kebab-case of the SRD name; apostrophes are dropped (Will-o’-the-Wisps -> will-o-the-wisps)."""
    s = re.sub(r"[’']", '', name.lower())
    s = re.sub(r'[^a-z0-9]+', '-', s).strip('-')
    assert s and s[0].isalpha() and s not in KEYWORDS, s
    return s

def string(s):
    return '"' + s.replace('\\', '\\\\').replace('"', '\\"') + '"'

def markup(s):
    """Escape plain text so Typst markup renders it unchanged."""
    s = re.sub(r'([\\*_`#$<>@\[\]~\'"=])', r'\\\1', s)
    s = s.replace('//', '/\\/').replace('--', '-\\-').replace('...', '.\\..')
    # A list, enum or term marker at the start would turn the body into a list.
    s = re.sub(r'^([-+/]|\d+\.)', r'\\\1', s)
    return s

def body_markup(s):
    """The body as markup; numbered options and roll-table rows become a
    list after their intro (structure.py), words unchanged."""
    o = structure.options(s)
    if not o:
        return markup(s)
    kind, intro, items = o
    lines = [markup(intro), ''] if intro else []
    for label, text in items:
        lines.append(f'{label}. ' + markup(text) if kind == 'numbered' else '- ' + markup(f'{label}: {text}'))
    return '\n'.join(lines)

def feature_call(f, indent):
    pad = ' ' * indent
    head = f'{pad}feature({string(f["name"])}, kind: feature-kind.{KIND[f["kind"]]}'
    if f.get('children'):
        kids = '\n'.join(feature_call(c, indent + 4) for c in f['children'])
        head += f', features: (\n{kids}\n{pad})'
    return head + f')[{body_markup(f["body"])}],'

TYPE = {'Bruiser': 'bruiser', 'Horde': 'horde', 'Leader': 'leader', 'Minion': 'minion', 'Ranged': 'ranged',
        'Skulk': 'skulk', 'Social': 'social', 'Solo': 'solo', 'Standard': 'standard', 'Support': 'support'}
KIND = {'Action': 'action', 'Reaction': 'reaction', 'Passive': 'passive', 'Evolution': 'evolution'}
RANGE = {'Melee': 'melee', 'Very Close': 'very-close', 'Close': 'close', 'Far': 'far', 'Very Far': 'very-far'}
DAMAGE = {'phy': 'physical', 'mag': 'magic', 'phy/mag': 'physical-or-magic'}

def num(v):
    return 'none' if v is None else str(v)

def entry(a):
    id = slug(a['name'])
    at = a['attack']
    mod = string(at['modifier']) if isinstance(at['modifier'], str) else str(at['modifier'])
    attack = (f"(modifier: {mod}, name: {string(at['name'])}, range: attack-range.{RANGE[at['range']]}, "
              f"damage: {string(at['damage'])}, damage-type: damage-type.{DAMAGE[at['damage-type']]}"
              + (', direct: true' if at['direct'] else '') + ')')
    lines = [f'#let {id} = adversary(',
             f'  id: {string(id)},',
             f'  name: {string(a["name"])},',
             f'  tier: {a["tier"]},',
             f'  type: adversary-type.{TYPE[a["type"]]},']
    if 'creatures-per-hp' in a:
        lines.append(f'  creatures-per-hp: {a["creatures-per-hp"]},')
    lines += [f'  description: {string(a["description"])},',
              f'  motives: {string(a["motives"])},',
              f'  difficulty: {a["difficulty"]},',
              f'  thresholds: (major: {num(a["thresholds"]["major"])}, severe: {num(a["thresholds"]["severe"])}),',
              f'  hp: {a["hp"]},']
    if a['stress'] is not None:   # omitted when the SRD prints "None"
        lines.append(f'  stress: {a["stress"]},')
    lines += [f'  attack: {attack},']
    if a['experiences']:
        xs = ', '.join(f'(name: {string(x["name"])}, bonus: {x["bonus"]})' for x in a['experiences'])
        lines.append(f'  experiences: ({xs}{"," if len(a["experiences"]) == 1 else ""}),')
    lines.append('  features: (')
    for f in structure.nest(a['features'])[0]:
        lines.append(feature_call(f, 4))
    lines += ['  ),', f'  flags: source({a["page"]}),', ')']
    return id, '\n'.join(lines)

# Order: the SRD tier list; a block whose heading differs from its list
# entry (e.g. "Corrupter" vs "Corruptor") takes that entry's place.
order = parsed['lists'][str(tier)]
blocks = [b for b in parsed['blocks'] if b['tier'] == tier]
by_upper = {b['name'].upper(): b for b in blocks}
ordered = [by_upper.pop(n.upper()) for n in order if n.upper() in by_upper]
for missing in [n for n in order if n.upper() not in {b['name'].upper() for b in ordered}]:
    # Place unmatched blocks at the position of the unmatched list name.
    if by_upper:
        ordered.insert(order.index(missing), by_upper.pop(next(iter(by_upper))))
ordered += list(by_upper.values())

existing = {}
if os.path.exists(out_path):
    old = open(out_path, encoding='utf-8').read()
    for m in re.finditer(r'(?ms)^#let ([a-z0-9-]+) = adversary\(\n.*?^\)$', old):
        existing[m.group(1)] = m.group(0)

ids, parts = [], []
for a in ordered:
    id, text = entry(a)
    ids.append(id)
    parts.append(existing.get(id, text))

level = {1: 'LEVEL 1', 2: 'LEVELS 2–4', 3: 'LEVELS 5–7', 4: 'LEVELS 8–10'}[tier]
header = f'''// Tier {tier} adversaries ({level.lower()}), transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Text is verbatim except: line breaks joined; the SRD's inline emphasis
// (bold/italic inside feature text) is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.
// Generated by scripts/srd/gen_adversaries.py and checked with
// scripts/srd/crosscheck.py; review notes are in the commit history.

#import "@local/heartweaver:0.1.0": adversary, adversary-type, feature-kind, attack-range, damage-type, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))
'''
body = '\n\n'.join(parts)
footer = '\n\n/// Every adversary in this file, in the order of the SRD tier list.\n#let entries = (\n' + ''.join(f'  {i},\n' for i in ids) + ')\n'
open(out_path, 'w', encoding='utf-8').write(header + '\n' + body + footer)
print(f'tier {tier}: {len(ids)} entries ({sum(i in existing for i in ids)} kept verbatim) -> {out_path}')
