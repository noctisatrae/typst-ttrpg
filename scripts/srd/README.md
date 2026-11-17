# SRD extraction tools

Python (needs `pypdf` and `fonttools`; use a venv outside the repo and run
with `python -I`). The SRD PDF is untrusted input; outputs go to a scratch
directory, never into the repo.

1. `extract.py <srd.pdf> <out.txt>`: raw text per page (`=====PAGE n=====`).
2. `puamap.py <srd.pdf>`: shows how the PDF's private-use codepoints map to
   glyph names. In SRD 2.0, U+E53F..U+E549 are tabular digits 0-9 (e.g. the
   tier digit on p. 103 would otherwise vanish).
3. `clean.py <raw.txt> <clean.txt>`: maps those digits, leaked glyph names
   (`/one.tnum`, `/period.tab`) and split ligatures. pypdf splits ligatures
   with spaces ("profi t", "Diffi  culty", "diff erent"); a word that really
   ends in the "ff" glyph is followed by two spaces ("Bite off  heads"), so
   that one case is kept as a word boundary.
4. `parse_adversaries.py <clean.txt> <parsed.json>`: every adversary stat
   block (pp. 97-158), named from the SRD's own tier lists (pp. 95-96).
   Prints a REVIEW line for anything unusual; it never guesses.
5. `gen_adversaries.py <parsed.json> <tier> <out.typ>`: writes
   `packages/daggerheart-srd/src/adversaries/tier-N.typ` in SRD list order.
   Entries already in `<out.typ>` with the same id are kept verbatim, so
   regenerate from a clean file (e.g. `git checkout` it) after changing the
   parser.
6. `crosscheck.py <data.json> <clean.txt>`: rebuilds each adversary's stat
   block text from our data and diffs it with the SRD. It finds blocks on its
   own (by heading and the SRD's block separators), independently of the
   parser. Produce `data.json` from a document such as:

   ```typ
   #import "@local/daggerheart-srd:0.1.0": adversaries
   #let plain(c) = if type(c) == str { c } else if c.has("text") { c.text } else if c.has("children") { c.children.map(plain).join() } else if c == [ ] { " " } else { panic(repr(c)) }
   #metadata(adversaries.values().map(t => t.values()).flatten().map(a => a + (features: a.features.map(f => f + (body: plain(f.body)))))) <data>
   ```

   then `typst eval 'query(<data>).first().value' --in that.typ > data.json`.

Known SRD 2.0 quirks the tools handle (all reported, none silently fixed in
the data): an en dash as the minus in Darkweave Crawler's ATK (p. 99),
"Stress: None" (Spellbound Armor, p. 110), a dice attack modifier "+2d4"
(Outer Realms Abomination, p. 153), the list's "Outer Realms Corruptor" vs
the block's "Corrupter" (p. 153), and extraction spaces before colons in
some attack names.
