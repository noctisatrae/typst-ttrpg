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
   `intro` (characters), `mention` (any other entity), `say`, `stats`,
   `open-play` (marks the hand-off to unscripted
   play), `leads-to` (links to scenes by location; unwritten ones stay
   plain), `music` (a mood most of the time, "♪ Mood:"; `track:`/`by:`/
   `url:` for key moments, "♪ PLAY:", chosen over CUE as the more
   actionable word at the table; `url:` only makes the title a link and
   is never printed), `session-sheet` (per scene: page, then indented
   groups under small bold headers, one per outline kind, then MUSIC /
   LEADS TO), `appendix()` (new page, separator, one section per kind),
   optional `transition`. `intro`/`say` register entities (cast appendix,
   session sheet) and record per-scene events. The system supplies
   `setup(system: hw.system)`: `(kinds: (<kind>: (section:, outline:,
   summary:, render:)))` in display order. heartweaver's `system.typ` is
   where every new block kind registers; `outline: false` for classes,
   ancestries, communities, transformations, beastforms, stances, domain
   cards (factions are outlined). Kinds missing
   from the system still work (titled by name, compact entry).
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
Known from the owner's export (2026-11-17): Foundry core 14.367, system
`daggerheart` 2.4.2. Exports hold choices but NOT derived values (Evasion,
thresholds, max HP are computed at runtime and exported as 0/null).
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
- ALL SRD data is generated by `scripts/srd/build.py <pdf> [--kinds ...]
  [--check] [--foundryborne PATH]` (≈5-12 s, deterministic: a rebuild
  leaves git clean) and is never hand-edited. The only hand-curated data is
  `packages/daggerheart-srd/src/effects.typ` (modifiers/grants with SRD
  wording + page). Run `--check` before committing; `--foundryborne` adds a
  read-only cross-check. Review output goes to `review.md` in the work dir.
- Features may nest (`features:` children, drawn indented with a left
  rule); numbered options render as Typst lists. Loot rolls are strings as
  printed ("07"). Environment GM questions: stat block only.
- Foundryborne v2.12.9 packs follow SRD 2.0; 12 modeling disagreements
  (Shadowblade phy/mag, Arcane-Frame Wheelchair Spellcast/mag): SRD wins.
- Transformations (pp. 42-45), Druid Beastforms (pp. 15-18) and martial
  stances (p. 13) are kinds (2026-11-23). Numbers they need (Vampire's 6
  tokens, Focus max 6, 2 stances at first + 1 per level) are READ from the
  SRD text by the parser and cross-checked, never typed. daggerheart-srd
  binds the forms to the Druid's "Beastform" feature and the stance rules to
  "Stance Fighter" (`grants:`), so characters need no extra fields.
- SCOPE (owner, 2026-11-23): the full BASE game only. The Witherwild
  (pp. 184-189) is the only campaign frame: skip it. Pp. 190-205 are
  "Supplemental Campaign Mechanics" (optional modules for any campaign):
  Everyday Hero starting equipment (pp. 191-192) is generated
  (`everyday-hero.weapons/.armors`, tier 1 per p. 5, tag "everyday-hero").
  No downtime-project template (owner: plain notes suffice); feasts
  skipped. Factions (p. 190) are a heartweaver kind (`hw.faction`, outline:
  true; no SRD data, GMs write their own): countdown sizes (major 10,
  minor 4-6) and limits (1 major + 2 minor running, 1-3 per list) are
  checked; ticks are play state. Homebrew comes later.
- Ranger companion text (pp. 21-22) is generated into
  `player/companion.typ` (`ranger-companion`, cross-checked); its numbers
  live in heartweaver `companion.typ`. Starting Stress 3 and the per-option
  limits are NOT in the SRD text (printed companion sheet, as in
  Foundryborne); flagged there.
- Every flagged PDF spot was checked against the rendered page
  (2026-11-17): "cliffside", "2-foot-deep", "Secret-Keeper", the p. 22
  arrow, the p. 99 en dash, "Corrupter", the Bard "." names are all as
  printed. To look at a page: Typst renders PDF pages as images
  (`image("srd.pdf", page: n)`, compile to PNG in the scratchpad).
- Effect suggestions a human found situational go in `SITUATIONAL` in
  build.py so they stop resurfacing. Effects may depend on
  `loadout-domains` ("-Touched" cards), replace the unarmored base
  (`base-armor`, Bare Bones), add to Spellcast Rolls (`spellcast`, shown
  next to the Spellcast trait; weapon attacks are not Spellcast Rolls,
  p. 47) or change the loadout size (`loadout`).
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
- Foundryborne (decided 2026-11-17, owner: "whatever is most faithful to
  the original ruleset"): the SRD PDF is the ONLY source of text and values.
  Foundryborne's packs may be READ as an independent cross-check (any
  disagreement goes to human review; the SRD text decides) and as hints for
  `effects.typ` (added only when the SRD wording states a permanent,
  unconditional effect). Never copy its text or data files into this repo.
  Its MIT code may be read to compare derivation logic.
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
5. ✓ Kinds are generic in the script: the system describes each entity kind
   once (section title, summary, renderer, whether it is listed in the
   session outline); `intro` for characters, `mention` for anything else;
   session sheet and appendix group by kind.
