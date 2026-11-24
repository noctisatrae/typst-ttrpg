// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Layout primitives for stat blocks and cards. They know about boxes, lines
// and labels, never about a game's fields; systems assemble them.

#import "theme.typ": current-theme

#let card-inset = 10pt

/// Dice expressions like `2d10+6` or `d20`, styled in the mono font by
/// `card` wherever they appear in its text.
#let dice-pattern = regex("\b\d*d\d+(?:[+-]\d+)?\b")

/// Numbers like `12`, `+2`, `−2` (U+2212) or `6/11`, styled in the mono
/// font inside bands.
#let number-pattern = regex("[+\-−]?\d+(?:/\d+)?")

/// A themed box holding one stat block. It stays in one piece, unless it is
/// taller than a whole column or page: then it breaks rather than overflow.
#let card(body) = context {
  let theme = current-theme()
  // Bold as an absolute weight, not "+300": otherwise dice inside bold text
  // come out heavier than dice elsewhere.
  show strong: it => text(weight: "bold", it.body)
  show dice-pattern: it => text(font: theme.fonts.mono, weight: "semibold", size: 0.95em, it)
  set text(font: theme.fonts.body, size: theme.sizes.body)
  let card-block(breakable) = block(
    width: 100%,
    breakable: breakable,
    fill: theme.colors.card,
    stroke: 0.6pt + theme.colors.card-stroke,
    radius: 5pt,
    inset: card-inset,
    below: 1.2em,
    body,
  )
  layout(size => card-block(measure(card-block(false), width: size.width).height > size.height))
}

/// The big all-caps name at the top of a card.
#let card-title(body) = context {
  let theme = current-theme()
  set par(leading: 0.3em)
  block(below: 0.8em, text(
    font: theme.fonts.title,
    size: theme.sizes.title,
    weight: 900,
    tracking: 0.01em,
    upper(body),
  ))
}

/// `Label: value` with a bold label.
#let labeled(label, value) = [*#label:* #value]

/// One line of values separated by bars. Each item is a `(label, value)`
/// pair or a bare value without a label:
/// `stat-line(("ATK", "+1"), ("Daggers", "Melee"), "1d8+1 phy")`.
#let stat-line(..items) = context {
  let theme = current-theme()
  let bar = text(fill: theme.colors.card-stroke)[ | ]
  items.pos().map(item => if type(item) == array { labeled(..item) } else { item }).join(bar)
}

/// A white band of stat lines with rounded corners.
#let band(..lines) = context {
  let theme = current-theme()
  block(
    width: 100%,
    above: 0pt,
    below: 0pt,
    inset: (x: 6pt, y: 5pt),
    fill: theme.colors.band,
    stroke: 0.6pt + theme.colors.rule,
    radius: 3pt,
    {
      set par(spacing: 0.5em)
      // Numbers in the mono font; dice are already styled by `card`.
      show number-pattern: it => text(font: theme.fonts.mono, size: 0.95em, it)
      lines.pos().join(parbreak())
    },
  )
}

/// A small all-caps section heading such as FEATURES.
#let section(title) = context {
  let theme = current-theme()
  block(above: 1.3em, below: 0.6em, text(
    font: theme.fonts.title,
    size: theme.sizes.section,
    weight: 700,
    upper(title),
  ))
}

/// A named entry with a hanging indent: *_Name - Tag:_* body. The body may
/// hold several paragraphs and lists (a set rule, not `par(...)`, which
/// can't contain them).
#let entry(name, tag: none, children: (), body) = {
  let head = if tag == none { name } else { name + " - " + tag }
  let parent = block(above: 0.6em, below: 0.6em, {
    set par(hanging-indent: 0.9em, spacing: 0.45em)
    set list(indent: 0.9em, spacing: 0.45em)
    set enum(indent: 0.9em, spacing: 0.45em)
    // The trailing parbreak makes even a one-line body a paragraph, so
    // the hanging indent applies (inline text alone forms no paragraph).
    [*_#head;:_* #body]
    parbreak()
  })
  if children.len() == 0 { return parent }
  // Children (entries) indented under their parent, with a thin rule.
  parent
  context pad(left: 0.9em, block(
    stroke: (left: 1.2pt + current-theme().colors.rule),
    inset: (left: 0.7em, y: 0.1em),
    children.join(),
  ))
}

/// A generic stat block: title, a few header lines, bands of stats and
/// titled sections of entries. Systems map their entities onto this.
///
/// - subtitle: e.g. "Tier 1 Leader", set bold italic.
/// - description: italic flavor line.
/// - header: lines shown above the bands (e.g. motives).
/// - bands: arrays of stat lines; each array becomes one band.
/// - sections: (title: str, entries: array of content).
#let statblock(
  title: none,
  subtitle: none,
  description: none,
  header: (),
  bands: (),
  sections: (),
) = card({
  card-title(title)
  if subtitle != none { block(below: 0.5em, text(weight: "bold", style: "italic", size: 1.1em, subtitle)) }
  if description != none { block(below: 0.5em, emph(description)) }
  for line in header { block(below: 0.6em, line) }
  if bands.len() > 0 {
    block(above: 0.7em, stack(spacing: 4pt, ..bands.map(lines => band(..lines))))
  }
  for s in sections {
    section(s.title)
    for e in s.entries { e }
  }
})

/// A row of `n` empty boxes to tick by pen, e.g. a countdown or a track.
/// `shape`: "square" or "circle". `end`: a label after the last box, the
/// result of filling the row ("Hollow"), drawn as "→ Hollow". The row is
/// an inline box, so it sits on a text line.
#let boxes(n, shape: "square") = context {
  let stroke = 0.7pt + current-theme().colors.text
  let one = if shape == "circle" { circle(radius: 0.38em, stroke: stroke) } else { box(width: 0.8em, height: 0.8em, stroke: stroke) }
  box(baseline: 0.1em, stack(dir: ltr, spacing: 0.25em, ..range(n).map(_ => one)))
}

/// A label with `lines` blank lines to write on by pen: an anchor, a goal,
/// a name chosen in play. The first line starts after the label.
#let write-in(label, lines: 1) = context {
  let rule = 0.5pt + current-theme().colors.card-stroke
  // A grid, not linebreaks: the rows stay tight whatever the theme's
  // paragraph leading, and every line starts under the first one.
  let rule-cell = block(width: 100%, height: 1.4em, stroke: (bottom: rule))
  block(above: 0.8em, below: 0.8em, grid(
    columns: (auto, 1fr), column-gutter: 0.4em, align: bottom,
    [*#label:*], rule-cell,
    ..range(lines - 1).map(_ => ([], rule-cell)).flatten(),
  ))
}
