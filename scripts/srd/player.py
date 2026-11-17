# Part of scripts/srd (see README.md).
# Parsers for player-facing SRD content, from font runs (runs.py): classes
# and subclasses, ancestries, communities, domain cards, weapons (including
# combat wheelchairs) and armor. Each parser returns (records, review), where
# review lists anything unusual for a human; nothing is guessed.
#
# The SRD sets every part of these blocks in its own font:
#   EvelethClean*        headings (class, subclass, ancestry, community names)
#   QuestaSans-Bold      ALL-CAPS labels ("DOMAINS – ", "ANCESTRY FEATURES"),
#                        card names, table names, and inline emphasis
#   QuestaSans-BoldItalic feature names, ending in ":"
#   everything else      body text (whitespace runs carry line breaks)
# Names are matched against the SRD's own lists (p. 4 and each class's
# "Choose either the X or Y subclass"), never invented from headings.
import re

TRAITS = ('Agility', 'Strength', 'Finesse', 'Instinct', 'Presence', 'Knowledge')
# Arcane-Frame wheelchairs attack with "Spellcast" (p. 71): the wielder's
# Spellcast trait.
WEAPON_TRAITS = TRAITS + ('Spellcast',)
RANGES = ('Melee', 'Very Close', 'Close', 'Far', 'Very Far')
BURDENS = ('One-Handed', 'Two-Handed')
DAMAGE = re.compile(r'^(d\d+(?:[+−-]\d+)?) (phy|mag|phy/mag)$')
CARD_LINE = re.compile(r'^Level (\d+) (\w+) (Ability|Spell|Grimoire)$')
RECALL = re.compile(r'^Recall Cost: (\d+)$')
SMALL = {'of', 'the', 'a', 'an', 'and', 'or', 'to', 'in', 'on', 'at', 'for', 'by', 'from', 'with', 'into'}


def norm(s):
    # A line that ends in a hyphen continues a compound ("sucker-" / "bearing").
    s = re.sub(r'-[ \t]*\n\s*', '-', s)
    return re.sub(r'\s+', ' ', s).strip()


def caps(s):
    return re.sub(r'\s+', ' ', s.replace('’', "'")).strip().upper()


def slug(name):
    s = name.lower().replace('’', '').replace("'", '')
    return re.sub(r'[^a-z0-9]+', '-', s).strip('-')


def title_case(s):
    """Title case for names printed only in capitals (domain cards)."""
    words = s.strip().split()
    out = []
    for i, w in enumerate(words):
        lw = w.lower()
        if i and lw in SMALL:
            out.append(lw)
        else:
            out.append('-'.join(p[:1].upper() + p[1:] for p in lw.split('-')))
    return ' '.join(out)


def body_blocks(text):
    """Split body text into paragraphs and bullet lists ("•" and "◦")."""
    blocks = []
    for line in text.split('\n'):
        line = line.strip()
        if not line:
            continue
        if line[0] in '•◦':
            item = line[1:].strip()
            if blocks and 'bullets' in blocks[-1]:
                blocks[-1]['bullets'].append(item)
            else:
                blocks.append({'bullets': [item]})
        elif blocks and 'bullets' in blocks[-1]:
            blocks[-1]['bullets'][-1] += ('' if blocks[-1]['bullets'][-1].endswith('-') else ' ') + line
        elif blocks:
            blocks[-1]['text'] += ('' if blocks[-1]['text'].endswith('-') else ' ') + line
        else:
            blocks.append({'text': line})
    for b in blocks:
        if 'text' in b:
            b['text'] = norm(b['text'])
        else:
            b['bullets'] = [norm(x) for x in b['bullets']]
    return [b for b in blocks if b.get('text') or b.get('bullets')]


def is_heading(font):
    return font.startswith('EvelethClean')


def is_label(font, t):
    return font == 'QuestaSans-Bold' and len(t) >= 4 and t == t.upper() and re.search(r'[A-Z]{3}', t)


def is_fname(font, t):
    return font == 'QuestaSans-BoldItalic' and t.endswith(':')


ODD_NAMES = []   # feature names the SRD prints unusually, for the review


