# TTRPG Typst Toolkit

## Goal
A crate-style ecosystem of Typst packages for tabletop RPG content, written
once in Typst and rendered to PDF. The owner runs Daggerheart
theater-of-the-mind over Discord (images posted, music through a bot), so
the main product is GM prep: screenplay-style session notes with stat
blocks, music cues and a session sheet. Foundry VTT export is PARKED (see
below). Personal, non-commercial project for now.

## Package layers
1. `ttrpg-core` (system-agnostic)
   - table wrapper (load, sort, filter, group)
   - generic entity shape (id, name, tags, stats, features)
   - `extend`, schema validation helpers
   - layout primitives and themes (blocks, cards, columns)
   - Must never know what an "adversary" or "class" is.
2. `heartweaver` (depends on core) – the Daggerheart Compatible system package
   - schemas and derivation rules (evasion, HP, Stress, thresholds, tiers)
   - renderers: adversary stat block, domain card, character sheet
3. `daggerheart-srd` (data only)
   - SRD content transcribed by us; separate so users can swap it or merge
     homebrew on top. Records the SRD version it was transcribed from.
4. `ttrpg-script` (depends on core) – screenplay-format campaign notes:
   `scene` (time optional; avoid CONTINUOUS, scenes are non-linear),
   `intro`, `say`, `stats`, `open-play` (marks the hand-off to unscripted
   play), `leads-to` (links to scenes by location; unwritten ones stay
   plain), `music` (a mood most of the time, "♪ Mood:"; `track:`/`by:`/
   `url:` for key moments, "♪ PLAY:", chosen over CUE as the more
   actionable word at the table; `url:` only makes the title a link and
   is never printed), `session-sheet` (per scene: page, then indented
   groups under small bold headers CAST / MUSIC / LEADS TO), `cast`,
   optional `transition`. `intro`/`say` register entities (cast appendix,
   session sheet) and record per-scene events. The system supplies
   `setup(summary:, stats:)`, e.g. `hw.summary` / `hw.statblock`.
   GM lookup: `intro` names link to the cast appendix and show its page
   ("p. 3") for print; the cast starts on a new page after a rule and
   shows full stat blocks. Fonts: Courier Prime for the script,
   Geist Mono for stat blocks (`setup(font:, stats-font:)`).

`daggerheart-srd` depends on `heartweaver` so its data is validated on load.

## Authoring model
- Typst-native DSL, not YAML/TOML. Entities are function calls; feature prose
  is content blocks. Functions validate, register and render.
- Entities are plain dictionaries. `character(...)` returns data and
  `sheet(char)` renders it.
- Derived values are computed by the package; users write choices only.
- Flat lookup tables (weapons, armor, ancestries) may use TOML/YAML/CSV.
- System packages export a convention dictionary (e.g. `(render:, validate:)`)
  since Typst has no traits.
- Entity fields are FLAT: system fields (`hp`, `tier`, `thresholds`) sit at
  the top level next to core fields (`id`, `name`, `kind`, `tags`,
  `features`, `flags`), matching how stat blocks read.
- Registration: the same id rendered twice with identical content counts
  once; the same id with different content is an error. The check runs in a
  `context` (state updates are lazy), so its error cannot point at the
  user's line; the message must identify the entity on its own.
- Validation: unknown fields are HARD errors. All problems are collected and
  reported in one panic that names the entity, each field, a "did you mean"
  hint for typos, and the allowed fields. Keep `panic(message)` on a short
  line so the code excerpt Typst prints stays small.
- Constructors declare every field in their signature (editor completion)
  plus a `..unknown` catch-all passed on to validation, so typos still get
  our errors instead of Typst's "unexpected argument". Defaults are `none`
  (= not given). Enum-like values are plain strings, with Go-style constant
  dictionaries exported for completion (`size.small == "small"`).
- No automatic "modified from SRD" marker on extended entities; `extend` is
  an authoring shortcut. The DPCGL §4.1(e) modification statement is the
  document author's responsibility (document-level attribution).

