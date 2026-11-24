# Part of scripts/srd (see README.md).
# One entry point: SRD PDF -> daggerheart-srd Typst data, cross-checked.
#
#   python -I scripts/srd/build.py <srd.pdf> [--kinds a,b,...] [--check]
#                                  [--work DIR] [--foundryborne PATH]
#
# Kinds: adversaries, environments, loot, classes, ancestries, communities,
# transformations, beastforms, stances, cards, weapons, armor, everyday-hero (default: all). Extraction runs once per PDF and is
# cached in the work directory (default: a "srd-build" folder in the system
# temp dir). Output is deterministic: rebuilding gives no git diff.
#
# --check rebuilds each entity's text from the emitted Typst data (via
# `typst query`) and looks for it in a second extraction of the PDF (plain
# page text), ignoring case and whitespace; any miss is reported.
# --foundryborne compares our entities with a local clone of the Foundryborne
# system (packs), by name, and reports disagreements; it never changes data.
#
# A REVIEW report (printed, and written to <work>/review.md) lists anything
# unusual. Nothing is guessed: the parsers report what they can't read.
# Run typst with the package path that resolves @local/* to this checkout
# (TYPST_PACKAGE_PATH is passed through).
import argparse
import hashlib
import json
import os
import pickle
import re
import shutil
import subprocess
import sys
import tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import pypdf  # noqa: E402

import emit  # noqa: E402
import emit_player  # noqa: E402
import player  # noqa: E402
import structure  # noqa: E402
from runs import clean, runs  # noqa: E402

ROOT = os.path.dirname(os.path.dirname(HERE))
SRD = os.path.join(ROOT, 'packages', 'daggerheart-srd', 'src')
KINDS = ('adversaries', 'environments', 'loot', 'classes', 'ancestries', 'communities', 'transformations', 'beastforms', 'stances', 'cards', 'weapons', 'armor', 'everyday-hero')
REVIEW = []


def note(section, items):
    for i in items:
        REVIEW.append((section, i))


# ----------------------------------------------------------------------
# Extraction, cached per PDF.

def cached(work, pdf):
    digest = hashlib.sha256(open(pdf, 'rb').read()).hexdigest()[:16]
    path = os.path.join(work, f'runs-{digest}.pkl')
    if os.path.exists(path):
        return pickle.load(open(path, 'rb'))
    reader = pypdf.PdfReader(pdf)
    data = {'runs': runs(pdf, 1, len(reader.pages)),
            'raw': {i + 1: p.extract_text() for i, p in enumerate(reader.pages)}}
    pickle.dump(data, open(path, 'wb'))
    return data


def pages(data, first, last):
    return [r for r in data['runs'] if first <= r[0] <= last]


def heading_page(data, pattern, after=1):
    """First page at or after `after` with a heading run matching
    `pattern` (the PDF outline lacks pages for some sections)."""
    for p, f, t in data['runs']:
        if p >= after and f.startswith('EvelethClean') and re.search(pattern, t.strip()):
            return p
    raise SystemExit(f'heading {pattern!r} not found')


def ranges(data):
    r = {}
    r['classes'] = (heading_page(data, r'^Class Domains$'), heading_page(data, r'^ANCESTRIES$') - 1)
    r['ancestries'] = (heading_page(data, r'^ANCESTRIES$'), heading_page(data, r'^COMMUNITIES$'))
    r['communities'] = (heading_page(data, r'^COMMUNITIES$'), heading_page(data, r'^TRANSFORMATIONS$'))
    r['transformations'] = (heading_page(data, r'^TRANSFORMATIONS$'), heading_page(data, r'^CORE MECHANICS$') - 1)
    # The parser stops at the first heading after the forms that is not a tier.
    first = heading_page(data, r'^BEASTFORM OPTIONS$')
    r['beastforms'] = (first, first + 4)
    first = heading_page(data, r'^EVERYDAY HERO STARTING EQUIPMENT$')
    r['everyday-hero'] = (first, first + 1)
    first = heading_page(data, r'^MARTIAL STANCES$')
    r['stances'] = (first, first + 1)
    r['weapons'] = (heading_page(data, r'^PRIMARY WEAPON TABLES$'), heading_page(data, r'^ARMOR$') - 1)
    r['armor'] = (heading_page(data, r'^ARMOR$'), heading_page(data, r'^LOOT$') - 1)
    r['items'] = (heading_page(data, r'^LOOT$'), heading_page(data, r'^CONSUMABLES$') - 1)
    r['consumables'] = (heading_page(data, r'^CONSUMABLES$'), heading_page(data, r'^GOLD$'))
    r['cards'] = (heading_page(data, r'^Domain Card reference$'), max(p for p, _, _ in data['runs']))
    r['environments'] = (heading_page(data, r'^ENVIRONMENT STAT BLOCKS BY TIER$'),
                         heading_page(data, r'^ADDITIONAL GM$', 160) - 1)
    return r