def tokens(rs):
    """(kind, text, page): heading, label, fname or text (raw, with line
    breaks). A BoldItalic name after a sub-bullet "◦" stays text.

    Feature names are BoldItalic and end in ":", but the SRD also splits
    them ("Hex" + ":"), puts the colon in the next bold run ("Ranger’s
    Focus" + ": Spend a Hope"), or ends one with "." ("Maestro."); the last
    two only count at the start of a line and are reported."""
    rs = list(rs)
    out = []
    last = ''
    line_start = True
    i = 0
    while i < len(rs):
        page, font, text = rs[i]
        t = text.strip()
        if t and font == 'QuestaSans-BoldItalic' and last not in ('◦', '•'):
            name, j = t, i + 1
            while j < len(rs) and rs[j][1] == 'QuestaSans-BoldItalic' and rs[j][2].strip() and '\n' not in rs[j][2]:
                name += rs[j][2] if rs[j][2].strip() == ':' else ' ' + rs[j][2].strip()
                j += 1
            name = name.strip()
            nxt = rs[j][2] if j < len(rs) else ''
            if name.endswith(':'):
                out.append(('fname', name[:-1].strip(), page))
                i, last, line_start = j, ':', False
                continue
            if line_start and nxt.lstrip().startswith(':'):
                ODD_NAMES.append(f'p.{page}: feature name {name!r} has its colon in the next run')
                out.append(('fname', name, page))
                rs[j] = (rs[j][0], rs[j][1], nxt.lstrip()[1:])
                i, last, line_start = j, ':', False
                continue
            # "Maestro." starts a feature only if its text follows on the
            # same line ("subclass." ending a sentence does not).
            if line_start and name.endswith('.') and len(name) < 40 and nxt.strip() and '\n' not in nxt[:1]:
                ODD_NAMES.append(f'p.{page}: feature name {name!r} ends with "." instead of ":"')
                out.append(('fname', name[:-1].strip(), page))
                i, last, line_start = j, '.', False
                continue
        if t and is_heading(font):
            out.append(('heading', t, page))
        elif t and is_label(font, t):
            out.append(('label', t, page))
        else:
            out.append(('text', text, page))
        if t:
            last = t
            line_start = False
        if '\n' in text and not t:
            line_start = True
        elif t and is_label(font, t) or t and is_heading(font):
            line_start = True
        i += 1
    return out


def name_list(rs, pattern):
    """Comma-separated names after `pattern` in plain text (p. 4 lists)."""
    text = norm(''.join(t for _, _, t in rs))
    m = re.search(pattern + r'\s*(.+?)\.', text)
    if not m:
        raise SystemExit(f'name list not found: {pattern!r}')
    names = re.split(r',\s*(?:and\s+)?|\s+and\s+', m.group(1))
    return [n.strip() for n in names if n.strip()]


class Feature(dict):
    pass


def new_feature(name, page):
    return {'name': name, 'raw': '', 'page': page}


def finish(f):
    f['body'] = body_blocks(f.pop('raw'))
    return f


def heritage(rs, names, label, kind):
    """Ancestries or communities: heading with a known name, description,
    `label` ("ANCESTRY FEATURES"/"COMMUNITY FEATURE"), then features."""
    by_caps = {caps(n): n for n in names}
    out, review, cur, feat, mode = [], [], None, None, None

    def close():
        nonlocal cur, feat
        if feat:
            cur['features'].append(finish(feat))
        feat = None
        if cur:
            cur['description'] = norm(cur.pop('raw'))
            out.append(cur)
        cur = None

    for k, t, page in tokens(rs):
        if k == 'heading':
            close()
            if caps(t) in by_caps:
                cur = {'name': by_caps[caps(t)], 'page': page, 'raw': '', 'features': []}
                mode = 'desc'
            continue
        if cur is None:
            continue
        if k == 'label':
            if caps(t).startswith(label):
                mode = 'features'
            else:
                review.append(f'p.{page}: {cur["name"]}: unexpected label {t!r}')
            continue
        if k == 'fname' and mode == 'features':
            if feat:
                cur['features'].append(finish(feat))
            feat = new_feature(t, page)
            continue
        if feat:
            feat['raw'] += t
        elif mode == 'desc':
            cur['raw'] += t
    close()
    found = {c['name'] for c in out}
    for n in names:
        if n not in found:
            review.append(f'{kind} {n!r} from the SRD list was not found')
    want = 2 if kind == 'ancestry' else 1
    for c in out:
        if len(c['features']) != want:
            review.append(f'p.{c["page"]}: {kind} {c["name"]} has {len(c["features"])} features, expected {want}')
    return out, review


