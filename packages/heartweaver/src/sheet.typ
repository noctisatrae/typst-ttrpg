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

#let boxes(n, shape: "square") = {
  let one = if shape == "circle" { circle(radius: 0.38em, stroke: 0.6pt) } else { box(width: 0.8em, height: 0.8em, stroke: 0.6pt) }
  box(stack(dir: ltr, spacing: 0.25em, ..range(n).map(_ => one)))
}

/// "11" plus its sources in small text when there is more than one.
#let with-sources(s) = {
  str(s.value)
  if s.parts.len() > 1 {
    text(size: 0.75em)[ (#s.parts.map(((l, v)) => l + " " + signed(v)).join(", "))]
  }
}

#let track(label, n, shape: "square", note: none) = block(above: 0.5em, below: 0pt, grid(
  columns: (6.5em, 1fr),
  align: horizon,
  strong(label), [#boxes(n, shape: shape)#if note != none { h(0.6em); text(size: 0.8em, emph(note)) }],
))

/// The sheet for character `c`. Registers it.
#let sheet(c, register: true) = {
  if register { core.register(c) }
  let d = derive(c)
  let entries(source, fs, tag: none) = fs.map(f => core.entry(f.name, tag: tag, f.body))
  core.card({
    core.card-title(c.name)
    block(below: 0.4em, text(weight: "bold", style: "italic", size: 1.1em)[Level #d.level #c.class.name · #c.subclass.name])
    block(below: 0.6em)[#c.ancestry.name · #c.community.name#if c.at("pronouns", default: none) != none [ · #c.pronouns]]

    core.band(
      core.stat-line(
        ("Evasion", with-sources(d.evasion)),
        ("Armor Score", with-sources(d.armor-score)),
        ("Thresholds", str(d.thresholds.major.value) + "/" + str(d.thresholds.severe.value)),
        ("Proficiency", str(d.proficiency.value)),
      ),
      if d.spellcast-trait != none { core.stat-line(("Spellcast", d.spellcast-trait)) },
    )
    // The six traits side by side, name over modifier.
    block(above: 0.6em, below: 0.2em, grid(
      columns: (1fr,) * 6,
      align: center,
      row-gutter: 0.35em,
      ..trait.values().map(t => text(size: 0.85em, strong(t))),
      ..trait.keys().map(k => text(size: 1.2em, signed(d.traits.at(k).value))),
    ))

    track("HP", d.hp.value)
    track("Stress", d.stress.value)
    track("Hope", d.hope.max, shape: "circle", note: [start with #d.hope.start])
    track("Armor", d.armor-score.value)

    core.section("Experiences")
    d.experiences.map(e => [#e.name #signed(e.bonus.value)]).join[ · ]

    core.section("Equipment")
    for a in d.attacks {
      let w = a.weapon
      block(above: 0.5em, below: 0.3em)[*#w.name* --- #w.trait #signed(a.modifier) · #w.range · #a.damage #w.damage-type · #w.burden]
      for f in w.features { core.entry(f.name, f.body) }
    }
    if c.at("armor", default: none) != none {
      block(above: 0.5em, below: 0.3em)[*#c.armor.name* --- base thresholds #c.armor.thresholds.major/#c.armor.thresholds.severe · base score #c.armor.score]
      for f in c.armor.features { core.entry(f.name, f.body) }
    }

    core.section("Class: " + c.class.name)
    core.entry(c.class.hope-feature.name, tag: "Hope Feature", c.class.hope-feature.body)
    for f in c.class.features { core.entry(f.name, f.body) }
    core.section("Subclass: " + c.subclass.name)
    for (i, step) in ("foundation", "specialization", "mastery").enumerate() {
      if i < d.subclass-cards { for f in c.subclass.at(step) { core.entry(f.name, tag: upper(step.first()) + step.slice(1), f.body) } }
    }
    core.section("Heritage")
    for f in c.ancestry.features { core.entry(f.name, tag: c.ancestry.name, f.body) }
    for f in c.community.features { core.entry(f.name, tag: c.community.name, f.body) }

    core.section("Loadout")
    for k in d.loadout {
      block(above: 0.7em, below: 0.3em)[*#k.name* --- Level #k.level #k.domain #k.type · Recall Cost #k.recall-cost]
      if k.at("text", default: none) != none { k.text }
      for f in k.features { core.entry(f.name, f.body) }
    }
    if d.vault.len() > 0 {
      core.section("Vault")
      d.vault.map(k => k.name).join(", ")
    }

    if c.inventory.len() > 0 {
      core.section("Inventory")
      c.inventory.map(i => if type(i) == dictionary { i.name } else { i }).join(" · ")
    }
    for (title, body) in c.story {
      core.section(title.replace("-", " "))
      body
    }
  })
}

/// One line for inline mentions: Level 1 Wizard · Evasion 11 · HP 5.
#let character-summary(c) = {
  let d = derive(c)
  [Level #d.level #c.class.name · Evasion #d.evasion.value · HP #d.hp.value]
}
