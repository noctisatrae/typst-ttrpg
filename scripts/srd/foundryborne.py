# Part of scripts/srd (see README.md).
# Independent cross-check against a local clone of the Foundryborne system
# (https://github.com/Foundryborne/daggerheart), used by build.py
# --foundryborne. Their packs (src/packs) are read as untrusted data, only to
# COMPARE: entities are matched by name, and every disagreement is reported
# with our SRD page. Our data always comes from the SRD text; nothing here
# changes it, and nothing of theirs is copied into the repo.
#
# Their active effects (on weapons, armor, features) are listed as
# SUGGESTIONS for effects.typ; an overlay entry is added by hand only when
# the SRD wording states a permanent, unconditional effect.
import glob
import json
import os
import re

RANGES = {'melee': 'Melee', 'veryClose': 'Very Close', 'close': 'Close', 'far': 'Far', 'veryFar': 'Very Far'}
BURDEN = {'oneHanded': 'One-Handed', 'twoHanded': 'Two-Handed'}
# Their effect change keys -> our modifier keys.
KEYS = {
    'system.evasion': 'evasion',
    'system.damageThresholds.major': 'major',
    'system.damageThresholds.severe': 'severe',
    'system.resources.hitPoints.max': 'hp',
    'system.resources.stress.max': 'stress',
    'system.proficiency': 'proficiency',
    'system.bonuses.roll.bonus': 'attack',
}


def slug(name):
    s = name.lower().replace('’', '').replace("'", '')
    return re.sub(r'[^a-z0-9]+', '-', s).strip('-')


def key(name):
    return re.sub(r'[^a-z0-9]', '', name.lower().replace('’', "'"))


def load(root):
    docs = {}
    for f in sorted(glob.glob(os.path.join(root, 'src', 'packs', '**', '*.json'), recursive=True)):
        try:
            d = json.load(open(f, encoding='utf-8'))
        except (ValueError, OSError):
            continue
        if isinstance(d, dict) and d.get('name') and d.get('type'):
            docs.setdefault((d['type'], key(d['name'])), d)
    return docs


def effect_changes(d):
    """(our key or their key, value) for each change of each effect."""
    out = []
    for e in d.get('effects', []):
        for ch in (e.get('system') or {}).get('changes') or e.get('changes') or []:
            if 'key' in ch:
                k = ch['key']
                m = re.match(r'system\.traits\.(\w+)\.value', k)
                ours = m.group(1) if m else KEYS.get(k, k)
                out.append((e.get('name'), ours, ch.get('value')))
            elif ch.get('type') == 'armor':
                out.append((e.get('name'), 'armor-score', (ch.get('value') or {}).get('max')))
    return out


OURS = set(KEYS.values()) | {'armor-score', 'agility', 'strength', 'finesse', 'instinct', 'presence', 'knowledge'}