6. Characters: `character(...)`, derivation, `sheet(...)`, built around ONE
   complete character first, transcribing only the data it needs (class,
   subclass, ancestry, community, domain cards, weapon, armor); then widen.
7. Environments, items, loot, consumables (small schemas, session-critical).
8. Full SRD extraction of every block type (adversaries, environments,
   equipment incl. campaign-frame tables, loot, domain cards, classes, ...),
   cross-checked; good work for background agents once schemas exist.
9. Colossal adversaries: framework + segment stat blocks (SRD p.198),
   one outline entry, a linked group in the appendix.
10. Discord helpers: export handouts / single stat blocks as PNG.
11. Domain card print layouts (3x3 sheets, crop marks), more themes.

## Block types (SRD 2.0) and where they show up
- Session OUTLINE + appendix (needed during play): adversaries, colossal
  adversaries, environments, weapons, armor, combat wheelchair, loot,
  items, consumables. Feast ingredients (p.192, optional cooking campaign
  mode) count as loot if that mode is used.
- APPENDIX only (reference, clickable/printable when mentioned): classes,
  subclasses, ancestries, communities, transformations (p.42), domain cards.
- Optional campaign mechanics (p.190+): factions, feasts, campaign frames
  with their own equipment tables (tag those items with the frame).

Parked (Foundry): adapter v0 (one adversary -> Actor JSON), roll macros,
compendium links, CLI wrapper (dedupe, IDs, packing).

## Conventions
- Small, documented functions. Validation errors name the entity and field.
- One compile-test document per feature in `tests/`. Expected failures go in
  `tests/fail/`, each with `// expect: <text>` lines the error must contain
  (Typst cannot catch panics). `tests/support/creature.typ` is a made-up
  system for testing core; it is not game content.
- Typst version: 0.15.1 (set as `compiler` in every `typst.toml`).
- A function stored in a dictionary must be called as `(info.render)(e)`;
  `info.render(e)` is an error.
- Don't name exports after Typst built-ins (`range`, `type`, `list`, ...):
  hence `attack-range`, `adversary-type`.