def write(path, text):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    old = open(path, encoding='utf-8').read() if os.path.exists(path) else None
    if old != text:
        open(path, 'w', encoding='utf-8').write(text)
    return old != text


# ----------------------------------------------------------------------
# Kinds.

def build_player(data, rg, kinds, out):
    p4 = pages(data, 4, 4)
    if 'classes' in kinds:
        names = player.name_list(p4, r'There are 13 classes in this SRD:')
        cls, subs, rev = player.classes(pages(data, *rg['classes']), names)
        note('classes', rev)
        out['classes'] = (cls, subs)
        write(os.path.join(SRD, 'player', 'classes.typ'), emit_player.classes(cls, subs))
        comp, rev = player.companion(pages(data, *rg['classes']))
        note('companion', rev)
        write(os.path.join(SRD, 'player', 'companion.typ'), emit_player.companion(comp))
    for kind, label, key in (('ancestry', 'ANCESTRY FEATURE', 'ancestries'), ('community', 'COMMUNITY FEATURE', 'communities')):
        if key not in kinds:
            continue
        names = player.name_list(p4, rf'Take the card for one of the following {key}, then write its name in the Heritage field of your character sheet:')
        recs, rev = player.heritage(pages(data, *rg[key]), names, label, kind)
        note(key, rev)
        out[key] = recs
        write(os.path.join(SRD, 'player', f'{key}.typ'), emit_player.heritage(recs, kind))
    if 'transformations' in kinds:
        recs, rev = player.transformations(pages(data, *rg['transformations']))
        note('transformations', rev)
        out['transformations'] = recs
        write(os.path.join(SRD, 'player', 'transformations.typ'), emit_player.transformations(recs))
    if 'beastforms' in kinds:
        recs, rev = player.beastforms(pages(data, *rg['beastforms']))
        note('beastforms', rev)
        out['beastforms'] = recs
        write(os.path.join(SRD, 'player', 'beastforms.typ'), emit_player.beastforms(recs))
    if 'stances' in kinds:
        recs, rev = player.stances(pages(data, *rg['stances']))
        note('stances', rev)
        out['stances'] = recs
        write(os.path.join(SRD, 'player', 'stances.typ'), emit_player.stances(recs))
    if 'cards' in kinds:
        recs, rev = player.cards(pages(data, *rg['cards']))
        note('cards', rev)
        out['cards'] = recs
        write(os.path.join(SRD, 'player', 'domain-cards.typ'), emit_player.cards(recs))
    if 'weapons' in kinds:
        recs, rev = player.weapons(pages(data, *rg['weapons']))
        note('weapons', rev)
        out['weapons'] = recs
        write(os.path.join(SRD, 'player', 'weapons.typ'), emit_player.weapons(recs))
    if 'armor' in kinds:
        recs, rev = player.armor(pages(data, *rg['armor']))
        note('armor', rev)
        out['armor'] = recs
        write(os.path.join(SRD, 'player', 'armor.typ'), emit_player.armor(recs))
    if 'everyday-hero' in kinds:
        w, ar, rev = player.everyday_hero(pages(data, *rg['everyday-hero']))
        note('everyday hero', rev)
        out['everyday-hero'] = (w, ar)
        ws, ars = emit_player.everyday_hero(w, ar)
        write(os.path.join(SRD, 'player', 'everyday-hero-weapons.typ'), ws)
        write(os.path.join(SRD, 'player', 'everyday-hero-armor.typ'), ars)
    note('feature names', sorted(set(player.ODD_NAMES)))
    note('glyphs', sorted({f'p.{p}: a {f} glyph mapped to "{t.strip()}"' for p, f, t in data['runs']
                           if f.startswith('Wingdings')}))


