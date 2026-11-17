# SRD extraction tools

Python (needs `pypdf` and `fonttools`; use a venv outside the repo and run
with `python -I`). The SRD PDF is untrusted input; outputs go to a scratch
directory, never into the repo.

## build.py: the one command

```sh
TYPST_PACKAGE_PATH=<dir resolving @local/* to this checkout> \
  python -I scripts/srd/build.py reference/DH_SRD_2_2026_08_25.pdf --check
```

Regenerates every `packages/daggerheart-srd/src/**` data file from the PDF
and cross-checks the result (about 12 s cold, 5 s with the extraction
cached). Deterministic: a rebuild gives no git diff. Options:

- `--kinds adversaries,environments,loot,classes,ancestries,communities,cards,weapons,armor`
  (default: all).
- `--check`: rebuild each entity's text from the emitted Typst (`typst
  query`) and find it in a second extraction (plain page text), ignoring
  case, whitespace, bullets and the colon/period after names. `--check-only`
  checks without regenerating.
- `--work DIR`: where the extraction cache, JSON and `review.md` go
  (default: `<tmp>/srd-build`).
- `--foundryborne PATH`: compare with a local Foundryborne clone (numbers,
  ranges, damage, traits, thresholds, scores, domains, levels, recall
  costs, Evasion/HP) and list its effects as suggestions. Read-only: the SRD
  decides, nothing of theirs is copied.

It prints a summary and writes `review.md`: counts, cross-check results,
everything unusual (with pages), structures it turned into lists or
children, overlay problems, and effect SUGGESTIONS (never applied).

Generated files say GENERATED at the top: fix a parser or the overlay and
rebuild instead of editing them. Modules: `player.py` (classes, subclasses,
the Ranger companion, ancestries, communities, domain cards, weapons incl.
combat wheelchairs, armor), `emit_player.py`, `structure.py` (numbered options and roll-table
rows become lists; a feature ending in ":" takes the following features as
children), `foundryborne.py`, plus the tools below.

### Effects overlay

`packages/daggerheart-srd/src/effects.typ` is the one hand-curated file:
permanent, unconditional effects keyed `"<id>/<Feature>"` or
`"<kind>:<Feature>"`, each with its SRD wording and page. Text-only domain
cards use their own name as the feature. build.py reports entries that
match nothing and kind-wide entries covering different texts.

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
