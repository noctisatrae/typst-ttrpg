# ttrpg-core

System-agnostic building blocks for tabletop RPG content in Typst:
validated entities, `extend` for variants, a registry, themes and stat-block
layout. It never knows what an "adversary" or a "class" is; game systems
build on it (see [heartweaver](https://github.com/noctisatrae/typst-ttrpg)).

```typ
#import "@preview/ttrpg-core:0.1.0" as core
#import core: field, feature, add

#let creature-schema = (
  hp: field(int, required: true),
  features: field(array, default: (), unique: "name", items: core.feature-schema),
)
#let creature(id: none, name: none, hp: none, features: none, ..unknown) = core.entity(
  "creature", creature-schema, id: id, name: name, hp: hp, features: features, ..unknown)
#let extend = core.extend.with(schemas: (creature: creature-schema))

#let goblin = creature(id: "goblin", name: "Goblin", hp: 3,
  features: (feature("Stab")[Deals a little damage.],))
// A new entity; lists change only through explicit operations.
#let boss = extend(goblin, id: "goblin-boss", name: "Goblin Boss", hp: 6,
  features: add(feature("Shout")[Calls more goblins.]))
```

What you get:
- **Entities** are plain dictionaries. Unknown fields are errors, and all
  problems are reported at once with "did you mean" hints.
- **`extend`** replaces scalars and dictionaries; lists need `add`,
  `remove`, `replace` or `all`, so nothing changes by accident.
- **Registry**: the same id rendered twice counts once; different content
  under one id is an error.
- **Layout**: `card`, `band`, `stat-line`, `section`, `entry`,
  `statblock`, styled by the active theme (`setup`, `use-theme`).

Code under MPL-2.0. Source, tests and examples:
https://github.com/noctisatrae/typst-ttrpg