def run_tool(args, stdout=None):
    r = subprocess.run([sys.executable, '-I', *args], capture_output=True, text=True, cwd=ROOT)
    if r.returncode != 0:
        raise SystemExit(f'{args[0]} failed:\n{r.stderr}')
    note(os.path.basename(args[0]), [l[len('REVIEW '):] for l in r.stderr.splitlines() if l.startswith('REVIEW ')])
    return r.stdout


def build_adversaries(pdf, work):
    raw = os.path.join(work, 'raw.txt')
    clean_txt = os.path.join(work, 'clean.txt')
    if not os.path.exists(clean_txt):
        run_tool([os.path.join(HERE, 'extract.py'), pdf, raw])
        run_tool([os.path.join(HERE, 'clean.py'), raw, clean_txt])
    parsed = os.path.join(work, 'adversaries.json')
    note('adversaries', [l for l in run_tool([os.path.join(HERE, 'parse_adversaries.py'), clean_txt, parsed]).splitlines()
                         if 'REVIEW' in l])
    for tier in (1, 2, 3, 4):
        tmp = os.path.join(work, f'tier-{tier}.typ')
        if os.path.exists(tmp):
            os.remove(tmp)    # generate from scratch (gen keeps existing entries)
        run_tool([os.path.join(HERE, 'gen_adversaries.py'), parsed, str(tier), tmp])
        write(os.path.join(SRD, 'adversaries', f'tier-{tier}.typ'), open(tmp, encoding='utf-8').read())


def env_names(data, first):
    """Environment names from the SRD's own list (p. 159): "Name (Type)"."""
    text = ''.join(t for p, f, t in pages(data, first, first + 1))
    names = []
    for item in text.split('•')[1:]:
        m = re.match(r'\s*(.+?)\s*\((Exploration|Social|Traversal|Event)\)', player.norm(item))
        if m:
            names.append(m.group(1))
    return names


def build_environments(pdf, data, rg, work):
    first, last = rg['environments']
    names = env_names(data, first)
    nfile = os.path.join(work, 'env-names.txt')
    open(nfile, 'w', encoding='utf-8').write('\n'.join(names) + '\n')
    js = os.path.join(work, 'environments.json')
    open(js, 'w', encoding='utf-8').write(run_tool([os.path.join(HERE, 'environments.py'), pdf, str(first + 1), str(last), nfile]))
    envs = json.load(open(js, encoding='utf-8'))
    found = {re.sub(r'\bthe ', '', e['name'], flags=re.I) for e in envs}
    note('environments', [f'{n!r} from the p.{first} list was not found' for n in names
                          if re.sub(r'\bthe ', '', n, flags=re.I) not in found])
    tiers = sorted({e['tier'] for e in envs})
    for tier in tiers:
        write(os.path.join(SRD, 'environments', f'tier-{tier}.typ'), emit.environments(envs, tier))
    return tiers


def build_loot(pdf, rg, work):
    for kind, key in (('items', 'items'), ('consumables', 'consumables')):
        first, last = rg[key]
        js = os.path.join(work, f'{key}.json')
        open(js, 'w', encoding='utf-8').write(run_tool([os.path.join(HERE, 'loot.py'), pdf, str(first), str(last)]))
        write(os.path.join(SRD, 'loot', f'{key}.typ'),
              emit.loot(json.load(open(js, encoding='utf-8')), {'items': 'item', 'consumables': 'consumable'}[kind]))


# ----------------------------------------------------------------------
# Structures stored as flat text, pending a decision on how to model them:
# numbered options and roll tables inside a feature, and features that
# introduce others (forms, "while Channeling" lists).

NUMBERED = re.compile(r'(^|[\s:.])1\.\s.+?\s2\.\s')
ROLL_ROWS = re.compile(r'\b\d+\s*[–-]\s*\d+\s*:|(^|\s)\d+\s*:\s')


