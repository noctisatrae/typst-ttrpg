// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// ttrpg-script: campaign notes in screenplay format. Scenes, action lines,
// dialogue and open play, with characters taken from ttrpg-core entities.
// System-agnostic: a system package supplies the one-line summary and the
// stat block renderer.

#import "@local/ttrpg-core:0.1.0" as core

/// Package metadata, useful for checking which version a document resolved.
#let package-info = (
  name: "ttrpg-script",
  version: version(0, 1, 0),
  core: core.package-info.version,
)

/// Page geometry, measured from the left edge of the text area (which starts
/// 1.5in from the paper edge), loosely following Hollywood conventions.
#let indents = (
  dialogue: 1in,
  dialogue-width: 3.5in,
  paren: 1.6in,
  paren-width: 2in,
  cue: 2.2in,
)

/// Courier Prime for the screenplay itself; Geist Mono for stat blocks,
/// where it stays clearer at small sizes and has a Black weight for titles.
#let default-fonts = ("Courier Prime", "Geist Mono", "Courier New", "Courier")
#let default-stats-fonts = ("Geist Mono", "Courier Prime", "Courier New", "Courier")

/// The core theme used for stat blocks inside a script: all monospace,
/// outlined, no color, so blocks look like part of the page.
#let script-theme(font) = (
  fonts: (body: font, title: font, mono: font),
  sizes: (body: 9.5pt, title: 12pt, heading: 12pt, section: 9.5pt),
)

/// Script settings read by `intro`, `stats` and `cast`; set through `setup`.
#let config = state("ttrpg-script:config", (summary: none, stats: none))

/// The name of a character given as an entity or a plain string.
#let name-of(who, caller) = {
  if type(who) == str { return who }
  if type(who) != dictionary {
    panic(caller + ": expected an entity or a name string, got " + str(type(who)) + " " + repr(who))
  }
  if "name" not in who {
    panic(caller + ": entity " + repr(who.at("id", default: "(no id)")) + " has no field `name`")
  }
  who.name
}

/// Registers `who` if it is an entity; plain names are minor characters and
/// are not registered.
#let register-if-entity(who) = if type(who) == dictionary { core.register(who) }

/// The label of an entity's entry in the cast appendix.
#let cast-label(e) = label("ttrpg-script-cast:" + e.id)

/// The location of the scene in progress, so cues, exits and appearances
/// can be grouped by scene in the session sheet.
#let current-scene = state("ttrpg-script:scene", none)

/// Records something that happened in the current scene, for the session
/// sheet: `kind` is "appearance", "music" or "leads-to".
#let event(kind, data) = context [#metadata((kind: kind, scene: current-scene.get()) + data) <ttrpg-script-event>]

/// Document template for a script:
/// `#show: setup.with(summary: hw.summary, stats: hw.statblock)`.
///
/// - summary: function from an entity to short content shown by `intro`,
///   or none for names only.
/// - stats: function rendering an entity's full stat block, used by
///   `stats` and `cast`. System packages provide both.
/// - font: fallback list for the screenplay font.
/// - stats-font: fallback list for stat blocks (`stats`, `cast`).
#let setup(summary: none, stats: none, font: default-fonts, stats-font: default-stats-fonts, body) = {
  config.update(c => c + (summary: summary, stats: stats))
  core.use-theme(script-theme(stats-font))
  set page(
    paper: "us-letter",
    margin: (left: 1.5in, right: 1in, top: 1in, bottom: 1in),
    header: context {
      let n = counter(page).get().first()
      if n > 1 { align(right, str(n) + ".") }
    },
  )
  set text(font: font, size: 12pt)
  set par(leading: 0.55em, spacing: 1.1em, justify: false)
  body
}

/// A scene heading: `scene("INT.", "Ruined Chapel", "Night")` gives
/// INT. RUINED CHAPEL - NIGHT. The time is optional. `leads-to` links to
/// scenes by their location.
#let scene(int-ext, location, ..time) = {
  let time = time.pos().at(0, default: none)
  let heading = int-ext + " " + location + if time != none { " - " + time }
  current-scene.update(location)
  block(above: 2.2em, below: 1.1em, sticky: true, {
    [#metadata((location: location, heading: upper(heading))) <ttrpg-script-scene>]
    strong(upper(heading))
  })
}

