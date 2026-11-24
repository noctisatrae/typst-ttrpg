# heartweaver

Daggerheart Compatible rules for Typst: schemas, derivation and renderers
for adversaries, environments, loot, player options and character sheets.
Unofficial: not affiliated with, endorsed or sponsored by Darrington Press
or Critical Role.

This package holds **no SRD content**; it validates and renders entities
you write (homebrew) or load from a data package.

```typ
#import "@preview/heartweaver:0.1.0" as hw

#let thug = hw.adversary(
  id: "harbor-thug", name: "Harbor Thug", tier: 1, type: hw.adversary-type.bruiser,
  description: "A dockside brawler with a cudgel.",
  motives: "Intimidate, rob, run",
  difficulty: 12, thresholds: (major: 7, severe: 13), hp: 5, stress: 3,
  attack: (modifier: 1, name: "Cudgel", range: "Melee", damage: "1d10+2", damage-type: "phy"),
  features: (hw.feature("Shove", kind: hw.feature-kind.action)[Push a target back to Close range.],),
)

#hw.statblock(thug)
```

- **Adversaries, environments, items, consumables**: stat blocks in the
  active theme (`hw.book-theme` is a book-inspired look).
- **Characters** store choices and level history, never derived numbers:
  `hw.character(...)`, `hw.derive(c)` (Evasion, HP, Stress, thresholds,
  Armor Score, Proficiency, attacks, each with its sources) and
  `hw.sheet(c)`. Every level-up rule is checked, multiclassing
  included (`hw.multiclass`); companions (`hw.companion`, `hw.train`) too.
- **Transformations** (`hw.transformation`, with tick-box `tracks` and
  `write-ins`), **Beastforms** (`hw.beastform`; a Druid's sheet lists its
  forms with Evasion, attack and damage worked out) and **martial stances**
  (`hw.stance`; known stances are choices, checked per level).
- **Factions** (`hw.faction`): relationships (−3 to +3, named), assets,
  problems and objectives, with Objective Countdowns printed as boxes and
  their sizes and limits checked.
- **`hw.system`** plugs these kinds into
  [ttrpg-script](https://typst.app/universe/package/ttrpg-script).

Works you make must carry the Darrington Press Community Gaming License
attribution when they include SRD content (`hw.attribution()`).

Code under MPL-2.0. Source and examples:
https://github.com/noctisatrae/typst-ttrpg
