// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// heartweaver: Daggerheart Compatible schemas, derivation rules and renderers.
// Unofficial; not affiliated with Darrington Press.

#import "@local/ttrpg-core:0.1.0" as core
#import core: feature, add, remove, replace, all
#import "adversary.typ": adversary, adversary-schema, adversary-type, feature-kind, attack-range, damage-type, extend, statblock, signed, format-thresholds, format-damage
#import "environment.typ": environment, environment-schema, environment-type, environment-block, environment-summary
#import "item.typ": item, consumable, loot-schema, loot-collection, loot-card, loot-summary
#import "attribution.typ": attribution, attribution-text
#import "theme.typ": book-theme, summary
#import "system.typ": system

/// `extend` that knows every heartweaver kind, so homebrew variants of
/// environments and loot are re-validated too.
#let extend = core.extend.with(schemas: (
  adversary: adversary-schema,
  environment: environment-schema,
  item: loot-schema,
  consumable: loot-schema,
))

#let package-info = (
  name: "heartweaver",
  version: version(0, 1, 0),
  core: core.package-info.version,
)
