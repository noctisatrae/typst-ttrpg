// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Martial stances (Brawler, Martial Artist subclass, SRD pp. 12-13). A
// Martial Artist knows two Tier 1 stances when they take the foundation
// card and learns one more, of their tier or lower, each level. Known
// stances are CHOICES, written like domain cards:
//
//   character(..., stances: (stances.favored, stances.reliable),
//     levels: (level(2, stance: stances.anchored, ...),))
//
// A feature that grants stances (`grants: (stances: rules)`) carries the
// rules' TEXT (`stance-rules`: Focus, shifting, dropping out) and the Focus
// maximum; daggerheart-srd binds the SRD's to "Stance Fighter". The sheet
// prints a Focus track, the known stances and those rules.

#import "@local/ttrpg-core:0.1.0" as core
#import core: field

#let stance-schema = (
  tier: field(int, required: true, one-of: (1, 2, 3, 4)),
  text: field(str, content, required: true),
)

/// A martial stance: `stance(id: "reliable", name: "Reliable", tier: 1,
/// text: "Gain a +1 bonus to your attack rolls.")`. Its effects apply only
/// while it is the active stance, so they stay text.
#let stance(id: none, name: none, tags: none, flags: none, tier: none, text: none, ..unknown) = core.entity("stance", stance-schema, id: id, name: name, tags: tags, flags: flags, tier: tier, text: text, ..unknown)

#let stance-rules-schema = (
  description: field(str, content),
  // Rules shown on the sheet ("Focus", "Shifting into Stances", ...).
  rules: field(array, required: true, items: core.feature-schema),
  // "You can hold a maximum of 6 Focus" (p. 13).
  focus: field(int, required: true),
  // How many stances are known when the feature is gained, and how many
  // more come with each level-up ("choose two martial stances from Tier
  // 1. Each time you level up your character, choose an additional
  // stance", p. 12).
  start: field(int, required: true),
  per-level: field(int, required: true),
)

/// The rules' text and numbers, from the system's data (daggerheart-srd's
/// `martial-stances`).
#let stance-rules(id: "martial-stances", name: "Martial Stances", tags: none, flags: none, description: none, rules: none, focus: none, start: none, per-level: none, ..unknown) = core.entity("stance-rules", stance-rules-schema, id: id, name: name, tags: tags, flags: flags, description: description, rules: rules, focus: focus, start: start, per-level: per-level, ..unknown)

/// One line for inline mentions: "Tier 1 Martial Stance".
#let stance-summary(s) = [Tier #s.tier Martial Stance]

/// A small card: name, tier, text. Registers the entity; `register:
/// false` renders without registering.
#let stance-card(s, register: true) = {
  if register { core.register(s) }
  core.card({
    core.card-title(s.name)
    block(below: 0.6em, text(weight: "bold", style: "italic", size: 1.1em)[Tier #s.tier Martial Stance])
    s.text
  })
}
