# Part of scripts/srd (see README.md).
# Structures inside SRD feature text, shared by the generators:
# - options(text): numbered options ("1. Fire. ... 7. Light.") or roll-table
#   rows ("1–2: Mesmerized ...") become an intro plus a list of items. Only
#   a run of consecutive numbers starting at 1 counts, so a stray "2." in
#   a sentence is never split. The words are unchanged.
# - nest(features): a feature that introduces others (its name or text
#   ends with ":", e.g. Roc's "Nest Warden", p. 139) gets the features
#   after it as children, in SRD order.
import re

NUMBERED = re.compile(r'(?:(?<=^)|(?<=[\s:.]))(\d{1,2})\.\s')
ROWS = re.compile(r'(?:(?<=^)|(?<=[\s:.]))(\d{1,2}(?:\s*[–-]\s*\d{1,2})?)\s*:\s')


def _sequence(matches):
    seq, expect = [], 1
    for m in matches:
        nums = [int(n) for n in re.findall(r'\d+', m.group(1))]
        if nums[0] == expect:
            seq.append(m)
            expect = nums[-1] + 1
    return seq


def options(text):
    """None, or (kind, intro, items): kind "numbered" with items (number,
    text) or "rows" with items (label, text); the label is kept as printed."""
    for kind, pat in (('numbered', NUMBERED), ('rows', ROWS)):
        seq = _sequence(pat.finditer(text))
        if len(seq) < 2:
            continue
        intro = text[:seq[0].start()].strip()
        items = []
        for i, m in enumerate(seq):
            end = seq[i + 1].start() if i + 1 < len(seq) else len(text)
            items.append((m.group(1), text[m.end():end].strip()))
        return kind, intro, items
    return None


def introduces(name, text):
    return name.rstrip().endswith(':') or text.rstrip().endswith(':')


def nest(features, text_of=lambda f: f.get('body', '')):
    """Features with children: everything after a feature that introduces
    others belongs to it. Returns (features, notes)."""
    out, notes = [], []
    for i, f in enumerate(features):
        if introduces(f['name'], text_of(f)) and i + 1 < len(features):
            parent = dict(f, children=list(features[i + 1:]))
            out.append(parent)
            notes.append(f'{f["name"]!r} takes {", ".join(repr(c["name"]) for c in parent["children"])} as its features')
            return out, notes
        out.append(f)
    return out, notes
