// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Adversaries. Every rule here comes from the Daggerheart SRD 2.0,
// "Adversary Stat Blocks" (pp. 93-94); page numbers are noted per field.
// The SRD defines no derivation for adversary stats (the p. 95 benchmarks
// are guidance), so every value is authored.

#import "@local/ttrpg-core:0.1.0" as core
#import core: field

// Go-style constants for editor completion. The values are the exact words
// the SRD prints, so stat blocks render them unchanged.

/// Adversary types (p. 93).
#let adversary-type = (
  bruiser: "Bruiser",
  horde: "Horde",
  leader: "Leader",
  minion: "Minion",
  ranged: "Ranged",
  skulk: "Skulk",
  social: "Social",
  solo: "Solo",
  standard: "Standard",
  support: "Support",
)

/// Feature kinds: actions, reactions and passives (p. 93), plus
/// evolutions (p. 94), which stat blocks label "Evolution".
#let feature-kind = (
  action: "Action",
  reaction: "Reaction",
  passive: "Passive",
  evolution: "Evolution",
)

/// Ranges used by standard attacks in the SRD stat blocks.
#let attack-range = (
  melee: "Melee",
  very-close: "Very Close",
  close: "Close",
  far: "Far",
  very-far: "Very Far",
)

/// Damage types as abbreviated in stat blocks; "phy/mag" occurs once.
#let damage-type = (
  physical: "phy",
  magic: "mag",
  physical-or-magic: "phy/mag",
)

#let adversary-schema = (
  // Tier and type appear together, e.g. "Tier 1 Leader" (p. 93).
  tier: field(int, required: true, one-of: (1, 2, 3, 4)),
  type: field(str, required: true, one-of: adversary-type.values(), check: (value, fields) => {
    let has-size = "creatures-per-hp" in fields
    if value == adversary-type.horde and not has-size {
      "a Horde needs `creatures-per-hp` (the X in \"X/HP\", p. 93)"
    } else if value != adversary-type.horde and has-size {
      "`creatures-per-hp` is only for Hordes, but `type` is " + repr(value)
    }
  }),
  // Hordes: creatures represented by each Hit Point, "X/HP" (p. 93).
  creatures-per-hp: field(int),
  description: field(str, content, required: true),
  // "Motives & Tactics" (p. 93), kept verbatim as one line.
  motives: field(str, content, required: true),
  difficulty: field(int, required: true),
  // Major and Severe thresholds (p. 93). Either may be `none`, printed
  // "None": Minions have "None", a few adversaries have e.g. "3/None".
  thresholds: field(dictionary, required: true, keys: (
    major: field(int, type(none), required: true),
    severe: field(int, type(none), required: true),
  )),
  hp: field(int, required: true),
  stress: field(int, required: true),
  // Attack modifier and standard attack: name, range, damage (p. 93).
  attack: field(dictionary, required: true, keys: (
    modifier: field(int, required: true),
    name: field(str, required: true),
    range: field(str, required: true, one-of: attack-range.values()),
    // Dice or a flat number, e.g. "1d8+3" or "2".
    damage: field(str, required: true),
    damage-type: field(str, required: true, one-of: damage-type.values()),
    // Direct damage, printed "40 direct phy".
    direct: field(bool, default: false),
  )),
  // Experience is optional (p. 93).
  experiences: field(array, default: (), unique: "name", items: (
    name: field(str, required: true),
    bonus: field(int, required: true),
  )),
  features: field(array, default: (), unique: "name",
    items: core.feature-schema + (kind: field(str, required: true, one-of: feature-kind.values()))),
)

/// An adversary. Every field is named; see `adversary-schema` for types.
///
/// ```typ
/// #let bandit = adversary(
///   id: "jagged-knife-bandit", name: "Jagged Knife Bandit",
///   tier: 1, type: adversary-type.standard,
///   description: "...", motives: "...",
///   difficulty: 12, thresholds: (major: 8, severe: 14), hp: 5, stress: 3,
///   attack: (modifier: 1, name: "Daggers", range: attack-range.melee,
///     damage: "1d8+1", damage-type: damage-type.physical),
///   experiences: ((name: "Thief", bonus: 2),),
///   features: (feature("Climber", kind: feature-kind.passive)[...],),
/// )
/// ```
#let adversary(
  id: none, name: none, tags: none, features: none, flags: none,
  tier: none, type: none, creatures-per-hp: none,
  description: none, motives: none,
  difficulty: none, thresholds: none, hp: none, stress: none,
  attack: none, experiences: none,
  ..unknown,
) = core.entity("adversary", adversary-schema,
  id: id, name: name, tags: tags, features: features, flags: flags,
  tier: tier, type: type, creatures-per-hp: creatures-per-hp,
  description: description, motives: motives,
  difficulty: difficulty, thresholds: thresholds, hp: hp, stress: stress,
  attack: attack, experiences: experiences,
  ..unknown)

/// `extend` that knows heartweaver's kinds.
#let extend = core.extend.with(schemas: (adversary: adversary-schema))

/// Signed modifier as printed in the SRD: "+2", "−1" (U+2212 minus).
#let signed(n) = if n < 0 { "−" + str(calc.abs(n)) } else { "+" + str(n) }

#let format-thresholds(t) = {
  let show-one(v) = if v == none { "None" } else { str(v) }
  if t.major == none and t.severe == none { "None" } else { show-one(t.major) + "/" + show-one(t.severe) }
}

#let format-damage(a) = a.damage + if a.direct { " direct" } + " " + a.damage-type

/// Renders an adversary stat block and registers it in the document.
/// `register: false` renders without registering (e.g. a preview).
#let statblock(e, register: true) = {
  if register { core.register(e) }
  let kind = e.type + if e.at("creatures-per-hp", default: none) != none {
    " (" + str(e.creatures-per-hp) + "/HP)"
  }
  core.statblock(
    title: e.name,
    subtitle: "Tier " + str(e.tier) + " " + kind,
    description: e.description,
    header: (core.labeled("Motives & Tactics", e.motives),),
    bands: (
      (
        core.stat-line(
          ("Difficulty", str(e.difficulty)),
          ("Thresholds", format-thresholds(e.thresholds)),
          ("HP", str(e.hp)),
          ("Stress", str(e.stress)),
        ),
        core.stat-line(
          ("ATK", signed(e.attack.modifier)),
          (e.attack.name, e.attack.range),
          format-damage(e.attack),
        ),
      ),
      ..if e.experiences.len() > 0 {
        ((core.stat-line(("Experience", e.experiences.map(x => x.name + " " + signed(x.bonus)).join(", "))),),)
      },
    ),
    sections: if e.features.len() > 0 {
      ((title: "Features", entries: e.features.map(f => core.entry(f.name, tag: f.kind, f.body))),)
    } else { () },
  )
}
