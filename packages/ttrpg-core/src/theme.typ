// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Themes: one dictionary of fonts, sizes and colors. `setup` applies a theme
// to the document; renderers read it with `current-theme()` in a context.
//
// Packages cannot install fonts, so every font is a fallback list. The
// defaults expect Inter, Inter Display and Geist Mono (all SIL OFL).
//
// The default theme is deliberately neutral (black on white, outlined
// cards). Systems ship optional looks, e.g. `heartweaver.book-theme`, and
// other templates (screenplay) set their own, so the same stat block
// matches whatever document it is placed in.

#let default-theme = (
  fonts: (
    body: ("Inter", "Helvetica Neue", "Arial"),
    title: ("Inter Display", "Inter", "Helvetica Neue", "Arial"),
    mono: ("Geist Mono", "Menlo", "DejaVu Sans Mono"),
  ),
  sizes: (
    body: 8.5pt,
    title: 17pt,
    heading: 20pt,
    section: 10.5pt,
  ),
  colors: (
    text: rgb("#1a1a1a"),
    page: white,
    accent: rgb("#1a1a1a"),
    card: none,
    card-stroke: rgb("#8a8a8a"),
    band: none,
    rule: rgb("#c4c4c4"),
    footer: rgb("#c4c4c4"),
  ),
)

#let theme-state = state("ttrpg-core:theme", default-theme)

/// Merges `overrides` into `theme` one level deep, so
/// `(colors: (accent: red))` changes only the accent color.
#let merge-theme(theme, overrides) = {
  for (key, value) in overrides {
    if type(value) == dictionary and type(theme.at(key, default: none)) == dictionary {
      theme.insert(key, theme.at(key) + value)
    } else {
      theme.insert(key, value)
    }
  }
  theme
}

/// The theme in effect at this point. Needs `context`.
#let current-theme() = theme-state.get()

/// Content that switches the theme from this point on, merged over the
/// default, without touching page or text settings. For templates that do
/// their own page setup (e.g. the screenplay template).
#let use-theme(theme) = theme-state.update(merge-theme(default-theme, theme))

/// The latest level-1 heading at this point, used as the running title.
/// Needs `context`.
#let running-title() = {
  let found = query(selector(heading.where(level: 1)).before(here()))
  if found.len() > 0 { found.last().body }
}

/// Page footer: a rule, the page number on a tab, and the running title.
/// Mirrored like a printed book: even pages on the left, odd on the right.
#let page-footer(theme) = context {
  let number = counter(page).get().first()
  let tab = box(
    fill: theme.colors.footer,
    radius: 2pt,
    inset: (x: 6pt, y: 3pt),
    text(font: theme.fonts.mono, weight: "bold", str(number)),
  )
  let title = text(weight: "bold", running-title())
  let even = calc.even(number)
  block(width: 100%, stroke: (top: 1.2pt + theme.colors.footer), inset: (top: 5pt), {
    set align(if even { left } else { right })
    if even { tab + h(8pt) + title } else { title + h(8pt) + tab }
  })
}

/// Document template: `#show: setup.with(theme: (colors: (accent: blue)))`.
/// `footer: false` turns the page footer off.
#let setup(theme: (:), footer: true, body) = {
  let theme = merge-theme(default-theme, theme)
  theme-state.update(theme)
  set page(fill: theme.colors.page, footer: if footer { page-footer(theme) })
  set text(font: theme.fonts.body, size: theme.sizes.body, fill: theme.colors.text)
  set par(justify: false, leading: 0.68em, spacing: 0.8em)
  show heading.where(level: 1): it => block(below: 1em, text(
    font: theme.fonts.title,
    size: theme.sizes.heading,
    weight: 900,
    fill: theme.colors.accent,
    upper(it.body),
  ))
  body
}