/// Introduces a character inside an action line: the name in caps, then the
/// summary from `setup` and the page of its cast entry, if any. The name
/// links to the cast entry. Registers the entity.
#let intro(who) = {
  let name = upper(name-of(who, "intro"))
  register-if-entity(who)
  if type(who) != dictionary { return name }
  event("appearance", (id: who.id))
  context {
    let summary = config.get().summary
    let target = cast-label(who)
    let found = query(target)
    if found.len() > 0 { link(target, name) } else { name }
    let notes = ()
    if summary != none { notes.push(summary(who)) }
    if found.len() > 0 { notes.push[p.~#found.first().location().page()] }
    // A box keeps the notes on one line.
    if notes.len() > 0 [ #box[(#notes.join[ · ])]]
  }
}

/// A line of dialogue: `say(boss, paren: "too loud")[Who let them in?!]`.
/// Registers the entity. The cue, parenthetical and line stay together.
#let say(who, paren: none, line) = {
  let name = name-of(who, "say")
  register-if-entity(who)
  if type(who) == dictionary { event("appearance", (id: who.id)) }
  let parts = (pad(left: indents.cue, upper(name)),)
  if paren != none {
    parts.push(pad(left: indents.paren, block(width: indents.paren-width, emph("(" + paren + ")"))))
  }
  parts.push(pad(left: indents.dialogue, block(width: indents.dialogue-width, line)))
  block(breakable: false, above: 2em, below: 2em, stack(spacing: 0.55em, ..parts))
}

/// The full stat block of an entity, right here in the scene, rendered by
/// the `stats` function given to `setup`. Registers the entity.
#let stats(e) = context {
  let render = config.get().stats
  if render == none {
    panic("stats: no stat block renderer; pass one to setup, e.g. `setup.with(stats: hw.statblock)`")
  }
  block(above: 1.5em, below: 1.5em, render(e))
}

/// Marks where the script stops and the players take over. The body holds
/// optional notes: stakes, likely outcomes, exits.
/// `open-play[Fight or talk. The Boss flees at 2 HP.]`
#let open-play(body) = {
  let rule = box(width: 1fr, line(length: 100%, stroke: 0.8pt))
  block(above: 2em, below: 2em, breakable: false, {
    grid(
      columns: (1fr, auto, 1fr),
      column-gutter: 0.8em,
      align: horizon,
      rule, strong[▶ OPEN PLAY], rule,
    )
    // With notes, close them with a second rule; without, the marker
    // line alone says "the players take it from here".
    if body != [] and body != [ ] {
      block(above: 0.9em, below: 0.9em, pad(x: 1.5em, body))
      line(length: 100%, stroke: 0.8pt)
    }
  })
}

/// A transition, right aligned: `transition("Cut to:")`. Optional; at the
/// table `leads-to` usually says more.
#let transition(body) = block(width: 100%, above: 1.1em, below: 1.1em, align(right, upper(body)))