def scan_structures(work, out):
    found = []

    def look(where, page, name, text):
        o = structure.options(text)
        if o:
            found.append(f'p.{page}: {where} {name!r}: {o[0]} options -> a list of {len(o[2])} items')
        if structure.introduces(name, text):
            found.append(f'p.{page}: {where} {name!r}: introduces the features after it -> children')

    adv = os.path.join(work, 'adversaries.json')
    if os.path.exists(adv):
        for a in json.load(open(adv, encoding='utf-8')).get('blocks', []):
            for f in a.get('features', []):
                look('adversary ' + a['name'], a['page'], f['name'], f.get('body') or '')
    env = os.path.join(work, 'environments.json')
    if os.path.exists(env):
        for e in json.load(open(env, encoding='utf-8')):
            for f in e.get('features', []):
                text = ' '.join(b.get('text', '') or ' '.join(b.get('bullets', [])) for b in f.get('body', []))
                look('environment ' + e['name'], e['page'], f['name'], text)
    for kind, owner, name, text, page in all_features(out):
        look(f'{kind} {owner}', page, name, text)
    return found


# ----------------------------------------------------------------------
# Effects overlay: stale entries and suggestions.

SUGGEST = [
    (r'[+−-]\d+ (to )?Evasion', 'evasion'),
    (r'permanent [+−-]\d+ bonus to your (Evasion|Armor Score|damage thresholds|Severe damage threshold|Major damage threshold)', 'permanent'),
    (r'bonus to your (Evasion|Armor Score|damage thresholds) equal to', 'derived'),
    (r'[+−-]\d+ to (Agility|Strength|Finesse|Instinct|Presence|Knowledge)', 'trait'),
    (r'[+−-]\d+ to all character traits', 'traits'),
    (r'[+−-]\d+ to Armor Score', 'armor-score'),
    (r'[+−-]\d+ to attack rolls', 'attack'),
    (r'[+−-]\d+ to (your )?damage thresholds', 'thresholds'),
    (r'additional Hit Point slot', 'hp'),
    (r'additional Stress slot', 'stress'),
    (r'additional domain card', 'grant'),
    (r'[+−-]\d+ (bonus )?to your Proficiency', 'proficiency'),
]


# Suggestions a human read in the SRD and found situational (a cost, a
# trigger or "for that attack"), so they stay text only. Keyed like the
# overlay, "<owner>/<Feature>". Reviewed 2026-11-17 against SRD 2.0.
SITUATIONAL = {
    'juggernaut/Pummeljoy', 'martial-artist/Keen Defenses',
    'warden-of-the-elements/Elemental Incarnation', 'warden-of-the-elements/Elemental Dominion',
    'vengeance/Act of Reprisal', 'wayfinder/Ruthless Predator', 'elemental-origin/Transcendence',
    'pact-of-the-endless/Patron’s Mantle', 'moon/Lunar Phases',
    'deadly-focus/Deadly Focus', 'i-see-it-coming/I See It Coming', 'deathrun/Deathrun',
    'siphon-essence/Siphon Essence', 'voice-of-reason/Voice of Reason',
    'blitz-hammer/Accelerator', 'midas-scythe/Greedy', 'hatchet/Follow-Up',
    'improved-hatchet/Follow-Up', 'advanced-hatchet/Follow-Up', 'legendary-hatchet/Follow-Up',
    'eldritch-vambrace/Deflecting', 'buckler/Deflecting', 'powered-gauntlet/Charged',
}


def overlay_keys():
    text = open(os.path.join(SRD, 'effects.typ'), encoding='utf-8').read()
    return set(re.findall(r'^\s*"([^"]+)":', text, re.M))


def all_features(out):
    """(kind, owner id, name, text, page) for every feature emitted."""
    def txt(f):
        return ' '.join(b.get('text', '') or ' '.join(b.get('bullets', [])) for b in f['body'])
    feats = []
    if 'classes' in out:
        cls, subs = out['classes']
        for c in cls:
            for f in [c['hope-feature']] + c['features']:
                feats.append(('class', player.slug(c['name']), f['name'], txt(f), f['page']))
        for s in subs:
            for step in ('foundation', 'specialization', 'mastery'):
                for f in s[step]:
                    feats.append(('subclass', player.slug(s['name']), f['name'], txt(f), f['page']))
    for key, kind in (('ancestries', 'ancestry'), ('communities', 'community'), ('transformations', 'transformation'), ('beastforms', 'beastform')):
        for r in out.get(key, []):
            for f in r['features']:
                feats.append((kind, player.slug(r['name']), f['name'], txt(f), f['page']))
    for r in out.get('cards', []):
        for f in r['features']:
            feats.append(('domain-card', player.slug(r['name']), f['name'], txt(f), f['page']))
        if r['text']:
            feats.append(('domain-card', player.slug(r['name']), r['name'], txt({'body': r['text']}), r['page']))
    hero = out.get('everyday-hero', ([], []))
    for recs, kind in ((out.get('weapons', []) + hero[0], 'weapon'), (out.get('armor', []) + hero[1], 'armor')):
        for r in recs:
            if r['feature']:
                feats.append((kind, player.slug(r['name']), r['feature'], r['feature-text'], r['page']))
    return feats


