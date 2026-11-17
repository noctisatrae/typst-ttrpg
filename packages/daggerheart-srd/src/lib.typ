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

/// Adversaries by tier, each a dictionary of id -> adversary.
#let adversaries = (
  tier-1: tier-1.entries.map(a => (a.id, a)).to-dict(),
)

#let package-info = (name: "daggerheart-srd", version: version(0, 1, 0), srd: srd)
