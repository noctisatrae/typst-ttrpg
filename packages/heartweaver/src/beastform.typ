// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Beastforms (Druid, SRD pp. 14-18). A form gives a trait bonus, an
// Evasion bonus, its own attack (range, trait, damage dice, used with the
// character's Proficiency), advantages on some verbs, and features. Two
// shapes have fewer fields: upgraded forms ("Legendary Beast": an "Evolved"
// feature only) and hybrids (stats, no advantages).
//
// The Druid's "Beastform" feature grants `beastforms` (effects.typ); the
// character then lists the forms it can take (`beastforms:`, usually all of
// daggerheart-srd's) and the sheet shows those of its tier or lower with
// the numbers worked out: "Evasion 13 · Agility +3 · 2d4 phy".

#import "@local/ttrpg-core:0.1.0" as core
#import core: field
#import "adversary.typ": attack-range, damage-type, signed
#import "player.typ": trait, features-field

#let beastform-schema = (
  tier: field(int, required: true, one-of: (1, 2, 3, 4)),
  // The animals it covers, as printed in parentheses ("Fox, Mouse,
  // Weasel, etc."; "Upgraded Tier 1 Options").
  examples: field(str, content),
  // "Agility +1 | Evasion +2": the trait raised while transformed, by how
  // much, and the bonus added to the character's Evasion.
  trait: field(str, one-of: trait.values()),
  trait-bonus: field(int),
  evasion-bonus: field(int),
  // "Melee Agility d4 phy": rolled with the character's Proficiency.
  attack: field(dictionary, keys: (
    range: field(str, required: true, one-of: attack-range.values()),
    trait: field(str, required: true, one-of: trait.values()),
    damage: field(str, required: true),
    damage-type: field(str, required: true, one-of: damage-type.values()),
  )),
  // "Gain advantage on: deceive, locate, sneak".
  advantages: field(array, default: (), items: str),
  features: features-field(required: true),
)

/// A Beastform option.
///
/// ```typ
/// #let fox = beastform(id: "agile-scout", name: "Agile Scout", tier: 1,
///   examples: "Fox, Mouse, Weasel, etc.", trait: "Agility", trait-bonus: 1,
///   evasion-bonus: 2, attack: (range: "Melee", trait: "Agility", damage: "d4",
///   damage-type: "phy"), advantages: ("deceive", "locate", "sneak"),
///   features: (feature("Agile")[...],))
/// ```
#let beastform(
  id: none, name: none, tags: none, flags: none,
  tier: none, examples: none, trait: none, trait-bonus: none, evasion-bonus: none,
  attack: none, advantages: none, features: none,
  ..unknown,
) = {
  let b = core.entity("beastform", beastform-schema,
    id: id, name: name, tags: tags, flags: flags,
    tier: tier, examples: examples, trait: trait, trait-bonus: trait-bonus, evasion-bonus: evasion-bonus,
    attack: attack, advantages: advantages, features: features,
    ..unknown)
  let given = ("trait", "trait-bonus", "evasion-bonus").filter(k => k in b)
  if given.len() not in (0, 3) {
    panic("beastform " + repr(b.id) + ": `trait`, `trait-bonus` and `evasion-bonus` go together (\"Agility +1 | Evasion +2\"), got only " + given.map(k => "`" + k + "`").join(", "))
  }
  b
}

/// "Agility +1 | Evasion +2" and "Melee Agility d4 phy", or none for an
/// upgraded form.
#let stat-text(b) = if "trait" in b [#b.trait #signed(b.trait-bonus) | Evasion #signed(b.evasion-bonus)]
#let attack-text(b) = if "attack" in b [#b.attack.range #b.attack.trait #b.attack.damage #b.attack.damage-type]

/// One line for inline mentions: "Tier 1 Beastform · Agility +1 · Evasion +2".
#let beastform-summary(b) = [Tier #b.tier Beastform#if "trait" in b [ · #b.trait #signed(b.trait-bonus) · Evasion #signed(b.evasion-bonus)]]

/// The form's lines below its name, shared by the block and the sheet.
#let beastform-lines(b) = (
  stat-text(b),
  attack-text(b),
  if b.advantages.len() > 0 [*Gain advantage on:* #b.advantages.join(", ")],
).filter(x => x != none)

/// A Beastform block: name, tier and examples, stats, attack, advantages,
/// features. Registers the entity; `register: false` renders without.
#let beastform-block(b, register: true) = {
  if register { core.register(b) }
  core.card({
    core.card-title(b.name)
    block(below: 0.6em, text(weight: "bold", style: "italic", size: 1.1em)[Tier #b.tier Beastform#if b.at("examples", default: none) != none [ · (#b.examples)]])
    let lines = beastform-lines(b)
    if lines.len() > 0 { block(above: 0.7em, below: 0.7em, core.band(..lines)) }
    for f in b.features { core.entry(f.name, f.body) }
  })
}

/// The numbers of form `b` for a character, from the derived traits,
/// Evasion and Proficiency (`d`, see `derive`): the attack modifier counts
/// the form's trait bonus when the attack uses that trait (p. 15).
/// Returns `(form:, evasion:, attack:, damage:)`; the last three are none
/// for an upgraded form.
#let beastform-numbers(b, d) = {
  if "trait" not in b { return (form: b, evasion: none, attack: none, damage: none) }
  let a = b.attack
  let t = d.traits.at(lower(a.trait)).value + if a.trait == b.trait { b.trait-bonus } else { 0 }
  (
    form: b,
    evasion: d.evasion.value + b.evasion-bonus,
    attack: t + d.attack-bonus,
    damage: str(d.proficiency.value) + a.damage,
  )
}
