# Part of scripts/srd (see README.md).
# Font-tagged text runs from SRD pages, cleaned like clean.py. The SRD sets
# each part of a block in its own font (names, labels, body, italic GM
# questions), so parsers can rely on fonts instead of guessing from layout.
#
# Use as a module: `runs(pdf_path, first_page, last_page)` returns a list of
# (page, font, text) with page footers dropped. Run directly to print the
# runs of one page: `python -I runs.py <srd.pdf> <page>`.
import re
import sys

import pypdf

DIGITS = {0xE53F: '0', 0xE541: '1', 0xE542: '2', 0xE543: '3', 0xE544: '4',
          0xE545: '5', 0xE546: '6', 0xE547: '7', 0xE548: '8', 0xE549: '9'}
NAMES = ('zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine')
LIGATURES = (('ﬃ', 'ffi'), ('ﬄ', 'ffl'), ('ﬁ', 'fi'), ('ﬂ', 'fl'), ('ﬀ', 'ff'))
# The PDF splits words after f-ligatures, extracting either the glyph
# ("oﬀ  the") or plain letters ("Diffi  culty", "fi ght", "cliff ."). "fi",
# "fl", "ffi" and "ffl" never end a word in SRD 2.0, so those always rejoin.
# "ff" does end words ("off the", "Staff of"), so those rejoin unless the
# pair is a real word break: followed by two spaces (clean.py's rule), or
# one of the single-space breaks below, every one in SRD 2.0 (surveyed over
# the whole text); clean.py alone would turn "Staff of" into "Staffof".
FF_WORDS = {'off', 'staff', 'sniff', 'cliff'}
FF_NEXT = {'the', 'their', 'your', 'course', 'a', 'to', 'or', 'narrow', 'light',
           'in', 'boxes', 'from', 'without', 'of', 'against', 'member', 'out', 'faces'}


def rejoin_ff(m):
    word, spaces, nxt = m.group(1), m.group(2), m.group(3)
    # Two spaces mark a real break (clean.py's rule); the table covers the
    # real breaks the PDF prints with a single space ("Staff of").
    if len(spaces) >= 2 or (word.lower() in FF_WORDS and nxt.lower() in FF_NEXT):
        return word + ' '
    return word


def clean(text):
    """Like clean.py, for one run of text, with the ligature rejoining
    above."""
    text = text.translate(DIGITS)
    text = re.sub(r'/(zero|one|two|three|four|five|six|seven|eight|nine)\.tnum',
                  lambda m: str(NAMES.index(m.group(1))), text)
    text = text.replace('/period.tab', '.').replace('/comma.tab', ',').replace('/hyphen.tab', '-')
    for lig, rep in LIGATURES:
        text = text.replace(lig, rep)
    text = re.sub(r'(ffi|ffl|fi|fl) +(?=[a-z])', r'\1', text)
    text = re.sub(r'(\b[A-Za-z]*ff)( +)(?=([a-z]+\b|[.,;:!?]))', rejoin_ff, text)
    return text


def font_name(font):
    """'CVAQXO+QuestaSans-Light' -> 'QuestaSans-Light'."""
    name = font.get('/BaseFont', '?') if font else '?'
    return str(name).lstrip('/').split('+')[-1]


def runs(pdf, first, last):
    reader = pypdf.PdfReader(pdf)
    out = []
    for page in range(first, last + 1):
        chunks = []

        def visit(text, cm, tm, font, size):
            if text:
                chunks.append((page, font_name(font), clean(text)))

        reader.pages[page - 1].extract_text(visitor_text=visit)
        # Footer: "Daggerheart SRD" and the page number.
        chunks = [c for c in chunks if c[2].strip() not in ('Daggerheart SRD', str(page))]
        out += chunks
    return out


if __name__ == '__main__':
    for page, font, text in runs(sys.argv[1], int(sys.argv[2]), int(sys.argv[2])):
        print(f'{font:28} {text!r}')
