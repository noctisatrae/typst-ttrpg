# Part of scripts/srd (see README.md).
# Parse the loot roll tables (SRD 2.0 "Loot", pp. 75-79 items and pp. 80-84
# consumables) from font runs into JSON. Each table is introduced by a bold
# title ("Core Set Items", "Additional Items", ...); each row is a roll
# number (QuestaSans-Regular, digits only) followed by the item name
# (QuestaSans-Bold, may wrap) and its description. A bold label inside a
# description (bold italic "Resilient:" on a stone that grants a feature)
# starts a new paragraph, as printed.
#
# Usage: python -I loot.py <srd.pdf> <first> <last> > out.json
import json
import os
import re
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from runs import runs  # noqa: E402

# Table titles -> the collection named in each table's intro sentence.
TABLES = {
    'Core Set Items': 'Daggerheart Core Set',
    'Additional Items': 'Hope & Fear Expansion Set',
    'Core Set Consumables': 'Daggerheart Core Set',
    'Additional Consumables': 'Hope & Fear Expansion Set',
}
STOP = ('CONSUMABLES', 'GOLD')  # section headings that end a table


def norm(s):
    # A line that ends in a hyphen continues a compound ("2-foot-" / "deep").
    s = re.sub(r'-[ \t]*\n\s*', '-', s)
    return re.sub(r'\s+', ' ', s).strip()


def parse(pdf, first, last):
    rows, table, row, expect_name = [], None, None, False
    seq = runs(pdf, first, last)
    for i, (page, font, text) in enumerate(seq):
        t = text.strip()
        if not t:
            # Whitespace runs carry line breaks: keep them as text.
            if row is not None and not expect_name:
                row['paragraphs'][-1] += text
            continue
        if font == 'QuestaSans-Bold' and t in TABLES:
            table, row = TABLES[t], None
            continue
        if font == 'EvelethCleanRegular':
            if t in STOP:
                table, row = None, None
            continue  # ROLL / LOOT / description column headers
        if table is None:
            continue
        nxt = next((r for r in seq[i + 1:] if r[2].strip()), None)
        if (font == 'QuestaSans-Regular' and re.fullmatch(r'\d{1,2}', t)
                and nxt and nxt[1] == 'QuestaSans-Bold'):
            row = {'roll': int(t), 'roll-text': t, 'name': '', 'paragraphs': [''],
                   'collection': table, 'page': page}
            rows.append(row)
            expect_name = True
            continue
        if row is None:
            continue
        if expect_name and font == 'QuestaSans-Bold':
            row['name'] = norm(row['name'] + ' ' + t)
            continue
        expect_name = False
        if font in ('QuestaSans-Bold', 'QuestaSans-BoldItalic') and t.endswith(':') and norm(row['paragraphs'][-1]):
            row['paragraphs'].append('')
        row['paragraphs'][-1] += text
    for r in rows:
        r['paragraphs'] = [norm(p) for p in r['paragraphs'] if norm(p)]
    return rows


if __name__ == '__main__':
    print(json.dumps(parse(sys.argv[1], int(sys.argv[2]), int(sys.argv[3])),
                     ensure_ascii=False, indent=1))