## Inheritance: `extend`
- Inheritance exists ONLY in the Typst layer.
- `extend(base, id: "elite-bandit", name: "...", hp: 6)` returns a NEW flat
  entity (dictionaries are values; the base is never mutated).
- `id` is required (or deterministically derived) and must be unique.
- Scalars and dictionaries passed to `extend` REPLACE the base value (no deep
  merge; validation catches a dictionary missing keys).
- Lists never change implicitly. They need explicit operations:
  `add(...)`, `remove("Name")`, `replace("Name", ..fields)[body]`, or
  `all(...)` for the whole list. A plain list is an error that shows both
  forms. Items are matched by `name` (features) or by value (tags).
  Replaced items keep their position; added items go last.
- Systems re-export a bound `extend`: `core.extend.with(schemas: (...))`,
  so the result is re-validated against the kind's schema.
- Optional provenance: keep `extends: "<base id>"` in flags. Nothing may
  depend on it.
- Renderers and adapters only ever see the resolved flat entity.

## Foundry VTT adapter — PARKED (2026-11-17)
Parked because the owner plays theater-of-the-mind on Discord and finds
Foundry a burden (manual updates, needs battlemaps). The empty
`ttrpg-foundry` package was removed. Nothing else depends on Foundry;
entities stay plain data and the registry still exists, so the adapter can
be revived from these notes. Revival needs: target Foundry version, a
Foundryborne clone, exported fixtures in `fixtures/`.
- Renderers (`statblock`, `sheet`, ...) register Foundry output as a side
  effect: `#metadata(to-foundry-actor(e)) <foundry>`.
  - Per-call opt-out (`export: false`) and a document-wide switch for
    print-only builds.
- Extraction: `typst eval 'query(<foundry>).map(it => it.value)' --in doc.typ`
  (`typst query` is deprecated as of Typst 0.15).
  JSON is an output format, never an authoring format.
- One mapper per entity kind (`to-foundry-actor`, `to-foundry-item`), each
  producing the system's data fields. Actor/item type strings come from the
  Foundry game system, not from Foundry core.
- Foundry sees no inheritance: an extended entity is a whole new Actor.
- Include `prototypeToken` defaults in actor output. One Actor per entity id;
  many tokens are placed from it in Foundry.
- Plain SRD lookup without `extend` MAY emit a compendium link
  (`Compendium.<package>.<pack>.<Type>.<id>`; `@UUID[...]{Name}` in
  journals) through a slug-to-pack-ID table built once from the system.
  Anything extended or homebrew emits a full document.
- Dedupe by id: the same entity appearing twice yields one document. Do this
  in the CLI wrapper or with a Typst `state`.
- IDs: Foundry document IDs are 16-char alphanumeric. Derive deterministically
  from the entity id (hash in the CLI wrapper; Typst has no hash).
- Store our entity id in `flags` under our own namespace for round-tripping.
- Roll macros: generate Macro documents whose command calls the system's own
  roll API for duality dice. Do not reimplement the roll.
- CREATION PATH: the actor sheet's "Import Data" only OVERWRITES the existing
  actor it was invoked on; it does not create actors. Bulk creation needs
  either a small Foundry macro that creates documents from our JSON via the
  document API, or packing JSON into a compendium with Foundry's CLI packing
  tool (modern packs are LevelDB). Verify against the target Foundry version.
- Verify all field names against the system's code and exported fixtures.
  Never guess shapes.

## Daggerheart notes
- Monsters are "adversaries". Fields: tier, type (Bruiser, Horde, Solo,
  Minion, Skulk, ...), difficulty, HP, Stress, damage thresholds, attack
  modifier, attack, Experiences, features (passive/action/reaction),
  motives & tactics.
- Characters: class, ancestry, community, six traits, evasion, HP, Stress,
  Hope, armor, domain cards, Experiences.