def check_overlay(out):
    keys = overlay_keys()
    feats = all_features(out)
    used = set()
    by_kind_name = {}
    for kind, owner, name, text, page in feats:
        by_kind_name.setdefault(f'{kind}:{name}', set()).add(text)
        for k in (f'{owner}/{name}', f'{kind}:{name}'):
            if k in keys:
                used.add(k)
    note('effects overlay', [f'entry {k!r} matches no feature' for k in sorted(keys - used)])
    for k in sorted(keys):
        if ':' in k and '/' not in k and len(by_kind_name.get(k, ())) > 1:
            note('effects overlay', [f'kind-wide entry {k!r} covers different texts: {sorted(by_kind_name[k])}'])
    suggestions = []
    for kind, owner, name, text, page in feats:
        # A Beastform's features apply only while transformed, never to
        # the character's own numbers.
        if kind == 'beastform':
            continue
        if f'{owner}/{name}' in keys or f'{kind}:{name}' in keys or f'{owner}/{name}' in SITUATIONAL:
            continue
        for pat, what in SUGGEST:
            m = re.search(pat, text)
            if m:
                suggestions.append(f'p.{page}: {kind} {owner} / {name}: "{m.group(0)}" ({what})')
                break
    return suggestions


# ----------------------------------------------------------------------
# Cross-check: rebuild text from the Typst data, find it in the PDF text.

EXPORT = r'''
#import "@local/daggerheart-srd:0.1.0" as srd
#let plain(c) = if c == none { "" } else if type(c) == str { c } else if c.func() == enum.item { str(c.number) + ". " + plain(c.body) } else if c.has("text") { c.text } else if c.has("children") { c.children.map(plain).join(" ") } else if c.has("body") { plain(c.body) } else if c.has("child") { plain(c.child) } else { " " }
#let feats(fs) = fs.map(f => (name: f.name, body: plain(f.body)))
#let clean(e) = {
  let out = (:)
  for (k, v) in e {
    if k in ("features", "foundation", "specialization", "mastery") { out.insert(k, feats(v)) }
    else if k == "hope-feature" { out.insert(k, (name: v.name, body: plain(v.body))) }
    else if k == "text" or k == "description" { out.insert(k, plain(v)) }
    else if type(v) != function { out.insert(k, v) }
  }
  out
}
#metadata((
  classes: srd.classes.values().map(clean),
  subclasses: srd.subclasses.values().map(clean),
  ancestries: srd.ancestries.values().map(clean),
  communities: srd.communities.values().map(clean),
  transformations: srd.transformations.values().map(clean),
  beastforms: srd.beastforms.values().map(clean),
  stances: srd.stances.values().map(clean),
  stance-rules: (name: "Martial Stances", flags: srd.martial-stances.flags, description: srd.martial-stances.description,
    rules: feats(srd.martial-stances.rules), focus: srd.martial-stances.focus,
    start: srd.martial-stances.start, per-level: srd.martial-stances.per-level),
  cards: srd.cards.values().map(clean),
  weapons: srd.weapons.values().map(clean),
  armors: srd.armors.values().map(clean),
  hero-weapons: srd.everyday-hero.weapons.values().map(clean),
  hero-armors: srd.everyday-hero.armors.values().map(clean),
  companion: (
    name: "Ranger Companion", flags: srd.ranger-companion.flags,
    rules: feats(srd.ranger-companion.rules),
    training: feats(srd.ranger-companion.training.values()),
    examples: srd.ranger-companion.example-experiences,
  ),
)) <export>
'''


def squash(s):
    s = s.replace('\uf0e0', '→').replace('−', '-').replace('–', '-').replace('’', "'").replace('“', '"').replace('”', '"')
    # Bullets and the colon or period after a feature name are layout, not
    # content: the SRD prints "Maestro." where others have "Name:".
    return re.sub(r'[\s•◦:.]+', '', s).lower()


