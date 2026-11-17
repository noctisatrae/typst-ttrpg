// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// ttrpg-core: system-agnostic building blocks.
// Must never know what an "adversary" or "class" is.

#import "validate.typ": field, validate, check, report
#import "entity.typ": base-schema, feature-schema, full-schema, feature, entity
#import "extend.typ": extend, add, remove, replace, all
#import "registry.typ": register, lookup, registered
#import "theme.typ": default-theme, setup, current-theme, merge-theme, use-theme
#import "layout.typ": card, card-title, labeled, stat-line, band, section, entry, statblock, dice-pattern

/// Package metadata, useful for checking which version a document resolved.
#let package-info = (name: "ttrpg-core", version: version(0, 1, 0))