- Source of truth for CONTENT is the official SRD (v2.0, PDF only). Never
  invent rules or stats. Verify every transcribed value against the SRD text.
- Extraction from the PDF is error-prone (columns, tables). Always run a
  validation pass and flag missing or oddly formatted fields for human review.
- SRD file: `reference/DH_SRD_2_2026_08_25.pdf` (224 pages; PDF page index =
  printed page). Tools in `scripts/srd/` (extract, clean, crosscheck).
  Tabular digits are private-use glyphs (U+E53F–E549) that pypdf drops;
  `puamap.py` restores them. Run `crosscheck.py` before adding any entity.
- Adversary values are stored exactly as printed ("Leader", "Very Close",
  "phy"). `thresholds` uses `none` for "None" (also "3/None").
  `creatures-per-hp` exists only on Hordes. No derived values: the SRD
  defines no adversary derivation (p.95 benchmarks are guidance only).
- Every SRD entity records `flags.source` (document, version, page).
- Slug scheme for SRD entities: kebab-case of the SRD name.

## Licensing and sources of truth
- Code is MPL-2.0 (`LICENSE`): the stack stays open source (file-level
  copyleft), while works made with it are not bound by it. Every source file
  carries the MPL header. Game content belongs to Darrington Press and is
  used under the DPCGL 2.0 (copy in `reference/`). `NOTICE.md` holds the exact
  attribution wording and our reading of the relevant clauses; rendered
  output must carry that attribution. Mark the project as unofficial.