SUBCLASS_STEPS = {'FOUNDATION': 'foundation', 'SPECIALIZATION': 'specialization', 'MASTERY': 'mastery'}


def classes(rs, names):
    """Classes and their subclasses (pp. 9-31)."""
    by_caps = {caps(n): n for n in names}
    out, subs, review = [], [], []
    cls = sub = feat = None
    mode = None        # desc, field:<name>, hope, features, sub-intro, sub-desc, trait, step:<s>, questions, connections
    sub_names = {}

    def close_feat():
        nonlocal feat
        if feat is None:
            return
        f = finish(feat)
        if mode == 'hope':
            if cls.get('hope-feature'):
                review.append(f'p.{f["page"]}: {cls["name"]} has more than one Hope feature')
            cls['hope-feature'] = f
        elif mode == 'features':
            cls['features'].append(f)
        elif mode and mode.startswith('step:') and sub:
            sub[mode[5:]].append(f)
        else:
            review.append(f'p.{f["page"]}: feature {f["name"]!r} outside a feature section ({mode})')
        feat = None

    def close_sub():
        nonlocal sub
        close_feat()
        if sub:
            sub['description'] = norm(sub.pop('raw'))
            sub['spellcast-trait'] = norm(sub.pop('trait-raw')) or None
            subs.append(sub)
        sub = None

    def close_class():
        nonlocal cls
        close_sub()
        if cls:
            cls['description'] = norm(cls.pop('raw'))
            for key in ('domains', 'evasion', 'hp', 'items'):
                cls[key] = norm(cls[key])
            cls['domains'] = [d.strip() for d in cls['domains'].split('&')]
            for key in ('evasion', 'hp'):
                if cls[key].isdigit():
                    cls[key] = int(cls[key])
                else:
                    review.append(f'p.{cls["page"]}: {cls["name"]}: {key} {cls[key]!r} is not a number')
                    cls[key] = None
            cls['background-questions'] = [q for b in body_blocks(cls.pop('bq-raw')) for q in b.get('bullets', [])]
            cls['connections'] = [q for b in body_blocks(cls.pop('cq-raw')) for q in b.get('bullets', [])]
            out.append(cls)
        cls = None

    pending = ''
    skipped = {}       # class -> [(page, heading)] of sections this parser skips
    for k, t, page in tokens(rs):
        if k == 'heading':
            c = caps(t)
            if c in by_caps:
                close_class()
                cls = {'name': by_caps[c], 'page': page, 'raw': '', 'domains': '', 'evasion': '',
                       'hp': '', 'items': '', 'features': [], 'bq-raw': '', 'cq-raw': ''}
                mode = 'desc'
                continue
            if cls and c == caps(cls['name']) + ' SUBCLASSES':
                close_sub()
                mode = 'sub-intro'
                cls['sub-intro'] = ''
                continue
            if cls:
                key = caps(pending + ' ' + t) if pending else c
                if key in sub_names:
                    close_sub()
                    pending = ''
                    sub = {'name': sub_names[key], 'class': cls['name'], 'page': page, 'raw': '',
                           'trait-raw': '', 'foundation': [], 'specialization': [], 'mastery': []}
                    mode = 'sub-desc'
                    continue
                if any(s.startswith(key) for s in sub_names):
                    pending = (pending + ' ' + t).strip()
                    continue
                # Another section (MARTIAL STANCES, Beastform options, ...):
                # not part of this parser; stop collecting until the next
                # known label or heading.
                close_feat()
                mode = None
                skipped.setdefault(cls['name'], []).append((page, t))
            continue
        if cls is None:
            continue
        if k == 'label':
            c = caps(t)
            field = {'DOMAINS –': 'domains', 'STARTING EVASION –': 'evasion',
                     'STARTING HIT POINTS –': 'hp', 'CLASS ITEMS –': 'items'}.get(c)
            known = field or c.endswith('HOPE FEATURE') or c in ('CLASS FEATURE', 'CLASS FEATURES', 'SPELLCAST TRAIT',
                                                                   'BACKGROUND QUESTIONS', 'CONNECTIONS') \
                or (c.split()[0] in SUBCLASS_STEPS and c.split()[-1] in ('FEATURE', 'FEATURES'))
            if not known:
                if feat:
                    # A sub-heading inside a feature (the Brawler's STANCES):
                    # keep it as a line of the feature's text.
                    feat['raw'] += '\n' + t + '\n'
                elif mode is not None:
                    skipped.setdefault(cls['name'], []).append((page, t))
                    mode = None
                continue
            close_feat()
            if field:
                mode = 'field:' + field
            elif c.endswith('HOPE FEATURE'):
                mode = 'hope'
            elif c in ('CLASS FEATURE', 'CLASS FEATURES'):
                mode = 'features'
            elif c == 'SPELLCAST TRAIT':
                mode = 'trait'
            elif c.split()[0] in SUBCLASS_STEPS and c.split()[-1] in ('FEATURE', 'FEATURES'):
                mode = 'step:' + SUBCLASS_STEPS[c.split()[0]]
            elif c == 'BACKGROUND QUESTIONS':
                close_sub()
                mode = 'questions'
            elif c == 'CONNECTIONS':
                mode = 'connections'
            else:
                # Inline all-caps emphasis inside a body; keep it as text.
                if feat:
                    feat['raw'] += t
                else:
                    review.append(f'p.{page}: {cls["name"]}: unexpected label {t!r}')
            continue
        if k == 'fname' and mode in ('hope', 'features') or (k == 'fname' and mode and mode.startswith('step:')):
            close_feat()
            feat = new_feature(t, page)
            continue
        if feat:
            feat['raw'] += t
            continue
        if mode and mode.startswith('field:'):
            cls[mode[6:]] += t
        elif mode == 'desc':
            cls['raw'] += t
        elif mode == 'sub-intro':
            cls['sub-intro'] += t
            m = re.search(r'Choose either the (.+?) or (?:the )?(.+?) subclass', norm(cls['sub-intro']))
            if m:
                sub_names = {caps(m.group(1)): m.group(1), caps(m.group(2)): m.group(2)}
        elif mode == 'sub-desc' and sub:
            sub['raw'] += t
        elif mode == 'trait' and sub:
            sub['trait-raw'] += t
        elif mode == 'questions':
            cls['bq-raw'] += t
        elif mode == 'connections':
            cls['cq-raw'] += t
    close_class()

    for name, secs in skipped.items():
        pp = sorted({p for p, _ in secs})
        review.append(f'pp.{pp[0]}-{pp[-1]}: {name}: sections not parsed (class extras, not a kind yet): '
                      + ', '.join(t for _, t in secs[:6]) + (f', … ({len(secs)} in all)' if len(secs) > 6 else ''))
    for c in out:
        c.pop('sub-intro', None)
        if not c.get('hope-feature'):
            review.append(f'p.{c["page"]}: {c["name"]} has no Hope feature')
        if len(c['domains']) != 2:
            review.append(f'p.{c["page"]}: {c["name"]} domains {c["domains"]!r}')
    for s in subs:
        if s['spellcast-trait'] not in (None,) + TRAITS:
            review.append(f'p.{s["page"]}: {s["name"]} spellcast trait {s["spellcast-trait"]!r}')
        for step in SUBCLASS_STEPS.values():
            if not s[step]:
                review.append(f'p.{s["page"]}: {s["name"]} has no {step} features')
    found = {c['name'] for c in out}
    for n in names:
        if n not in found:
            review.append(f'class {n!r} from the SRD list was not found')
    per = {}
    for s in subs:
        per.setdefault(s['class'], []).append(s['name'])
    for c in out:
        if len(per.get(c['name'], [])) != 2:
            review.append(f'{c["name"]}: subclasses found {per.get(c["name"], [])}')
    return out, subs, review


