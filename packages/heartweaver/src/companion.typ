// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Animal companions (Beastbound Ranger, SRD pp. 20-22). Like a character,
// a companion stores CHOICES only: name, animal, two Experiences, its
// attack and damage type. Its level-up options ("training") are written in
// the character's own `level(...)` history, so the whole story lives in
// one place:
//
//   level(3, card: ..., advancements: (...), companion: (train.aware(),))
//
// The rules' TEXT comes from the system's data (`companion-rules`, e.g.
// daggerheart-srd's `ranger-companion`); the numbers are here.

#import "@local/ttrpg-core:0.1.0" as core
#import core: field
#import "adversary.typ": attack-range, damage-type

// Starting values the SRD states (p. 21).
#let start-evasion = 10
#let start-experience = 2
#let damage-dice = ("d6", "d8", "d10", "d12")
#let ranges = attack-range.values()

// NOT in the SRD text: the printed companion sheet gives the starting
// Stress slots and how many times each option can be marked ("choose one
// AVAILABLE option", p. 22). Values as in Foundryborne 2.12.9
// (resourceConfig.mjs, levelTier.mjs `defaultCompanionTier`).
#let start-stress = 3
#let training-limits = (
  intelligent: 3, light-in-the-dark: 1, creature-comfort: 1, armored: 1,
  vicious: 3, resilient: 3, bonded: 1, aware: 3,
)

/// The rules' text, from the system's data: `rules` (features shown on the
/// companion sheet), `training` (one feature per level-up option, keyed
/// like `training-limits`) and `example-experiences`.
#let companion-rules-schema = (
  rules: field(array, required: true, items: core.feature-schema),
  training: field(dictionary, required: true, keys: training-limits.keys().map(k => (k, field(dictionary, required: true, keys: core.feature-schema))).to-dict()),
  example-experiences: field(array, default: (), items: str),
)

#let companion-rules(id: "ranger-companion", name: "Ranger Companion", tags: none, flags: none, rules: none, training: none, example-experiences: none, ..unknown) = core.entity("companion-rules", companion-rules-schema, id: id, name: name, tags: tags, flags: flags, rules: rules, training: training, example-experiences: example-experiences, ..unknown)

#let companion-schema = (
  animal: field(str, required: true),
  pronouns: field(str),
  description: field(str, content),
  // Two at creation (p. 21); more come with the character's (levels 2, 5, 8).
  experiences: field(array, required: true, items: str),
  // The standard attack's name ("Bite"); range and die are derived.
  attack: field(str, required: true),
  damage-type: field(str, required: true, one-of: damage-type.values()),
  rules: field(dictionary, required: true),
)

/// A companion. Systems bind `rules:` (daggerheart-srd exports
/// `companion`, bound to the SRD text).
///
/// ```typ
/// companion(id: "brindille", name: "Brindille", animal: "Fox",
///   experiences: ("Scout", "Bold Distraction"), attack: "Bite", damage-type: "phy")
/// ```
#let companion(id: none, name: none, tags: none, flags: none, animal: none, pronouns: none, description: none, experiences: none, attack: none, damage-type: none, rules: none, ..unknown) = core.entity("companion", companion-schema, id: id, name: name, tags: tags, flags: flags, animal: animal, pronouns: pronouns, description: description, experiences: experiences, attack: attack, damage-type: damage-type, rules: rules, ..unknown)

/// Every training mark with the level it was taken at.
#let trainings(c) = c.levels.enumerate().map(((i, l)) => l.at("companion", default: ()).map(t => t + (level: i + 2))).flatten()

#let stat(label, value) = (value: value, parts: ((label, value),))
#let bump(s, label, delta) = (value: s.value + delta, parts: s.parts + ((label, delta),))

/// The companion sheet's numbers, from the character `c` and its derived
/// numbers `d` (the damage roll uses the character's Proficiency, p. 22;
/// commands are the character's Spellcast Rolls, p. 21).
#let derive-companion(c, d) = {
  let comp = c.companion
  let marks = trainings(c)
  let of(name) = marks.filter(t => t.training == name)
  let tag(t) = t.training.split("-").map(w => upper(w.first()) + w.slice(1)).join(" ") + ", level " + str(t.level)

  let evasion = stat("start", start-evasion)
  for t in of("aware") { evasion = bump(evasion, tag(t), 2) }
  let stress = stat("start", start-stress)
  for t in of("resilient") { stress = bump(stress, tag(t), 1) }
  let names = comp.experiences + c.levels.map(l => l.at("companion-experience", default: none)).filter(x => x != none)
  let experiences = names.map(n => {
    let s = stat("start", start-experience)
    for t in of("intelligent").filter(t => t.experience == n) { s = bump(s, tag(t), 1) }
    (name: n, bonus: s)
  })
  let steps(what) = of("vicious").filter(t => t.step == what).len()
  let die = damage-dice.at(calc.min(steps("damage"), damage-dice.len() - 1))
  let range = ranges.at(calc.min(steps("range"), ranges.len() - 1))
  let command = if d.spellcast-trait == none { none } else {
    (trait: d.spellcast-trait, modifier: d.traits.at(lower(d.spellcast-trait)).value + d.spellcast-bonus.value)
  }
  (
    evasion: evasion,
    stress: stress,
    experiences: experiences,
    attack: (name: comp.attack, range: range, die: die, damage: str(d.proficiency.value) + die, damage-type: comp.damage-type),
    command: command,
    // One entry per option taken, with the levels it was marked at.
    training: training-limits.keys().filter(k => of(k).len() > 0).map(k => (
      key: k, feature: comp.rules.training.at(k), marks: of(k),
    )),
  )
}

/// Rule problems with the companion and its training (the counts due per
/// level are checked by `character`).
#let check-companion(c) = {
  let errors = ()
  let comp = c.companion
  if comp.at("kind", default: none) != "companion" {
    return ("`companion` must be a companion entity, got " + repr(comp.at("kind", default: comp)),)
  }
  if comp.experiences.len() != 2 {
    errors.push("`companion`: " + comp.name + " needs exactly 2 Experiences at creation (p. 21), got " + str(comp.experiences.len()))
  }
  let marks = trainings(c)
  for (k, limit) in training-limits {
    let n = marks.filter(t => t.training == k).len()
    if n > limit { errors.push("companion training " + repr(k) + " can be marked " + str(limit) + " time" + if limit > 1 { "s" } + ", got " + str(n) + " (printed companion sheet)") }
  }
  let steps(what) = marks.filter(t => t.training == "vicious" and t.step == what).len()
  if steps("damage") > damage-dice.len() - 1 { errors.push("companion training \"vicious\": the damage die is already " + damage-dice.last() + " (p. 22)") }
  if steps("range") > ranges.len() - 1 { errors.push("companion training \"vicious\": the range is already " + ranges.last() + " (p. 22)") }
  for t in marks.filter(t => t.training == "intelligent") {
    let known = comp.experiences + c.levels.slice(0, t.level - 1).map(l => l.at("companion-experience", default: none)).filter(x => x != none)
    if t.experience not in known {
      errors.push("level " + str(t.level) + ": \"intelligent\" names " + repr(t.experience) + ", not one of " + comp.name + "'s Experiences: " + known.map(repr).join(", "))
    }
  }
  errors
}
