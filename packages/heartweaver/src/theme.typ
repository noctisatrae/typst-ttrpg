// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Optional looks for Daggerheart content. Nothing here is applied by
// default; opt in with `#show: core.setup.with(theme: book-theme)`.

/// A warm, book-inspired look: cream page, beige cards, dark red headings,
/// ochre footer. Our own design, not Darrington Press trade dress.
#let book-theme = (
  colors: (
    text: rgb("#1f1b17"),
    page: rgb("#fbf8f2"),
    accent: rgb("#8e2b22"),
    card: rgb("#efebe3"),
    card-stroke: rgb("#cdc4b6"),
    band: white,
    rule: rgb("#d9d2c6"),
    footer: rgb("#e2b84a"),
  ),
)

/// A one-line summary of an adversary for inline mentions, e.g. a
/// screenplay `intro`: Difficulty 12 · HP 6.
#let summary(e) = [Difficulty #e.difficulty · HP #e.hp]