def check_player(data, work):
    path = os.path.join(work, 'export.typ')
    open(path, 'w', encoding='utf-8').write(EXPORT)
    r = subprocess.run(['typst', 'query', '--root', '/', path, '<export>', '--field', 'value', '--one'],
                       capture_output=True, text=True, env=os.environ)
    if r.returncode != 0:
        raise SystemExit('typst query failed:\n' + r.stderr)
    ex = json.loads(r.stdout)
    # The footer ("33" + "Daggerheart SRD") can land mid-sentence in this
    # extraction, at a column break; drop it.
    page_text = {p: squash(clean(re.sub(rf'(^|\n){p}\s*\nDaggerheart SRD', '\n', t)))
                 for p, t in data['raw'].items()}

    def near(page):
        return ''.join(page_text.get(p, '') for p in range(page - 1, page + 3))

    misses, counts = [], {}

    def want(kind, e, *parts):
        counts[kind] = counts.get(kind, 0) + 1
        page = e['flags']['source']['page']
        hay = near(page)
        for part in parts:
            if part and squash(part) not in hay:
                misses.append(f'p.{page}: {kind} {e["name"]}: not found in the PDF text: {part[:90]!r}')

    def fparts(fs):
        return [f['name'] + ':' + f['body'] for f in fs]

    for e in ex['classes']:
        want('class', e, e['description'], 'DOMAINS – ' + ' & '.join(e['domains']),
             f'STARTING EVASION – {e["evasion"]}', f'STARTING HIT POINTS – {e["hp"]}', 'CLASS ITEMS – ' + e['items'],
             e['hope-feature']['name'] + ':' + e['hope-feature']['body'], *fparts(e['features']),
             *e['background-questions'], *e['connections'])
    for e in ex['subclasses']:
        want('subclass', e, e['description'], *(['SPELLCAST TRAIT ' + e['spellcast-trait']] if e.get('spellcast-trait') else []),
             *fparts(e['foundation']), *fparts(e['specialization']), *fparts(e['mastery']))
    for key, kind in (('ancestries', 'ancestry'), ('communities', 'community')):
        for e in ex[key]:
            want(kind, e, e['name'], e['description'], *fparts(e['features']))
    e = ex['stance-rules']
    words = {1: 'one', 2: 'two', 3: 'three', 4: 'four'}
    rules = ' '.join(f['body'] for f in e['rules'])
    want('stance rules', e, e['description'], *[f['name'] + ' ' + f['body'] for f in e['rules']])
    for claim in (f'You can hold a maximum of {e["focus"]} Focus', f'You choose {words[e["start"]]} stances from Tier 1',
                  'Mark a new stance from your tier or below each time you gain a level' if e['per-level'] == 1 else '(per-level not 1)'):
        if claim not in rules:
            misses.append(f'stance rules: number not stated in the rules: {claim!r}')
    by_tier = {}
    for s in ex['stances']:
        by_tier.setdefault(s['tier'], []).append(s)
    for tier, ss in sorted(by_tier.items()):
        want('stance', ss[0], f'TIER {tier} ' + ' '.join(f'{s["name"]}: {s["text"]}' for s in ss))
    for e in ex['beastforms']:
        parts = [e['name'].upper()]
        if e.get('examples'):
            parts.append('(' + e['examples'] + ')')
        if e.get('trait'):
            parts.append(f'{e["trait"]} +{e["trait-bonus"]} | Evasion +{e["evasion-bonus"]}')
        if e.get('attack'):
            a = e['attack']
            first = (a['trait'], a['range']) if e['flags'].get('attack-printed') == 'trait-first' else (a['range'], a['trait'])
            parts.append(f'{first[0]} {first[1]} {a["damage"]} {a["damage-type"]}')
        if e.get('advantages'):
            parts.append('Gain advantage on: ' + ', '.join(e['advantages']))
        want('beastform', e, ' '.join(parts), *fparts(e['features']))
    for e in ex['transformations']:
        want('transformation', e, e['name'], e['description'], *fparts(e['features']),
             'TRANSFORMATION QUESTIONS ' + ' '.join(e['questions']))
        for t in e.get('tracks', []):
            if f'hold up to {t["boxes"]} tokens' not in ' '.join(f['body'] for f in e['features']):
                misses.append(f'transformation {e["name"]}: track {t["name"]} ({t["boxes"]}) not stated in its features')
    for e in ex['cards']:
        want('domain card', e, f'{e["name"]} Level {e["level"]} {e["domain"]} {e["type"]} Recall Cost: {e["recall-cost"]}',
             e.get('text', ''), *fparts(e.get('features', [])))
    for e in ex['weapons']:
        tier = str(e['tier']) if 'combat-wheelchair' in e.get('tags', []) else ''
        feat = fparts(e['features'])[0] if e['features'] else '—'
        want('weapon', e, f'{e["name"]} {tier} {e["trait"]} {e["range"]} {e["damage"]} {e["damage-type"]} {e["burden"]} {feat}')
    for e in ex['hero-weapons']:
        feat = fparts(e['features'])[0] if e['features'] else ''
        want('everyday hero weapon', e, f'{e["name"]} {e["trait"]} {e["range"]} {e["damage"]} {e["damage-type"]} {e["burden"]} {feat}')
    for e in ex['hero-armors']:
        feat = fparts(e['features'])[0] if e['features'] else ''
        want('everyday hero armor', e, f'{e["name"]} {e["thresholds"]["major"]} / {e["thresholds"]["severe"]} {e["score"]} {feat}')
    for e in ex['armors']:
        feat = fparts(e['features'])[0] if e['features'] else '—'
        want('armor', e, f'{e["name"]} {e["thresholds"]["major"]} / {e["thresholds"]["severe"]} {e["score"]} {feat}')
    e = ex['companion']
    want('companion', e, ', '.join(e['examples']), *[f['name'] + ' ' + f['body'] for f in e['rules']],
         *fparts(e['training']))
    return counts, misses