/// Links each scene name to its scene heading, or leaves it plain when no
/// scene has that location (an unwritten scene). Needs `context`.
#let scene-links(names) = {
  let known = query(<ttrpg-script-scene>)
  names.map(name => {
    let match = known.filter(m => m.value.location == name)
    if match.len() > 0 { link(match.first().location(), [→ #name]) } else { [→ #name] }
  }).join(", ")
}

/// Where a scene can lead, for non-linear play:
/// `leads-to("The Crypt", "Goblin Camp")`. Names matching a scene's location
/// link to it; others (unwritten scenes) stay plain text.
#let leads-to(..scenes) = {
  event("leads-to", (scenes: scenes.pos()))
  block(above: 1.5em, below: 1.1em, text(size: 0.85em, emph[Leads to: #context scene-links(scenes.pos())]))
}

/// A music cue. Most of the time a mood for background music:
/// `music[tense, low strings]`. For important moments, a precise track:
/// `music(track: "The End of the World", by: "Joe Hisaishi", url: "https://...")`.
/// `url` is semantic only: it makes the title a link in PDF or HTML output
/// and is never printed.
#let music(track: none, by: none, url: none, ..mood) = {
  let mood = mood.pos().at(0, default: none)
  if track == none and mood == none {
    panic("music: give a mood, e.g. `music[tense, low strings]`, or a `track:`")
  }
  event("music", (track: track, by: by, url: url, mood: mood))
  if track == none {
    block(above: 1.2em, below: 1.2em, text(size: 0.85em, emph[♪ Mood: #mood]))
  } else {
    let title = if url != none { link(url)[“#track”] } else [“#track”]
    block(above: 1.2em, below: 1.2em, breakable: false, {
      strong[♪ PLAY: #title#if by != none [ --- #by]]
      if mood != none { text(size: 0.85em, emph[ (#mood)]) }
    })
  }
}

/// One music cue as a short line for the session sheet.
#let cue-line(e) = if e.track != none {
  let title = if e.url != none { link(e.url)[“#e.track”] } else [“#e.track”]
  [♪ *PLAY: #title*#if e.by != none [ --- #e.by]]
} else [♪ _#e.mood;_]

/// A small bold header with indented items below it, for the session sheet.
#let sheet-group(header, items) = block(above: 0.7em, below: 0pt, {
  block(below: 0.4em, text(size: 0.85em, tracking: 0.05em, strong(upper(header))))
  pad(left: 1.5em, stack(spacing: 0.45em, ..items))
})

/// A one-page overview for the table: every scene with its page, the
/// characters in it (with summary and cast page), its music cues and where
/// it leads. Place it anywhere; it reads the whole document.
#let session-sheet(title: "Session Sheet") = {
  block(below: 0.6em, strong(upper(title)))
  line(length: 100%, stroke: 1.2pt)
  context {
    let summary = config.get().summary
    let entities = core.registered()
    let events = query(<ttrpg-script-event>).map(m => m.value)
    set text(size: 10pt)
    set par(spacing: 0.5em)
    for (i, s) in query(<ttrpg-script-scene>).enumerate() {
      let here = events.filter(e => e.scene == s.value.location)
      let ids = here.filter(e => e.kind == "appearance").map(e => e.id).dedup()
      let cast-lines = ids.map(id => {
          let e = entities.at(id)
          let notes = ()
          if summary != none { notes.push(summary(e)) }
          let cast = query(cast-label(e))
          if cast.len() > 0 { notes.push[p.~#cast.first().location().page()] }
          let name = if cast.len() > 0 { link(cast-label(e), e.name) } else { e.name }
          [#name#if notes.len() > 0 [ (#notes.join[ · ])]]
        })
      let music-lines = here.filter(e => e.kind == "music").map(cue-line)
      let exits = here.filter(e => e.kind == "leads-to").map(e => e.scenes).flatten().dedup()
      block(above: 1.6em, below: 0pt, breakable: false, grid(
        columns: (2em, 1fr, auto),
        row-gutter: 0.8em,
        strong(str(i + 1)), link(s.location(), strong(s.value.heading)), [p.~#s.location().page()],
        [], {
          if cast-lines.len() > 0 { sheet-group("Cast", cast-lines) }
          if music-lines.len() > 0 { sheet-group("Music", music-lines) }
          if exits.len() > 0 { sheet-group("Leads to", (scene-links(exits),)) }
        }, [],
      ))
    }
  }
}

/// The default cast entry without a stat block renderer: name in caps with
/// its kind and id.
#let default-cast-entry(e) = block(below: 0.8em)[*#upper(e.name)* --- #e.kind (#raw(e.id))]

/// The cast appendix: a new page, a separator and every registered entity
/// in order of first appearance, each with the full stat block from
/// `setup(stats:)` (or `render`, or a compact entry). `intro` links here.
#let cast(title: "Cast", render: auto) = {
  pagebreak(weak: true)
  line(length: 100%, stroke: 1.2pt)
  block(above: 1em, below: 1.5em, strong(upper(title)))
  context {
    let render = if render != auto { render } else if config.get().stats != none { config.get().stats } else { default-cast-entry }
    let entities = core.registered().values()
    if entities.len() == 0 { emph[No characters registered.] }
    for e in entities {
      [#metadata(e.id) #cast-label(e)]
      render(e)
    }
  }
}
