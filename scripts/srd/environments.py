# Part of scripts/srd (see README.md).
# Parse environment stat blocks (SRD 2.0 pp. 158-182) from font runs into
# JSON. Fields follow "Environment Stat Block" (p. 158): name, tier, type,
# description, impulses, difficulty, potential adversaries, features and
# feature questions. Fonts used by the SRD:
#   EvelethCleanRegular   block name (all caps) and section headings
#   QuestaSlab-BoldItalic "Tier 1 Exploration"
#   QuestaSans-Bold       field labels ("Impulses:") and FEATURES
#   QuestaSans-BoldItalic feature heading "Name - Kind:"
#   QuestaSlab-Italic     feature questions
# The name in the data is the title-cased form given in the SRD's own list
# on p. 159 (blocks print names in caps); pass that list with --names.
#
# Usage: python -I environments.py <srd.pdf> <first> <last> <names.txt> > out.json
import json
import re
import sys
import os

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runs import runs  # noqa: E402

LABELS = ('Impulses:', 'Difficulty:', 'Potential Adversaries:')
FEATURE = re.compile(r'^(.*) - (Passive|Action|Reaction):$')


def norm(s):
    return re.sub(r'\s+', ' ', s).strip()


def body_blocks(text):
    """Split feature text into paragraphs and bullet lists."""
    blocks = []
    for line in text.split('\n'):
        line = line.strip()
        if not line:
            continue
        if line.startswith('•'):
            item = line[1:].strip()
            if blocks and 'bullets' in blocks[-1]:
                blocks[-1]['bullets'].append(item)
            else:
                blocks.append({'bullets': [item]})
        elif blocks and 'bullets' in blocks[-1]:
            blocks[-1]['bullets'][-1] += ' ' + line
        elif blocks:
            blocks[-1]['text'] += ' ' + line
        else:
            blocks.append({'text': line})
    for b in blocks:
        if 'text' in b:
            b['text'] = norm(b['text'])
        else:
            b['bullets'] = [norm(x) for x in b['bullets']]
    return blocks


def parse(pdf, first, last, names):
    envs, env, feat, field = [], None, None, None
    by_caps = {n.upper(): n for n in names}

    def close_feature():
        nonlocal feat
        if feat:
            feat['body'] = body_blocks(feat.pop('raw'))
            feat['questions'] = norm(feat['questions'])
            env['features'].append(feat)
        feat = None

    pending_name = ''
    for page, font, text in runs(pdf, first, last):
        t = text.strip()
        if not t:
            # Whitespace runs only matter as line breaks inside features.
            if feat is not None:
                feat['raw'] += text
            continue
        if font == 'EvelethCleanRegular':
            close_feature()
            if 'ENVIRONMENTS' in t:
                continue  # section heading, e.g. "TIER 1 ENVIRONMENTS (LEVEL 1)"
            pending_name = norm(pending_name + ' ' + t)
            continue
        if font == 'QuestaSlab-BoldItalic' and t.startswith('Tier '):
            if pending_name not in by_caps:
                raise SystemExit(f'p.{page}: block name {pending_name!r} is not in the names list')
            tier, kind = t.split(' ', 2)[1:]
            env = {'name': by_caps[pending_name], 'tier': int(tier), 'type': kind,
                   'description': '', 'impulses': '', 'difficulty': '',
                   'potential-adversaries': '', 'features': [], 'page': page}
            envs.append(env)
            pending_name, field = '', 'description'
            continue
        pending_name = ''
        if env is None:
            continue
        if font == 'QuestaSans-Bold' and t in LABELS:
            field = t[:-1].lower().replace(' ', '-')
            continue
        if font == 'QuestaSans-Bold' and t == 'FEATURES':
            field = None
            continue
        if font == 'QuestaSans-BoldItalic' and FEATURE.match(t):
            close_feature()
            name, kind = FEATURE.match(t).groups()
            feat = {'name': norm(name), 'kind': kind, 'raw': '', 'questions': ''}
            continue
        if feat is not None:
            if font == 'QuestaSlab-Italic':
                feat['questions'] += ' ' + text
            else:
                feat['raw'] += text
            continue
        if field:
            env[field] += text
    close_feature()
    for e in envs:
        for k in ('description', 'impulses', 'potential-adversaries', 'difficulty'):
            e[k] = norm(e[k])
        e['difficulty'] = int(e['difficulty']) if e['difficulty'].isdigit() else e['difficulty']
    return envs


if __name__ == '__main__':
    names = [n.strip() for n in open(sys.argv[4], encoding='utf-8') if n.strip()]
    print(json.dumps(parse(sys.argv[1], int(sys.argv[2]), int(sys.argv[3]), names),
                     ensure_ascii=False, indent=1))