def cards(rs):
    """Domain cards (appendix): "<DOMAIN> DOMAIN" headings, then for each
    card a bold ALL-CAPS name, "Level N Domain Type", "Recall Cost: N" and
    either plain text or named features."""
    out, review = [], []
    domain = None
    items = [(p, f, t) for p, f, t in rs]
    i = 0
    cur = feat = None

    def close():
        nonlocal cur, feat
        if feat:
            cur['features'].append(finish(feat))
            feat = None
        if cur:
            cur['text'] = body_blocks(cur.pop('raw'))
            out.append(cur)
        cur = None

    def next_bold(j):
        while j < len(items) and not items[j][2].strip():
            j += 1
        return j

    last = ''
    while i < len(items):
        page, font, text = items[i]
        t = text.strip()
        if t and is_heading(font):
            m = re.match(r'^(\w+) DOMAIN$', caps(t))
            if m:
                close()
                domain = m.group(1).title()
            i += 1
            continue
        if t and font == 'QuestaSans-Bold' and t == t.upper() and re.search(r'[A-Z]{2}', t):
            j = next_bold(i + 1)
            name = t
            # Names may wrap over several bold runs.
            while j < len(items) and items[j][1] == 'QuestaSans-Bold' and not CARD_LINE.match(items[j][2].strip()) \
                    and items[j][2].strip() == items[j][2].strip().upper():
                name += ' ' + items[j][2].strip()
                j = next_bold(j + 1)
            if j < len(items) and CARD_LINE.match(items[j][2].strip()):
                close()
                m = CARD_LINE.match(items[j][2].strip())
                k = next_bold(j + 1)
                r = RECALL.match(items[k][2].strip()) if k < len(items) else None
                if not r:
                    review.append(f'p.{page}: card {name!r}: no Recall Cost line')
                if m.group(2) != domain:
                    review.append(f'p.{page}: card {name!r} says domain {m.group(2)} under {domain}')
                cur = {'name': title_case(name), 'caps': name, 'page': page, 'domain': m.group(2),
                       'level': int(m.group(1)), 'type': m.group(3),
                       'recall-cost': int(r.group(1)) if r else None, 'raw': '', 'features': []}
                i = (k + 1) if r else (j + 1)
                last = ''
                continue
        if cur is not None:
            if t and is_fname(font, t) and last not in ('◦', '•'):
                if feat:
                    cur['features'].append(finish(feat))
                feat = new_feature(t[:-1].strip(), page)
            elif feat:
                feat['raw'] += text
            else:
                cur['raw'] += text
        if t:
            last = t
        i += 1
    close()
    for c in out:
        if c['features'] and c['text']:
            # Text before the first named feature (an introduction).
            review.append(f'p.{c["page"]}: card {c["name"]} has text before its named features')
    return out, review


