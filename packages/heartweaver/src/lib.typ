// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// heartweaver: Daggerheart Compatible schemas, derivation rules and renderers.
// Unofficial; not affiliated with Darrington Press.

#import "@local/ttrpg-core:0.1.0" as core
#import core: feature, add, remove, replace, all
#import "adversary.typ": adversary, adversary-schema, adversary-type, feature-kind, attack-range, damage-type, extend, statblock, signed, format-thresholds, format-damage
#import "attribution.typ": attribution, attribution-text
#import "theme.typ": book-theme, summary

#let package-info = (
  name: "heartweaver",
  version: version(0, 1, 0),
  core: core.package-info.version,
)
