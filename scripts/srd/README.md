# SRD extraction tools

Python (needs `pypdf` and `fonttools`; use a venv outside the repo and run
with `python -I`). The SRD PDF is untrusted input; outputs go to a scratch
directory, never into the repo.

1. `extract.py <srd.pdf> <out.txt>`: raw text per page (`=====PAGE n=====`).
2. `puamap.py <srd.pdf>`: shows how the PDF's private-use codepoints map to
   glyph names. In SRD 2.0, U+E53F..U+E549 are tabular digits 0-9 (e.g. the
   tier digit on p. 103 would otherwise vanish).
3. `clean.py <raw.txt> <clean.txt>`: maps those digits, leaked glyph names
   (`/one.tnum`, `/period.tab`) and split ligatures (`profi t`).
4. `crosscheck.py <data.json> <clean.txt>`: rebuilds each adversary's stat
   block text from our data and diffs it with the SRD. Produce `data.json`:

   ```sh
   typst eval --root . 'import "@local/daggerheart-srd:0.1.0": adversaries; let plain(c) = if type(c) == str { c } else if c.has("text") { c.text } else if c.has("children") { c.children.map(plain).join() } else if c == [ ] { " " } else { panic(repr(c)) }; adversaries.tier-1.values().map(a => a + (features: a.features.map(f => f + (body: plain(f.body)))))' > data.json
   ```
