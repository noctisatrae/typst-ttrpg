# Part of scripts/srd (see README.md).
# Parse every adversary stat block from the cleaned SRD text into JSON.
#
#   parse_adversaries.py <clean.txt> <out.json>
#
# Names come from the SRD's own per-tier lists (p. 95-96), matched to the
# uppercase block headings; the tier comes from each block's "Tier N" line.
# Anything the parser cannot read cleanly is recorded in the block's
# "review" list (and printed), never guessed.
import sys, re, json

KINDS = ('Action', 'Reaction', 'Passive', 'Evolution')
TYPES = ('Bruiser', 'Horde', 'Leader', 'Minion', 'Ranged', 'Skulk', 'Social', 'Solo', 'Standard', 'Support')
RANGES = ('Melee', 'Very Close', 'Close', 'Far', 'Very Far')

text = open(sys.argv[1], encoding='utf-8').read()

# Split into (page, line) pairs.
lines, page = [], None
for raw in text.split('\n'):
    m = re.fullmatch(r'=====PAGE (\d+)=====', raw)
    if m:
        page = int(m.group(1))
        continue
    lines.append((page, raw))

# The per-tier lists of adversary names (pp. 95-96).
lists, tier = {}, None
for p, l in lines:
    if p not in (95, 96):
        continue
    m = re.match(r'TIER (\d) \(LEVEL', l)
    if m:
        tier = int(m.group(1))
        lists[tier] = []
    elif tier and l.startswith('• '):
        lists[tier].append(l[2:].strip())
    elif tier and lists[tier] and l.strip() and not re.fullmatch(r'\d+|Daggerheart SRD', l.strip()):
        lists[tier][-1] += ' ' + l.strip()   # a name wrapped onto two lines
names = {n.upper(): (t, n) for t, ns in lists.items() for n in ns}

# Keep only the stat block pages; drop page footers and section headings.
def noise(l):
    s = l.strip()
    return (s == '' or re.fullmatch(r'\d+', s) or s == 'Daggerheart SRD'
            or re.fullmatch(r'TIER \d ADVERSARIES \(LEVELS? [\d–-]+\)', s))
body = [(p, l.strip()) for p, l in lines if p and 97 <= p <= 158 and not noise(l)]

def join(ls):
    """Join wrapped lines: a line ending in a hyphen joins without a space."""
    out = ''
    for l in ls:
        if out and not out.endswith('-'):
            out += ' '
        out += l
    return out

# A block starts at its uppercase name, one or two lines above "Tier N ...".
starts = []
for i, (p, l) in enumerate(body):
    if re.match(r'Tier \d ', l):
        for k in (1, 2):
            cand = ' '.join(x for _, x in body[i - k:i]).upper()
            if cand in names:
                starts.append((i - k, i, cand))
                break
        else:
            starts.append((i - 1, i, body[i - 1][1].upper()))