- Name Marks (DPCGL §2.5): "Daggerheart" may not be in the title of a work or
  on a front cover, and must read "Daggerheart Compatible" in descriptive
  text. Hence the system package is `heartweaver`, not `daggerheart`.
  `daggerheart-srd` keeps the name on purpose: it is the unmodified SRD and
  should be easy to find (owner's decision; see README).
- Permitted Formats (DPCGL §1.9) list print/digital print, streams, podcasts
  and whitelisted VTTs (Foundry is one, non-commercial only). Software
  packages are not listed; private use is not "Sharing". Check before
  publishing the SRD data package.
- Content comes ONLY from the official SRD, transcribed by us.
- Foundryborne is used ONLY as a reference for Foundry document shape (field
  names, structure). Do NOT copy its compendium content (src/packs) or other
  non-code material into this repo.
- Foundryborne's README rejects AI-generated contributions: never open PRs or
  issues against it using generated code.

## Constraints
- Packages cannot install fonts: define a fallback stack, document fonts.
  Default theme fonts (all SIL OFL): Inter (body), Inter Display (titles,
  weight 900), Geist Mono (numbers in stat bands and dice expressions,
  styled automatically by regex). Install on macOS:
  `brew install --cask font-inter font-geist-mono`. Use static font files;
  Typst handles variable fonts poorly.
- Keep packages small, split data by category, check Typst Universe
  guidelines before publishing.
- Dev setup: local package dir, import as `@local/ttrpg-core:0.1.0`
  (macOS: `~/Library/Application Support/typst/packages/local/`,
  Linux: `~/.local/share/typst/packages/local/`). Switch to `@preview/...`
  when publishing.
  - `scripts/link-local.sh` symlinks each `packages/<name>` into the local
    package dir as `<name>/<version>`, so edits are picked up immediately.

## Repo layout
- `packages/<name>/` – one Typst package each (`typst.toml`, `src/lib.typ`).
- `examples/` – example documents that use the packages via `@local`.
- `tests/` – one compile-test document per feature.
- `scripts/` – dev scripts (local linking, test runner, later the CLI wrapper).
- `reference/` – SRD PDF and other human-provided sources (not committed
  if licensing forbids redistribution).
- `fixtures/` – exported Foundry documents used as golden files (parked).

## Sources
- Official Daggerheart SRD v2.0 (PDF, 2026-08-25), source of truth for content:
  https://www.daggerheart.com/srd/
  PDF only. Pin this version in `daggerheart-srd` metadata and in generated
  output.
- Darrington Press Community Gaming License (attribution wording, terms,
  "Daggerheart Compatible" logos): https://darringtonpress.com/license
  License: DPCGL 2.0, "Last Updated 8/05/2026", file
  `DPCGL_2.0_AUG_26_2026.pdf`. Attribution text copied into `NOTICE.md`.
- Foundryborne Daggerheart system for Foundry VTT, shape reference only:
  https://github.com/Foundryborne/daggerheart
  Layout seen: `module`, `src/packs`, `templates`, `lang`, `system.json`.
  Code is MIT; system content is under the Darrington Press license.
  Not yet verified: where actor/item data models live (probably `module/`),
  supported Foundry versions (see `system.json`), which SRD version it
  implements.
- Foundry VTT article on Actors (types come from the system, prototype
  tokens, JSON import overwrites an existing actor):
  https://foundryvtt.com/article/actors/
- Foundry community wiki, system dev tutorial, template.json chapter:
  https://foundryvtt.wiki/en/development/guides/SD-tutorial/SD04-templatejson
  (Body did not load when fetched; read directly. template.json is the older
  approach; newer systems use TypeDataModel classes.)
- TODO: Foundry API docs for the target Foundry version.

## Milestones
1. ✓ Scaffold repo: packages, `typst.toml` each, example document.
2. ✓ Core: validation, entity, `extend`, registry, themes, stat-block base,
   page footer. (Table wrapper deferred until real tabular data needs it.)
3. ✓ Daggerheart: `adversary(...)`, `statblock`, `attribution`; 5 SRD
   adversaries transcribed and cross-checked.
4. ✓ Screenplay notes (`ttrpg-script`): scenes, dialogue, open play,
   inline stat blocks, cast appendix, music cues, session sheet.
5. Extract the full adversary section of the SRD PDF into `daggerheart-srd`.
6. Characters: `character(...)`, derivation, `sheet(...)`. Authoring path
   is an open question (see below).
7. Discord helpers: export handouts / single stat blocks as PNG.
8. Domain cards, print layouts (3x3 card sheets, crop marks), themes.

Parked (Foundry): adapter v0 (one adversary -> Actor JSON), roll macros,
compendium links, CLI wrapper (dedupe, IDs, packing).

## Conventions
- Small, documented functions. Validation errors name the entity and field.
- One compile-test document per feature in `tests/`. Expected failures go in
  `tests/fail/`, each with `// expect: <text>` lines the error must contain
  (Typst cannot catch panics). `tests/support/creature.typ` is a made-up
  system for testing core; it is not game content.
- Typst version: 0.15.1 (set as `compiler` in every `typst.toml`).
- Don't name exports after Typst built-ins (`range`, `type`, `list`, ...):
  hence `attack-range`, `adversary-type`.

## Pending with the owner
- Owner uses Zed (Typst extension = Tinymist). Check field completion there.

## Design notes
- Stat block style is decoupled from document style: renderers draw with
  the active core theme. Core's default theme is neutral; heartweaver's
  `book-theme` is the optional book-inspired look
  (`core.setup.with(theme: hw.book-theme)`); `ttrpg-script` sets an
  all-mono outlined theme via `core.use-theme`.
- Book look: official-book-INSPIRED. Use our own ornaments and free fonts;
  DPCGL excludes trade dress, art and logos. Page footer: mirrored (even
  left, odd right), page number on an ochre tab, running title = latest
  level-1 heading.

## Open questions
- Character creation without Foundry: players write Typst themselves (with
  AI help, homebrew from a git compendium) vs a web GUI that generates the
  Typst call. See the discussion of 2026-11-17.
- Foundry (parked): target version, Foundryborne data-model fields, which
  SRD version it implements, creation path (macro vs compendium packing).

## Inputs the human must provide
- The SRD PDF in `reference/` (done: SRD 2.0).
- Foundry (parked): Foundryborne clone, exported fixtures in `fixtures/`.
