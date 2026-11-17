// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// daggerheart-srd: SRD content transcribed by hand. Data only, no rendering;
// entities are built with heartweaver's constructors so they are validated.

/// The SRD edition every record in this package was transcribed from.
#let srd = (
  name: "Daggerheart SRD",
  version: "2.0",
  date: datetime(year: 2026, month: 8, day: 25),
  url: "https://www.daggerheart.com/srd/",
  file: "DH_SRD_2_2026_08_25.pdf",
)

#import "adversaries/tier-1.typ" as tier-1
#import "adversaries/tier-2.typ" as tier-2
#import "adversaries/tier-3.typ" as tier-3
#import "adversaries/tier-4.typ" as tier-4

/// Adversaries by tier, each a dictionary of id -> adversary, in the order
/// of the SRD's tier lists (pp. 95-96).
#let adversaries = (
  tier-1: tier-1.entries.map(a => (a.id, a)).to-dict(),
  tier-2: tier-2.entries.map(a => (a.id, a)).to-dict(),
  tier-3: tier-3.entries.map(a => (a.id, a)).to-dict(),
  tier-4: tier-4.entries.map(a => (a.id, a)).to-dict(),
)

#import "environments/tier-1.typ" as env-tier-1
#import "loot/items.typ" as loot-items
#import "loot/consumables.typ" as loot-consumables

/// Environments by tier, each a dictionary of id -> environment, in SRD
/// order (pp. 160-166 for Tier 1).
#let environments = (
  tier-1: env-tier-1.entries.map(e => (e.id, e)).to-dict(),
)

/// Loot from the SRD's roll tables (pp. 75-84), id -> entity, in table
/// order: the Core Set table, then the Hope & Fear Expansion Set table.
#let items = loot-items.entries.map(e => (e.id, e)).to-dict()
#let consumables = loot-consumables.entries.map(e => (e.id, e)).to-dict()

#let package-info = (name: "daggerheart-srd", version: version(0, 1, 0), srd: srd)