def table_rows(rs, columns):
    """Rows of a weapon/armor table: a bold name (may wrap), then one
    regular run per column, then the feature: a bold-italic name and its
    text, or "—". Section headings and bold sub-headings are reported as
    ('section', text) so callers can track tier and category."""
    rows, review = [], []
    # Whitespace runs are dropped: a table cell or name never spans a
    # paragraph, and names wrap over bold runs separated by line breaks.
    items = [(p, f, t) for p, f, t in rs if t.strip()]
    header = {'Name', 'Tier', 'Trait', 'Range', 'Damage', 'Burden', 'Feature', 'Base', 'Thresholds', 'Score',
              'Base Thresholds', 'Base Score'}
    in_table = False
    i = 0
    while i < len(items):
        page, font, text = items[i]
        t = text.strip()
        if is_heading(font):
            if t in header:
                in_table = True
            else:
                in_table = False
                rows.append(('section', t, page))
            i += 1
            continue
        if font == 'QuestaSans-Bold' and t in ('Physical Weapons', 'Magic Weapons', 'Light Frame Models',
                                                'Heavy Frame Models', 'Arcane Frame Models'):
            rows.append(('section', t, page))
            i += 1
            continue
        if not in_table:
            i += 1
            continue
        if font == 'QuestaSans-Bold' and t in header:
            i += 1     # header cells set in bold on some tables
            continue
        if font == 'QuestaSans-Bold':
            name = t
            j = i + 1
            while j < len(items) and items[j][1] == 'QuestaSans-Bold':
                name += ' ' + items[j][2].strip()
                j += 1
            cells = []
            while j < len(items) and items[j][1].startswith('QuestaSans') \
                    and items[j][1] not in ('QuestaSans-Bold', 'QuestaSans-BoldItalic') and items[j][2].strip() != '—':
                cells.append(items[j][2].strip())
                j += 1
            feat_name, feat_raw = None, ''
            if j < len(items) and items[j][2].strip() == '—':
                j += 1
            elif j < len(items) and items[j][1] == 'QuestaSans-BoldItalic':
                ft = items[j][2].strip()
                feat_name = ft[:-1].strip() if ft.endswith(':') else ft
                j += 1
                while j < len(items) and items[j][1] not in ('QuestaSans-Bold',) and not is_heading(items[j][1]):
                    feat_raw += ' ' + items[j][2].strip()
                    j += 1
            # A cell that wrapped ("d8+3" / "phy/mag") is joined back.
            if len(cells) > columns:
                for k in range(len(cells) - 1):
                    if cells[k + 1] in ('phy', 'mag', 'phy/mag') and re.match(r'^d\d', cells[k]):
                        cells[k:k + 2] = [cells[k] + ' ' + cells[k + 1]]
                        break
            rows.append(('row', {'name': norm(name), 'cells': cells, 'feature': feat_name,
                                 'feature-text': norm(feat_raw), 'page': page}, page))
            i = j
            continue
        i += 1
    return rows, review


