# Part of scripts/srd (see README.md).
# Clean pypdf text from the SRD: tabular-digit PUA codepoints, leaked glyph
# names, and ligatures split by a space. Mapping derived by puamap.py.
import sys, re
t = open(sys.argv[1], encoding='utf-8').read()
digits = {0xE53F: '0', 0xE541: '1', 0xE542: '2', 0xE543: '3', 0xE544: '4',
          0xE545: '5', 0xE546: '6', 0xE547: '7', 0xE548: '8', 0xE549: '9'}
t = t.translate(digits)
names = {'zero': '0', 'one': '1', 'two': '2', 'three': '3', 'four': '4', 'five': '5',
         'six': '6', 'seven': '7', 'eight': '8', 'nine': '9'}
t = re.sub(r'/(zero|one|two|three|four|five|six|seven|eight|nine)\.tnum', lambda m: names[m.group(1)], t)
t = t.replace('/period.tab', '.').replace('/comma.tab', ',').replace('/hyphen.tab', '-')
for lig, rep in (('ﬃ', 'ffi'), ('ﬄ', 'ffl'), ('ﬁ', 'fi'), ('ﬂ', 'fl'), ('ﬀ', 'ff')):
    t = t.replace(lig, rep)
# Ligatures extracted as "fi t" / "ffi  culty": rejoin when a lowercase letter follows.
t = re.sub(r'(ffi|ffl|fi|fl|ff) +(?=[a-z])', r'\1', t)
open(sys.argv[2], 'w', encoding='utf-8').write(t)
