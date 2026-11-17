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
#import "player.typ" as player
#import "player.typ": weapon, armor, ancestry, community, class, subclass, domain-card, mixed-ancestry, trait, weapon-category, burden, card-type
#import "sheet.typ": sheet, character-summary
#import "companion.typ": companion, companion-rules, derive-companion
#import "training.typ" as train
#import "character.typ": character, derive, cards-due, training-due, level, increase-traits, add-hit-point, add-stress, increase-experiences, extra-card, increase-evasion, upgrade-subclass, increase-proficiency, multiclass

/// `extend` that knows every heartweaver kind, so homebrew variants of
/// environments and loot are re-validated too.
#let extend = core.extend.with(schemas: (
  adversary: adversary-schema,
  environment: environment-schema,
  item: loot-schema,
  consumable: loot-schema,
  weapon: player.weapon-schema,
  armor: player.armor-schema,
  ancestry: player.ancestry-schema,
  community: player.community-schema,
  class: player.class-schema,
  subclass: player.subclass-schema,
  domain-card: player.domain-card-schema,
))

#let package-info = (
  name: "heartweaver",
  version: version(0, 1, 0),
  core: core.package-info.version,
)