blocks = []
for n, (s, t, upper) in enumerate(starts):
    end = starts[n + 1][0] if n + 1 < len(starts) else len(body)
    page = body[s][0]
    review = []
    tier_list, name = names.get(upper, (None, None))
    if name is None:
        name = upper.title()
        review.append(f'name {upper!r} is not in the SRD tier lists')
    a = {'name': name, 'page': page, 'review': review}

    m = re.fullmatch(r'Tier (\d) (\w+)(?: \((\d+)/HP\))?', body[t][1])
    if not m:
        review.append(f'tier line not understood: {body[t][1]!r}')
        a['tier'], a['type'] = None, None
    else:
        a['tier'], a['type'] = int(m.group(1)), m.group(2)
        if m.group(3):
            a['creatures-per-hp'] = int(m.group(3))
        if a['type'] not in TYPES:
            review.append(f'unknown type {a["type"]!r}')
        if tier_list is not None and tier_list != a['tier']:
            review.append(f'listed under Tier {tier_list} but block says Tier {a["tier"]}')

    rest = [l for _, l in body[t + 1:end]]
    # Section boundaries by their leading labels.
    def find(prefix, start=0):
        return next((i for i in range(start, len(rest)) if rest[i].startswith(prefix)), None)
    i_mot, i_dif, i_atk = find('Motives & Tactics:'), find('Difficulty:'), find('ATK:')
    i_exp, i_feat = find('Experience:'), find('FEATURES')
    if None in (i_mot, i_dif, i_atk):
        review.append('missing Motives, Difficulty or ATK line')
        blocks.append(a)
        continue
    i_after_atk = i_exp if i_exp is not None else (i_feat if i_feat is not None else len(rest))

    a['description'] = join(rest[:i_mot])
    a['motives'] = join(rest[i_mot:i_dif])[len('Motives & Tactics:'):].strip()

    stats = join(rest[i_dif:i_atk])
    m = re.fullmatch(r'Difficulty: (\d+) \| Thresholds: (None|\d+/(?:\d+|None)|None/\d+) \| HP: (\d+) \| Stress: (\d+|None)', stats)
    if not m:
        review.append(f'stats line not understood: {stats!r}')
    else:
        a['difficulty'] = int(m.group(1))
        th = m.group(2)
        if th == 'None':
            a['thresholds'] = {'major': None, 'severe': None}
        else:
            ma, se = th.split('/')
            a['thresholds'] = {'major': None if ma == 'None' else int(ma), 'severe': None if se == 'None' else int(se)}
        a['hp'] = int(m.group(3))
        a['stress'] = None if m.group(4) == 'None' else int(m.group(4))
        if a['stress'] is None:
            review.append('Stress is printed "None"')

    atk = join(rest[i_atk:i_after_atk])
    m = re.fullmatch(r'ATK: ([+−–-])(\d+(?:d\d+)?) \| (.+?): (Melee|Very Close|Close|Far|Very Far) \| (\S+?)( direct)? (phy/mag|phy|mag)', atk)
    if not m:
        review.append(f'attack line not understood: {atk!r}')
    else:
        if 'd' in m.group(2):
            # A dice modifier such as "+2d4" is kept as printed.
            mod = m.group(1) + m.group(2)
            review.append(f'attack modifier is a dice expression: {mod!r}')
        else:
            mod = int(m.group(2)) * (-1 if m.group(1) in '−–-' else 1)
        if m.group(1) in '–-':
            review.append(f'attack modifier sign is {m.group(1)!r}, not the SRD minus sign "−"')
        # Extraction sometimes leaves a space before the colon ("Staff : Far");
        # the printed book has none, so names are stripped.
        a['attack'] = {'modifier': mod, 'name': m.group(3).strip(), 'range': m.group(4), 'damage': m.group(5),
                       'damage-type': m.group(7), 'direct': bool(m.group(6))}

    a['experiences'] = []
    if i_exp is not None:
        exp = join(rest[i_exp:i_feat if i_feat is not None else len(rest)])[len('Experience:'):].strip()
        for part in exp.split(', '):
            m = re.fullmatch(r'(.+) ([+−-])(\d+)', part)
            if not m:
                review.append(f'experience not understood: {part!r} in {exp!r}')
                continue
            a['experiences'].append({'name': m.group(1).strip(), 'bonus': int(m.group(3)) * (-1 if m.group(2) in '−-' else 1)})

    a['features'] = []
    if i_feat is None:
        review.append('no FEATURES heading')
    else:
        head = re.compile(r'(.+?) - (' + '|'.join(KINDS) + r'): ?(.*)')
        cur = None
        feat_lines = rest[i_feat + 1:]
        for k, l in enumerate(feat_lines):
            # An all-caps line is a section heading (e.g. the Environments
            # chapter after the last block): the block ends here.
            if re.fullmatch(r"[A-Z0-9 ’'&:,()\-–]+", l) and sum(c.isalpha() for c in l) > 2:
                review.append(f'block ends at heading {l!r}')
                break
            m = head.fullmatch(l)
            # A feature name can wrap: "Long Name\nContinued - Action: ...".
            if not m and k + 1 < len(feat_lines) and (cur is None or cur['lines'][-1].endswith(('.', '!', '?', ')', '”'))):
                m2 = head.fullmatch(l + ' ' + feat_lines[k + 1])
                if m2 and ' - ' not in l and not head.fullmatch(feat_lines[k + 1]):
                    review.append(f'feature name wraps across lines: {m2.group(1)!r}')
            if m:
                cur = {'name': m.group(1).strip(), 'kind': m.group(2), 'lines': [m.group(3)] if m.group(3) else []}
                a['features'].append(cur)
            elif cur is None:
                review.append(f'text before the first feature: {l!r}')
            else:
                cur['lines'].append(l)
        for f in a['features']:
            f['body'] = join(f.pop('lines'))
            if re.search(r' - (' + '|'.join(KINDS) + r'):', f['body']):
                review.append(f'feature {f["name"]!r} body contains another feature header')
            if re.search(r'(Melee|Very Close|Close|Far|Very Far) \| \S+ (phy|mag)', f['body']):
                review.append(f'feature {f["name"]!r} contains a standard attack as text')
            if f['body'].endswith(':'):
                review.append(f'feature {f["name"]!r} ends with ":"; the features after it may belong to it '
                              '(stored flat, in SRD order)')
        names_seen = [f['name'] for f in a['features']]
        if len(set(names_seen)) != len(names_seen):
            review.append('duplicate feature names')

    for key in ('description', 'motives'):
        if a.get(key, '') == '':
            review.append(f'empty {key}')
    blocks.append(a)

found = {b['name'].upper() for b in blocks}
missing = [n for n in names.values() if n[1].upper() not in found]
dupes = sorted({b['name'] for b in blocks if sum(x['name'] == b['name'] for x in blocks) > 1})
json.dump({'lists': lists, 'blocks': blocks, 'missing': missing, 'duplicates': dupes},
          open(sys.argv[2], 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
print(f'{len(blocks)} blocks; listed per tier: ' + ', '.join(f'T{t}={len(n)}' for t, n in lists.items()))
print('missing from blocks:', missing)
print('duplicate blocks:', dupes)
for b in blocks:
    for r in b['review']:
        print(f'REVIEW p.{b["page"]} {b["name"]}: {r}')
