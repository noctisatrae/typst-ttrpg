// A made-up system used only to test ttrpg-core. Not game content.
#import "@local/ttrpg-core:0.1.0" as core
#import core: field, feature, add, remove, replace, all

#let creature-schema = (
  size: field(str, required: true, one-of: ("small", "medium", "large")),
  hp: field(int, required: true),
  defense: field(dictionary, required: true),
  features: field(array, default: (), unique: "name",
    items: core.feature-schema + (kind: field(str, required: true, one-of: ("passive", "action")))),
)

// Go-style constants for editor completion; they are just strings.
#let size = (small: "small", medium: "medium", large: "large")

#let creature(
  id: none, name: none, tags: none, features: none, flags: none,
  size: none, hp: none, defense: none,
  ..unknown,
) = core.entity("creature", creature-schema,
  id: id, name: name, tags: tags, features: features, flags: flags,
  size: size, hp: hp, defense: defense, ..unknown)

#let extend = core.extend.with(schemas: (creature: creature-schema))

#let goblin = creature(
  id: "goblin", name: "Goblin", size: "small", hp: 3,
  defense: (low: 4, high: 8), tags: ("sneaky",),
  features: (
    feature("Stab", kind: "action")[Deals a little damage.],
    feature("Flee", kind: "action")[Runs away.],
    feature("Darkvision", kind: "passive")[Sees in the dark.],
  ),
)
