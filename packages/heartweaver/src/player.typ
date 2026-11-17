// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Player-facing kinds: weapons, armor, ancestries, communities, classes,
// subclasses and domain cards. Rules come from the Daggerheart SRD 2.0:
// character creation (pp. 4-6), domains (p. 7), equipment (pp. 55-56),
// armor (p. 72), loadout (p. 3 "Loadout & Vault"), leveling up (pp. 53-54).
//
// Features may carry two structured extras next to their text, used by
// `derive` (character.typ). Only PERMANENT, UNCONDITIONAL effects get them;
// anything situational stays text for the player to apply.
// - modifiers: (evasion: -1), or a function of the character for effects
//   such as Mage Robes' "bonus equal to your Spellcast trait".
// - grants: extra choices, e.g. (domain-cards: 1) for "Prepared".

#import "@local/ttrpg-core:0.1.0" as core
#import core: field
#import "adversary.typ": attack-range, damage-type

/// The six character traits (p. 4), as the SRD prints them.
#let trait = (
  agility: "Agility",
  strength: "Strength",
  finesse: "Finesse",
  instinct: "Instinct",
  presence: "Presence",
  knowledge: "Knowledge",
)

/// Weapon categories and burdens (p. 55).
#let weapon-category = (primary: "Primary", secondary: "Secondary")
#let burden = (one-handed: "One-Handed", two-handed: "Two-Handed")

/// Domain card types as printed on the cards (pp. 206-223).
#let card-type = (ability: "Ability", spell: "Spell", grimoire: "Grimoire")

/// What a modifier may change. Each value is a number or a function
/// `c => number` of the partly derived character (traits, level,
/// spellcast trait), for effects that depend on other stats.
#let modifier-schema = (
  evasion: field(int, function),
  hp: field(int, function),
  stress: field(int, function),
  proficiency: field(int, function),
  armor-score: field(int, function),
  thresholds: field(int, function),
  attack: field(int, function),
  ..trait.keys().map(k => (k, field(int))).to-dict(),
)

/// What a feature may grant.
#let grant-schema = (
  domain-cards: field(int),
)

/// Features of player-facing kinds: name and text, plus optional effects.
#let player-feature-schema = core.feature-schema + (
  modifiers: field(dictionary, keys: modifier-schema),
  grants: field(dictionary, keys: grant-schema),
)

#let features-field(..args) = field(array, default: (), items: player-feature-schema, unique: "name", ..args)

#let weapon-schema = (
  tier: field(int, required: true, one-of: (1, 2, 3, 4)),
  category: field(str, required: true, one-of: weapon-category.values()),
  trait: field(str, required: true, one-of: trait.values()),
  range: field(str, required: true, one-of: attack-range.values()),
  damage: field(str, required: true),
  damage-type: field(str, required: true, one-of: damage-type.values()),
  burden: field(str, required: true, one-of: burden.values()),
  features: features-field(),
)

#let armor-schema = (
  tier: field(int, required: true, one-of: (1, 2, 3, 4)),
  thresholds: field(dictionary, required: true, keys: (major: field(int, required: true), severe: field(int, required: true))),
  score: field(int, required: true),
  features: features-field(),
)

#let ancestry-schema = (
  description: field(str, content),
  // Two features, in order: a mixed ancestry takes the first of one and
  // the second of another (p. 4).
  features: features-field(required: true),
)

#let community-schema = (
  description: field(str, content),
  features: features-field(required: true),
)

#let class-schema = (
  description: field(str, content),
  domains: field(array, required: true, items: str),
  evasion: field(int, required: true),
  hp: field(int, required: true),
  items: field(str, content),
  hope-feature: field(dictionary, required: true, keys: player-feature-schema),
  features: features-field(required: true),
)

#let subclass-schema = (
  description: field(str, content),
  class: field(str, required: true),
  spellcast-trait: field(str, one-of: trait.values()),
  foundation: features-field(required: true),
  specialization: features-field(required: true),
  mastery: features-field(required: true),
)

#let domain-card-schema = (
  domain: field(str, required: true),
  level: field(int, required: true, one-of: range(1, 11)),
  type: field(str, required: true, one-of: card-type.values()),
  recall-cost: field(int, required: true),
  text: field(str, content),
  features: features-field(),
)

#let weapon(id: none, name: none, tags: none, flags: none, tier: none, category: none, trait: none, range: none, damage: none, damage-type: none, burden: none, features: none, ..unknown) = core.entity("weapon", weapon-schema, id: id, name: name, tags: tags, flags: flags, tier: tier, category: category, trait: trait, range: range, damage: damage, damage-type: damage-type, burden: burden, features: features, ..unknown)

#let armor(id: none, name: none, tags: none, flags: none, tier: none, thresholds: none, score: none, features: none, ..unknown) = core.entity("armor", armor-schema, id: id, name: name, tags: tags, flags: flags, tier: tier, thresholds: thresholds, score: score, features: features, ..unknown)

#let ancestry(id: none, name: none, tags: none, flags: none, description: none, features: none, ..unknown) = core.entity("ancestry", ancestry-schema, id: id, name: name, tags: tags, flags: flags, description: description, features: features, ..unknown)

#let community(id: none, name: none, tags: none, flags: none, description: none, features: none, ..unknown) = core.entity("community", community-schema, id: id, name: name, tags: tags, flags: flags, description: description, features: features, ..unknown)

#let class(id: none, name: none, tags: none, flags: none, description: none, domains: none, evasion: none, hp: none, items: none, hope-feature: none, features: none, ..unknown) = core.entity("class", class-schema, id: id, name: name, tags: tags, flags: flags, description: description, domains: domains, evasion: evasion, hp: hp, items: items, hope-feature: hope-feature, features: features, ..unknown)

#let subclass(id: none, name: none, tags: none, flags: none, description: none, class: none, spellcast-trait: none, foundation: none, specialization: none, mastery: none, ..unknown) = core.entity("subclass", subclass-schema, id: id, name: name, tags: tags, flags: flags, description: description, class: class, spellcast-trait: spellcast-trait, foundation: foundation, specialization: specialization, mastery: mastery, ..unknown)

#let domain-card(id: none, name: none, tags: none, flags: none, domain: none, level: none, type: none, recall-cost: none, text: none, features: none, ..unknown) = core.entity("domain-card", domain-card-schema, id: id, name: name, tags: tags, flags: flags, domain: domain, level: level, type: type, recall-cost: recall-cost, text: text, features: features, ..unknown)

/// A mixed ancestry (p. 4): the first feature of `top` and the second of
/// `bottom`. `mixed-ancestry(ancestries.elf, ancestries.fungril)`.
#let mixed-ancestry(top, bottom, name: auto) = ancestry(
  id: top.id + "-" + bottom.id,
  name: if name == auto { top.name + "/" + bottom.name } else { name },
  features: (top.features.at(0), bottom.features.at(1)),
  flags: (mixed: (top.id, bottom.id)),
)
