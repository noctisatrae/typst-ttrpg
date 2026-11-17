# Part of scripts/srd (see README.md).
# Rebuild each adversary's SRD text from our data and diff it with the
# cleaned SRD extraction. Prints OK or the first mismatch per adversary.
import sys, json, re
data = json.load(open(sys.argv[1], encoding='utf-8'))
srd = open(sys.argv[2], encoding='utf-8').read()
norm = lambda s: re.sub(r'\s+', ' ', s).strip()
signed = lambda n: ('−' + str(-n)) if n < 0 else '+' + str(n)
def th(t):
    f = lambda v: 'None' if v is None else str(v)
    return 'None' if t['major'] is None and t['severe'] is None else f(t['major']) + '/' + f(t['severe'])
ok = True
for a in data:
    kind = a['type'] + (f" ({a['creatures-per-hp']}/HP)" if a.get('creatures-per-hp') else '')
    at = a['attack']
    dmg = at['damage'] + (' direct' if at['direct'] else '') + ' ' + at['damage-type']
    lines = [a['name'].upper(), f"Tier {a['tier']} {kind}", a['description'],
             'Motives & Tactics: ' + a['motives'],
             f"Difficulty: {a['difficulty']} | Thresholds: {th(a['thresholds'])} | HP: {a['hp']} | Stress: {a['stress']}",
             f"ATK: {signed(at['modifier'])} | {at['name']}: {at['range']} | {dmg}"]
    if a['experiences']:
        lines.append('Experience: ' + ', '.join(f"{x['name']} {signed(x['bonus'])}" for x in a['experiences']))
    lines.append('FEATURES')
    lines += [f"{f['name']} - {f['kind']}: {f['body']}" for f in a['features']]
    ours = norm(' '.join(lines))
    start = srd.find('\n' + a['name'].upper() + '\n')
    end = srd.find('        \n', start)
    theirs = norm(srd[start:end])
    page = re.findall(r'=====PAGE (\d+)=====', srd[:start])[-1]
    pg_ok = str(a['flags']['source']['page']) == page
    if ours == theirs and pg_ok:
        print(f"OK    {a['id']} (p. {page})")
    else:
        ok = False
        i = next((i for i, (x, y) in enumerate(zip(ours, theirs)) if x != y), min(len(ours), len(theirs)))
        print(f"DIFF  {a['id']} page ours={a['flags']['source']['page']} srd={page}\n  ours:   ...{ours[max(0,i-40):i+60]}\n  theirs: ...{theirs[max(0,i-40):i+60]}")
sys.exit(0 if ok else 1)