## Next up (as of 2026-11-17)
1. Submit to Typst Universe (owner's go): set up the fork + UNIVERSE_TOKEN
   (see `.github/workflows/universe.yml`), then tag `v0.1.0`. Reviewers may
   object to `ttrpg-core` as too generic a name ("not the obvious or
   canonical name"); have an alternative ready.
2. `examples/learn-characters.typ`: a commented walkthrough (creation,
   level-ups, card choice, companion, sheet); leveling is only shown in
   tests/heartweaver-companion.typ today.
3. Stat lines: never leave a "|" at a line edge when they wrap (core
   `stat-line`).
4. (Transformations done 2026-11-23/24; `tests/script-transformation.typ`
   checks a homebrew-shaped card in the screenplay theme. Never edit
   `../red-mist`: the owner writes there; renderer checks live in tests.)
5. Multiclass derivation.

## Publishing (decided 2026-11-17)
- GitHub: public, https://github.com/noctisatrae/typst-ttrpg. Owner's
  players' story files were only placeholders; keep real backstories out
  of the repo.
- CI (`.github/workflows/ci.yml`): tests, examples, bundle check.
  `scripts/bundle.sh <out> <pkgs...>` builds Universe bundles (LICENSE
  copied, `@local` -> `@preview`, manifest/README/dependency checks).
- Universe: ttrpg-core, ttrpg-script, heartweaver only (MPL-2.0, no SRD
  text). daggerheart-srd is NOT submitted: Universe allows third-party
  copyrighted content only if the holder clears distribution in a package,
  and DPCGL Permitted Formats don't list packages. Bump `version` in
  typst.toml (and the `@local/...:<ver>` imports) before each release; the
  workflow skips versions already published.

## Pending with the owner
- Inskel's companion Brindille (red fox) is a made-up example; the owner
  may redesign it. Confirm against a printed companion sheet: starting
  Stress 3 and the option limits.
- Owner uses Zed (Typst extension = Tinymist). Check field completion there.
- DPCGL: the public repo shares the SRD transcription; software repos are
  not a listed Permitted Format (owner chose public knowingly).

## Tooling setup (recreate per session)
- Python venv OUTSIDE the repo with `pypdf` and `fonttools`; run scripts
  with `python -I`. Example: `python3 -m venv /tmp/srd-venv &&
  /tmp/srd-venv/bin/pip install pypdf fonttools`.
- Foundryborne (read-only cross-check): `git clone --depth 1
  https://github.com/Foundryborne/daggerheart.git` OUTSIDE the repo.
- Worktree agents: `@local` links point at the main checkout; give each
  agent its own package dir via `TYPST_PACKAGE_PATH`.
- Fonts: `brew install --cask font-inter font-geist-mono font-courier-prime`.

## Design notes
- LAYOUT RULE (owner, 2026-11-17): boxes hug their text (small inner
  padding); the space goes BETWEEN elements (generous outer margins). Inline
  boxes wrap content with inset, never fixed sizes, so text stays on its
  line. One spacing constant per layout (e.g. `gap` in sheet.typ).
- Stat block style is decoupled from document style: renderers draw with
  the active core theme. Core's default theme is neutral; heartweaver's
  `book-theme` is the optional book-inspired look
  (`core.setup.with(theme: hw.book-theme)`); `ttrpg-script` sets an
  all-mono outlined theme via `core.use-theme`.
- Book look: official-book-INSPIRED. Use our own ornaments and free fonts;
  DPCGL excludes trade dress, art and logos. Page footer: mirrored (even
  left, odd right), page number on an ochre tab, running title = latest
  level-1 heading.

## Characters (decided 2026-11-17)
- Players write Typst (with AI help; homebrew from a git compendium);
  a web GUI is not planned unless players struggle.
- A character stores CHOICES and LEVEL HISTORY, never derived numbers:
  `character(..., levels: (level(2, ...), ...))`. The sheet is a fold over
  the history (base |> level 2 |> level 3 ...), carrying provenance
  ("+1 Evasion, level 4"). Every SRD level-up rule is validated (two
  advancements per level, tier limits, marked traits, Proficiency and
  multiclass cost two slots, multiclass from level 5, card levels).
- Book engine, not game engine: derive only what is known at compile time
  (Evasion, HP/Stress/Hope slots, Proficiency, thresholds, Armor Score,
  damage rolls). Play state (marked HP/Stress/Hope, gold) prints as empty
  boxes; it is never stored.
- Feature effects: transcribed entries may carry structured PERMANENT,
  UNCONDITIONAL numeric modifiers next to their text (e.g. armor
  "Flexible: +1 to Evasion" -> `(evasion: 1)`); situational effects stay
  text only.
- Sheets: the black-and-white screenplay-style sheet first (owner's
  everyday print version); a book-inspired sheet later (inspired by, not
  copying, Darrington Press's sheet design).
- Multiclassing: allowed by the data format from the start, implemented
  once a second class's data exists.
- API (heartweaver): `character(...)` takes ENTITIES, not strings
  (`class: classes.wizard`, `cards: (cards.book-of-ava, ...)` from
  daggerheart-srd), `experiences` as names (+2 each, derived), `story:` an
  open dictionary of sections (`include "background.typ"`, `read(...)`;
  include/read must live in the player's file, packages can't read the
  project). `derive(c)` returns the sheet's numbers as `(value:, parts:)`;
  `sheet(c)` renders it with the active theme. Advancements:
  `increase-traits`, `add-hit-point`, `add-stress`, `increase-experiences`,
  `extra-card`, `increase-evasion`, `upgrade-subclass`,
  `increase-proficiency`, `multiclass` (format only). Features carry
  `modifiers:` (number or `ctx => number`) and `grants: (domain-cards:)`.
- Checked against Foundryborne v2.12.9 `module/data/actor/character.mjs`
  (2026-11-17): Evasion, HP, Proficiency, thresholds (unarmored: level /
  2×level), Armor Score, Hope max 6 all agree. Differences: Foundry's Hope
  max subtracts scars (play state, not ours); Foundry has class-specific
  advancements (Brawler "Increase Dice Size", Combo Die), so advancements
  must stay extensible per class; per-tier advancement slot counts come
  from the printed sheet, not the SRD text, so they are not validated.
- Due per level (checked level by level): `cards-due(c, n)` (2 + 1 per
  level-up + extra cards + grants in effect by then, e.g. Accomplished;
  `level(n, card:)` takes a list when more are due) and `training-due(c,
  n)` for a companion.
- Card choices are a pair in the cards list: `(cards.vitality, ("hp",
  "stress"))`; `choices:`/`permanent-vault:` come from effects.typ.
- Companions (decided 2026-11-17): `character(..., companion:
  companion(...))` (daggerheart-srd's `companion` binds the SRD text);
  choices only (name, animal, 2 Experiences, attack name, damage type).
  Training is written in the character's level history:
  `level(n, companion: (train.aware(),), companion-experience: "...")`.
  `sheet` adds the companion sheet on its own page. Light in the Dark
  raises the character's Hope max.
- Not yet: multiclass derivation, wheelchair.
- First character: a real player character from the owner's Foundry export
  (fixtures/, kept out of git unless the owner says otherwise); its current
  Foundry values serve as a check for our derivation.

## Open questions
- Foundry (parked): target version, Foundryborne data-model fields, which
  SRD version it implements, creation path (macro vs compendium packing).

## Inputs the human must provide
- The SRD PDF in `reference/` (done: SRD 2.0).
- Foundry (parked): Foundryborne clone, exported fixtures in `fixtures/`.
