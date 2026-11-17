// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// The Daggerheart system description used by templates such as the
// screenplay package: `#show: script.setup.with(system: hw.system)`.
// Each entity kind is described once, in display order:
// - section: title in session outlines and appendices.
// - outline: listed in session outlines (false = appendix only, e.g.
//   classes, ancestries, communities, transformations, domain cards).
// - summary: entity -> one-line summary for inline mentions.
// - render: entity -> the full block.

#import "adversary.typ": statblock
#import "environment.typ": environment-block, environment-summary
#import "item.typ": loot-card, loot-summary
#import "theme.typ": summary

// Sections are the words the SRD uses for each table ("Environments",
// "Items", "Consumables"); adversaries are a script's "Cast".
#let system = (
  kinds: (
    adversary: (section: "Cast", outline: true, summary: summary, render: statblock),
    environment: (section: "Environments", outline: true, summary: environment-summary, render: environment-block),
    item: (section: "Items", outline: true, summary: loot-summary, render: loot-card),
    consumable: (section: "Consumables", outline: true, summary: loot-summary, render: loot-card),
  ),
)