def check_others(work, kinds):
    """The existing checkers for adversaries (crosscheck.py) and
    environments/loot (checkdata.py)."""
    results = []
    if 'adversaries' in kinds:
        path = os.path.join(work, 'export-adv.typ')
        open(path, 'w', encoding='utf-8').write('''#import "@local/daggerheart-srd:0.1.0": adversaries
// Text as printed: list items get their own spacing, numbered items their
// number; a parent's children follow it (crosscheck.py reads a flat list).
#let plain(c) = if type(c) == str { c } else if c.func() == enum.item { " " + str(c.number) + ". " + plain(c.body) + " " } else if c.func() == list.item { " " + plain(c.body) + " " } else if c.has("text") { c.text } else if c.has("children") { c.children.map(plain).join() } else if c.func() == parbreak or c == [ ] { " " } else { panic(repr(c)) }
#let flat(fs) = fs.map(f => ((f + (body: plain(f.body))),) + flat(f.at("features", default: ()))).flatten()
#metadata(adversaries.values().map(t => t.values()).flatten().map(a => a + (features: flat(a.features)))) <data>
''')
        r = subprocess.run(['typst', 'query', '--root', '/', path, '<data>', '--field', 'value', '--one'],
                           capture_output=True, text=True, env=os.environ)
        if r.returncode:
            raise SystemExit('typst query failed:\n' + r.stderr)
        js = os.path.join(work, 'adv-data.json')
        open(js, 'w', encoding='utf-8').write(r.stdout)
        results.append(('adversaries', run_tool([os.path.join(HERE, 'crosscheck.py'), js, os.path.join(work, 'clean.txt')])))
    if kinds & {'environments', 'loot'}:
        path = os.path.join(work, 'export-env.typ')
        open(path, 'w', encoding='utf-8').write('''#import "@local/daggerheart-srd:0.1.0" as srd
#let plain(c) = if type(c) == str { c } else if c.func() == enum.item { str(c.number) + ". " + plain(c.body) } else if c.func() == list.item { "• " + plain(c.body) } else if c.has("text") { c.text } else if c.has("children") { c.children.map(plain).join(" ") } else if c.has("body") { plain(c.body) } else { " " }
#let flat(e) = e + (features: e.at("features", default: ()).map(f => f + (body: plain(f.body))), description: plain(e.description))
#metadata((
  environments: srd.environments.values().map(t => t.values()).flatten().map(flat),
  items: srd.items.values().map(flat),
  consumables: srd.consumables.values().map(flat),
)) <data>
''')
        r = subprocess.run(['typst', 'query', '--root', '/', path, '<data>', '--field', 'value', '--one'],
                           capture_output=True, text=True, env=os.environ)
        if r.returncode:
            raise SystemExit('typst query failed:\n' + r.stderr)
        js = os.path.join(work, 'env-data.json')
        open(js, 'w', encoding='utf-8').write(r.stdout)
        # checkdata.py exits 1 when anything differs; its output says what.
        c = subprocess.run([sys.executable, '-I', os.path.join(HERE, 'checkdata.py'), js, os.path.join(work, 'raw.txt')],
                           capture_output=True, text=True, cwd=ROOT)
        results.append(('environments and loot', c.stdout + c.stderr))
    return results