def weapons(rs):
    """Weapon tables (pp. 56-69) and combat wheelchair tables (pp. 70-71)."""
    out, review = [], []
    rows, review = table_rows(rs, 4)
    category, tier, wheelchair = None, None, None
    for kind, r, page in rows:
        if kind == 'section':
            c = caps(r)
            if 'PRIMARY WEAPON' in c:
                category = 'Primary'
            elif 'SECONDARY WEAPON' in c:
                category = 'Secondary'
            m = re.match(r'^TIER (\d)', c)
            if m:
                tier = int(m.group(1))
            if 'FRAME MODELS' in c:
                category, wheelchair = 'Primary', r.split()[0].lower()
            continue
        cells = r['cells']
        rec = {'name': r['name'], 'page': r['page'], 'category': category, 'tier': tier,
               'feature': r['feature'], 'feature-text': r['feature-text']}
        if wheelchair:
            rec['frame'] = wheelchair
            if cells and cells[0].isdigit():
                rec['tier'] = int(cells.pop(0))
        if len(cells) != 4:
            review.append(f'p.{page}: weapon {r["name"]!r}: cells {cells!r}')
            continue
        rec['trait'], rec['range'], dmg, rec['burden'] = cells
        m = DAMAGE.match(dmg)
        problems = []
        if rec['trait'] not in WEAPON_TRAITS:
            problems.append(f'trait {rec["trait"]!r}')
        if rec['range'] not in RANGES:
            problems.append(f'range {rec["range"]!r}')
        if rec['burden'] not in BURDENS:
            problems.append(f'burden {rec["burden"]!r}')
        if not m:
            problems.append(f'damage {dmg!r}')
        if problems or not category or not tier:
            review.append(f'p.{page}: weapon {r["name"]!r}: ' + ', '.join(problems or ['no tier/category']))
            continue
        rec['damage'], rec['damage-type'] = m.group(1).replace('−', '-'), m.group(2)
        out.append(rec)
    return out, review


def armor(rs):
    """Armor tables (p. 72+): name, "M / S" base thresholds, base score,
    feature."""
    out = []
    rows, review = table_rows(rs, 2)
    tier = None
    for kind, r, page in rows:
        if kind == 'section':
            m = re.match(r'^TIER (\d)', caps(r))
            if m:
                tier = int(m.group(1))
            continue
        cells = r['cells']
        m = re.match(r'^(\d+) / (\d+)$', cells[0]) if cells else None
        if len(cells) != 2 or not m or not cells[1].isdigit() or not tier:
            review.append(f'p.{page}: armor {r["name"]!r}: cells {cells!r}')
            continue
        out.append({'name': r['name'], 'page': r['page'], 'tier': tier,
                    'major': int(m.group(1)), 'severe': int(m.group(2)), 'score': int(cells[1]),
                    'feature': r['feature'], 'feature-text': r['feature-text']})
    return out, review
