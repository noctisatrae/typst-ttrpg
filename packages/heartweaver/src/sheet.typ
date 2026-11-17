// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// The character sheet: every derived number, empty boxes for play state,
// features grouped by where they come from, loadout cards and the story.
// Drawn with the active core theme, so it suits the screenplay template
// (mono, black and white) as well as the book theme.

#import "@local/ttrpg-core:0.1.0" as core
#import "adversary.typ": signed
#import "player.typ": trait
#import "character.typ": derive

/// "11" plus its sources in small text when there is more than one.
#let with-sources(s) = {
  str(s.value)
  if s.parts.len() > 1 {
    text(size: 0.75em)[ (#s.parts.map(((l, v)) => l + " " + signed(v)).join(", "))]
  }
}

// Spacing between the sheet's blocks: section headings and feature entries
// get more room than in compact stat blocks.
#let section(title) = block(above: 2em, below: 0.9em, core.section(title))
#let entry(..args) = block(above: 1em, below: 1em, core.entry(..args))

/// How play state (HP, Stress, Hope, Armor slots) is printed:
/// - "field": a small box holding the starting value in faint gray, then
///   "/ total"; write over it in pencil, or ignore it when playing online.
/// - "boxes": a row of dark boxes to tick, for pencil-and-paper play.
/// - "none": just the total.
#let state-options = ("field", "boxes", "none")

/// Starting value in a faint box, then "/ total". The box hugs the number
/// (padding, not a fixed size), so the number stays on the text line.
#let field(start, total) = [#box(
  inset: (x: 0.55em, y: 0.15em),
  outset: (y: 0.1em),
  stroke: 0.6pt + luma(120),
  radius: 2pt,
  text(fill: luma(185), str(start)),
)~/~#total]

// The sheet's boxes hug their text; the space goes BETWEEN elements.
#let gap = 1.3em

#let tick-boxes(n, shape: "square") = {
  let one = if shape == "circle" { circle(radius: 0.38em, stroke: 0.7pt + luma(40)) } else { box(width: 0.8em, height: 0.8em, stroke: 0.7pt + luma(40)) }
  box(stack(dir: ltr, spacing: 0.25em, ..range(n).map(_ => one)))
}

/// HP, Stress, Hope and Armor slots in the chosen `state` style. HP,
/// Stress and Armor count MARKED slots (start at 0); Hope is held (starts
/// at 2).
#let play-state(d, state) = {
  let items = (
    ("HP", 0, d.hp.value, "square"),
    ("Stress", 0, d.stress.value, "square"),
    ("Hope", d.hope.start, d.hope.max, "circle"),
    ("Armor", 0, d.armor-score.value, "square"),
  )
  core.band(if state == "boxes" {
    grid(columns: (6.5em, 1fr), row-gutter: 0.6em, align: horizon,
      ..items.map(((l, start, n, shape)) => (strong(l), tick-boxes(n, shape: shape))).flatten())
  } else {
    items.map(((l, start, n, _)) => [*#l*~#if state == "field" { field(start, n) } else [#n]]).join(h(1.6em))
  })
}

/// The sheet for character `c`. Registers it. `state` sets how play state
/// is printed: "field" (default), "boxes" or "none".
#let sheet(c, state: "field", register: true) = {
  if state not in state-options {
    panic("sheet: `state` must be one of " + state-options.map(repr).join(", ") + ", got " + repr(state))
  }
  if register { core.register(c) }
  let d = derive(c)
  let entries(source, fs, tag: none) = fs.map(f => entry(f.name, tag: tag, f.body))
  core.card({
    core.card-title(c.name)
    block(below: 0.7em, text(weight: "bold", style: "italic", size: 1.1em)[Level #d.level #c.class.name · #c.subclass.name])
    block(below: 1.2em)[#c.ancestry.name · #c.community.name#if c.at("pronouns", default: none) != none [ · #c.pronouns]]

    block(above: 0pt, below: gap, core.band(
      core.stat-line(
        ("Evasion", with-sources(d.evasion)),
        ("Armor Score", with-sources(d.armor-score)),
        ("Thresholds", str(d.thresholds.major.value) + "/" + str(d.thresholds.severe.value)),
        ("Proficiency", str(d.proficiency.value)),
      ),
      if d.spellcast-trait != none { core.stat-line(("Spellcast", d.spellcast-trait)) },
    ))
    // The six traits, each in its own small box: name over modifier.
    block(above: gap, below: gap, context {
      let rule = core.current-theme().colors.rule
      grid(
        columns: (1fr,) * 6,
        column-gutter: 6pt,
        ..trait.pairs().map(((k, printed)) => block(
          width: 100%,
          inset: (x: 2pt, y: 4pt),
          stroke: 0.6pt + rule,
          radius: 3pt,
          align(center, text(size: 0.85em, strong(printed)) + linebreak() + text(size: 1.15em, signed(d.traits.at(k).value))),
        )),
      )
    })
    block(above: gap, below: 0pt, play-state(d, state))

    section("Experiences")
    d.experiences.map(e => [#e.name #signed(e.bonus.value)]).join[ · ]

    section("Equipment")
    for a in d.attacks {
      let w = a.weapon
      block(above: 1.1em, below: 0.6em)[*#w.name* --- #w.trait #signed(a.modifier) · #w.range · #a.damage #w.damage-type · #w.burden]
      for f in w.features { entry(f.name, f.body) }
    }
    if c.at("armor", default: none) != none {
      block(above: 1.1em, below: 0.6em)[*#c.armor.name* --- base thresholds #c.armor.thresholds.major/#c.armor.thresholds.severe · base score #c.armor.score]
      for f in c.armor.features { entry(f.name, f.body) }
    }

    section("Class: " + c.class.name)
    entry(c.class.hope-feature.name, tag: "Hope Feature", c.class.hope-feature.body)
    for f in c.class.features { entry(f.name, f.body) }
    section("Subclass: " + c.subclass.name)
    for (i, step) in ("foundation", "specialization", "mastery").enumerate() {
      if i < d.subclass-cards { for f in c.subclass.at(step) { entry(f.name, tag: upper(step.first()) + step.slice(1), f.body) } }
    }
    section("Heritage")
    for f in c.ancestry.features { entry(f.name, tag: c.ancestry.name, f.body) }
    for f in c.community.features { entry(f.name, tag: c.community.name, f.body) }

    section("Loadout")
    for k in d.loadout {
      block(above: 1.4em, below: 0.6em)[*#k.name* --- Level #k.level #k.domain #k.type · Recall Cost #k.recall-cost]
      if k.at("text", default: none) != none { k.text }
      for f in k.features { entry(f.name, f.body) }
    }
    if d.vault.len() > 0 {
      section("Vault")
      d.vault.map(k => k.name).join(", ")
    }

    if c.inventory.len() > 0 {
      section("Inventory")
      c.inventory.map(i => if type(i) == dictionary { i.name } else { i }).join(" · ")
    }
    for (title, body) in c.story {
      section(title.replace("-", " "))
      body
    }
  })
}

/// One line for inline mentions: Level 1 Wizard · Evasion 11 · HP 5.
#let character-summary(c) = {
  let d = derive(c)
  [Level #d.level #c.class.name · Evasion #d.evasion.value · HP #d.hp.value]
}
