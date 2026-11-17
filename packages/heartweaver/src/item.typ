// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Loot: items and consumables. Daggerheart SRD 2.0, "Loot" (p. 75):
// "Loot comprises any consumables or reusable items the party acquires."
// Items "can be used until sold, discarded, or lost" (p. 75); consumables
// "can be used only once" and you can hold up to five of each (p. 80).
// Both are printed as the same roll table (Roll, Loot, description), so
// they share one schema and are two entity kinds. Weapons, armor and the
// combat wheelchair are equipment, not loot: they belong to characters.
//
// Rarity is not a property of an item: it picks how many d12s you roll
// on the table (p. 75), so the roll number is what the data records.

#import "@local/ttrpg-core:0.1.0" as core
#import core: field

/// The tables loot comes from: the SRD prints one table per product, each
/// introduced as "the items from the ..." (pp. 75, 77, 80, 82).
#let loot-collection = (
  core-set: "Daggerheart Core Set",
  hope-and-fear: "Hope & Fear Expansion Set",
)

#let loot-schema = (
  // The collection whose table lists it; rolls restart at 1 in each.
  collection: field(str, required: true, one-of: loot-collection.values()),
  // The table roll (sum of the d12s rolled), 1-60, exactly as the SRD
  // prints it: the Core Set tables use two digits ("07"), the Hope & Fear
  // tables don't ("7").
  roll: field(str, required: true, check: (value, fields) => {
    if type(value) != str or value.match(regex("^\d{1,2}$")) == none or int(value) < 1 or int(value) > 60 {
      "`roll` must be the printed roll, \"1\" to \"60\" (the loot tables, p. 75), got " + repr(value)
    }
  }),
  // The table's description, verbatim. Stones that grant a feature print
  // it on its own line ("Resilient: ...").
  description: field(str, content, required: true),
)

/// A loot item (reusable). See `loot-schema` for the fields.
///
/// ```typ
/// #let bedroll = item(id: "premium-bedroll", name: "Premium Bedroll",
///   collection: loot-collection.core-set, roll: 1,
///   description: "During downtime, you automatically clear a Stress.")
/// ```
#let item(
  id: none, name: none, tags: none, features: none, flags: none,
  collection: none, roll: none, description: none,
  ..unknown,
) = core.entity("item", loot-schema,
  id: id, name: name, tags: tags, features: features, flags: flags,
  collection: collection, roll: roll, description: description,
  ..unknown)

/// A consumable (single use). Same fields as `item`.
#let consumable(
  id: none, name: none, tags: none, features: none, flags: none,
  collection: none, roll: none, description: none,
  ..unknown,
) = core.entity("consumable", loot-schema,
  id: id, name: name, tags: tags, features: features, flags: flags,
  collection: collection, roll: roll, description: description,
  ..unknown)

#let kind-label = (item: "Item", consumable: "Consumable")

/// One line for inline mentions: just "Item" or "Consumable"; the
/// description is too long to quote inline.
#let loot-summary(e) = kind-label.at(e.kind)

/// A compact loot card: name, kind and table roll, then the description.
/// Registers the entity. `register: false` renders without registering.
#let loot-card(e, register: true) = {
  if register { core.register(e) }
  core.card(context {
    let theme = core.current-theme()
    block(below: 0.45em, text(font: theme.fonts.title, weight: 900, size: 1.25em, upper(e.name)))
    block(below: 0.6em, text(style: "italic", weight: "bold")[
      #kind-label.at(e.kind) · Roll #e.roll · #e.collection
    ])
    e.description
  })
}