def main():
    ap = argparse.ArgumentParser(description='SRD PDF -> daggerheart-srd Typst data')
    ap.add_argument('pdf')
    ap.add_argument('--kinds', default=','.join(KINDS))
    ap.add_argument('--check', action='store_true')
    ap.add_argument('--check-only', action='store_true', help='check the existing data without regenerating it')
    ap.add_argument('--work', default=os.path.join(tempfile.gettempdir(), 'srd-build'))
    ap.add_argument('--foundryborne')
    a = ap.parse_args()
    kinds = set(a.kinds.split(','))
    unknown = kinds - set(KINDS)
    if unknown:
        raise SystemExit(f'unknown kinds {sorted(unknown)}; known: {", ".join(KINDS)}')
    os.makedirs(a.work, exist_ok=True)
    data = cached(a.work, a.pdf)
    rg = ranges(data)
    out = {}
    if a.check_only:
        a.check = True
        clean_txt = os.path.join(a.work, 'clean.txt')
        if 'adversaries' in kinds and not os.path.exists(clean_txt):
            raise SystemExit('--check-only needs a previous full build in the same --work directory')
    else:
        build_player(data, rg, kinds, out)
        if 'adversaries' in kinds:
            build_adversaries(a.pdf, a.work)
        if 'environments' in kinds:
            build_environments(a.pdf, data, rg, a.work)
        if 'loot' in kinds:
            build_loot(a.pdf, rg, a.work)
    suggestions = check_overlay(out) if out else []
    if not a.check_only:
        note('structures (options become lists, introduced features become children)', scan_structures(a.work, out))

    lines = ['# SRD build review', '']
    counts = {k: (f'{len(v[0])} weapons + {len(v[1])} armor' if k == 'everyday-hero'
                  else f'{len(v[0])} + {len(v[1])} subclasses' if isinstance(v, tuple)
                  else f'{len(v["stances"])} + rules' if k == 'stances' else len(v)) for k, v in out.items()}
    lines.append('Counts: ' + ', '.join(f'{k} {v}' for k, v in counts.items()))
    if a.check:
        pc, misses = check_player(data, a.work)
        lines.append('Cross-check (player kinds): ' + ', '.join(f'{k} {v}' for k, v in pc.items())
                     + f'; {len(misses)} not found')
        note('cross-check', misses)
        for name, res in check_others(a.work, kinds):
            tail = res.strip().splitlines()[-1] if res.strip() else ''
            lines.append(f'Cross-check ({name}): {tail}')
            note('cross-check ' + name, [l for l in res.splitlines() if l.strip() and not l.startswith('OK')][:-1])
    if a.foundryborne:
        import foundryborne
        keys = overlay_keys()
        fb_info, fb_notes, fb_suggest = foundryborne.compare(
            a.foundryborne, out, lambda kind, owner, name: f'{owner}/{name}' in keys or f'{kind}:{name}' in keys)
        lines.append('Foundryborne: ' + fb_info)
        note('foundryborne', fb_notes)
        suggestions += fb_suggest
    lines += ['', '## Review', '']
    section = None
    for sec, item in REVIEW:
        if sec != section:
            lines.append(f'### {sec}')
            section = sec
        lines.append('- ' + item)
    lines += ['', f'## Effect suggestions (not applied): {len(suggestions)}', '']
    lines += ['- ' + s for s in suggestions]
    report = '\n'.join(lines) + '\n'
    open(os.path.join(a.work, 'review.md'), 'w', encoding='utf-8').write(report)
    print('\n'.join(lines[:4]))
    print(f'review items: {len(REVIEW)}; effect suggestions: {len(suggestions)}; full report: {os.path.join(a.work, "review.md")}')


if __name__ == '__main__':
    main()