def compare(root, out, covered=lambda kind, owner, name: False):
    """Returns (summary, review notes, effect suggestions). `covered(kind,
    owner id, feature)` says whether effects.typ already has an entry;
    only stat changes our overlay can express, on uncovered features, are
    suggested."""
    docs = load(root)
    notes, suggest = [], []
    sources = sorted({(d.get('system') or {}).get('attribution', {}).get('source') or '' for d in docs.values()} - {''})
    system = json.load(open(os.path.join(root, 'system.json'), encoding='utf-8'))
    counts = {}
    for (t, _) in docs:
        counts[t] = counts.get(t, 0) + 1

    def diff(kind, ours, theirs, field, page):
        if ours != theirs:
            notes.append(f'p.{page}: {kind} {field}: SRD (ours) {ours!r}, Foundryborne {theirs!r}')

    def find(t, name, page, kind):
        d = docs.get((t, key(name)))
        if d is None:
            notes.append(f'p.{page}: {kind} {name!r}: not in Foundryborne')
        return d

    def suggest_from(kind, ours_id, name, d, page):
        for ename, k, v in effect_changes(d):
            if k in OURS and not covered(kind.replace(' ', '-'), slug(ours_id), ename):
                suggest.append(f'p.{page}: {kind} {ours_id} / {ename}: Foundryborne effect {k} {v!r}')

    for r in out.get('weapons', []):
        d = find('weapon', r['name'], r['page'], 'weapon')
        if not d:
            continue
        s = d['system']
        a = s.get('attack') or {}
        dmg = ((a.get('damage') or {}).get('main') or {})
        v = dmg.get('value') or {}
        types = dmg.get('type') or []
        dtype = 'phy/mag' if set(types) == {'physical', 'magical'} else {'physical': 'phy', 'magical': 'mag'}.get(types[0] if types else '', types)
        theirs_damage = (v.get('dice') or '') + (f'+{v["bonus"]}' if v.get('bonus') else '')
        label = f'{r["name"]}'
        diff('weapon ' + label, r['tier'], s.get('tier'), 'tier', r['page'])
        diff('weapon ' + label, r['category'], 'Secondary' if s.get('secondary') else 'Primary', 'category', r['page'])
        diff('weapon ' + label, r['burden'], BURDEN.get(s.get('burden'), s.get('burden')), 'burden', r['page'])
        diff('weapon ' + label, r['range'], RANGES.get(a.get('range'), a.get('range')), 'range', r['page'])
        trait = ((a.get('roll') or {}).get('trait') or '')
        diff('weapon ' + label, r['trait'].lower(), trait.lower() if trait else 'spellcast', 'trait', r['page'])
        diff('weapon ' + label, r['damage'], theirs_damage, 'damage', r['page'])
        diff('weapon ' + label, r['damage-type'], dtype, 'damage type', r['page'])
        suggest_from('weapon', r['name'], r['name'], d, r['page'])
    for r in out.get('armor', []):
        d = find('armor', r['name'], r['page'], 'armor')
        if not d:
            continue
        s = d['system']
        diff('armor ' + r['name'], r['tier'], s.get('tier'), 'tier', r['page'])
        diff('armor ' + r['name'], (r['major'], r['severe']),
             ((s.get('baseThresholds') or {}).get('major'), (s.get('baseThresholds') or {}).get('severe')), 'base thresholds', r['page'])
        diff('armor ' + r['name'], r['score'], (s.get('armor') or {}).get('max'), 'base score', r['page'])
        suggest_from('armor', r['name'], r['name'], d, r['page'])
    if 'classes' in out:
        cls, subs = out['classes']
        for c in cls:
            d = find('class', c['name'], c['page'], 'class')
            if not d:
                continue
            s = d['system']
            diff('class ' + c['name'], c['evasion'], s.get('evasion'), 'starting Evasion', c['page'])
            diff('class ' + c['name'], c['hp'], s.get('hitPoints'), 'starting HP', c['page'])
            diff('class ' + c['name'], sorted(x.lower() for x in c['domains']), sorted(s.get('domains') or []), 'domains', c['page'])
        for sc in subs:
            d = find('subclass', sc['name'], sc['page'], 'subclass')
            if not d:
                continue
            theirs = (d['system'].get('spellcastingTrait') or None)
            diff('subclass ' + sc['name'], (sc['spellcast-trait'] or '').lower() or None, theirs, 'spellcast trait', sc['page'])
    for r in out.get('cards', []):
        d = find('domainCard', r['name'], r['page'], 'domain card')
        if not d:
            continue
        s = d['system']
        diff('domain card ' + r['name'], r['level'], s.get('level'), 'level', r['page'])
        diff('domain card ' + r['name'], r['domain'].lower(), s.get('domain'), 'domain', r['page'])
        diff('domain card ' + r['name'], r['recall-cost'], s.get('recallCost'), 'recall cost', r['page'])
        diff('domain card ' + r['name'], r['type'].lower(), s.get('type'), 'type', r['page'])
        suggest_from('domain card', r['name'], r['name'], d, r['page'])
    for kind, t in (('ancestries', 'ancestry'), ('communities', 'community')):
        for r in out.get(kind, []):
            find(t, r['name'], r['page'], t)
    # Features (class, subclass, ancestry, community) are separate documents
    # of type "feature" in their packs: suggestions by feature name.
    seen = set()
    for kind, owner, name, text, page in feature_list(out):
        d = docs.get(('feature', key(name)))
        if d and (owner, name) not in seen:
            seen.add((owner, name))
            for ename, k, v in effect_changes(d):
                if k in OURS and not covered(kind, slug(owner), name):
                    suggest.append(f'p.{page}: {kind} {owner} / {name}: Foundryborne effect {k} {v!r}')
    summary = (f'Foundryborne {system.get("version")} packs ({", ".join(sources)}): '
               + ', '.join(f'{t} {n}' for t, n in sorted(counts.items()) if t in
                           ('weapon', 'armor', 'class', 'subclass', 'domainCard', 'ancestry', 'community',
                            'adversary', 'environment', 'transformation'))
               + f'; {len(notes)} disagreements')
    return summary, notes, suggest


def feature_list(out):
    feats = []
    if 'classes' in out:
        cls, subs = out['classes']
        for c in cls:
            for f in [c['hope-feature']] + c['features']:
                feats.append(('class', c['name'], f['name'], '', f['page']))
        for s in subs:
            for step in ('foundation', 'specialization', 'mastery'):
                for f in s[step]:
                    feats.append(('subclass', s['name'], f['name'], '', f['page']))
    for key_, kind in (('ancestries', 'ancestry'), ('communities', 'community')):
        for r in out.get(key_, []):
            for f in r['features']:
                feats.append((kind, r['name'], f['name'], '', f['page']))
    return feats
