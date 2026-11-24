// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Transformations (SRD pp. 42-45): optional cards a GM grants in play or
// offers at character creation, each with a benefit and a drawback. They
// sit with the character's heritage and don't count toward the loadout. A
// PC can't have more than one (p. 42); `character` checks it and takes
// `transformation-limit:` for a table that allows more.
//
// Besides features and questions, a card may print things to fill in by
// pen: `tracks` (a row of boxes, e.g. the Vampire's 6 tokens) and
// `write-ins` (blank lines, e.g. a homebrew anchor).

#import "@local/ttrpg-core:0.1.0" as core
#import core: field
#import "player.typ": player-feature-schema

/// Features of a transformation: a player feature, plus `replaces:`, a note
/// naming the SRD rules it overrides for this character (homebrew).
#let transformation-feature-schema = player-feature-schema + (
  replaces: field(str, content),
)

/// A row of boxes printed on the card: `(name: "Hollowing", boxes: 3)`.
/// What filling it means belongs in the feature text.
#let track-schema = (
  name: field(str, required: true),
  boxes: field(int, required: true),
)

/// Blank lines printed on the card: `(label: "Anchor", lines: 2)`.
#let write-in-schema = (
  label: field(str, content, required: true),
  lines: field(int),
)

#let str-or-content(name) = (value, _) => {
  let bad = value.enumerate().filter(((i, q)) => type(q) not in (str, content))
  if bad.len() > 0 { "field `" + name + "` items must be strings or content, got " + bad.map(((i, q)) => "[" + str(i) + "] " + repr(q)).join(", ") }
}

#let transformation-schema = (
  description: field(str, content),
  features: field(array, required: true, items: transformation-feature-schema, unique: "name"),
  questions: field(array, default: (), check: str-or-content("questions")),
  tracks: field(array, default: (), items: track-schema, unique: "name"),
  write-ins: field(array, default: (), items: write-in-schema),
)

/// A transformation card.
///
/// ```typ
/// #let aware-undead = transformation(
///   id: "aware-undead", name: "Aware Undead",
///   features: (feature("Hollowing")[...], feature("Anchor")[...]),
///   tracks: ((name: "Hollowing", boxes: 3),),
///   write-ins: ((label: "Anchor", lines: 2),),
///   questions: ("How did the mist catch you?", ...),
/// )
/// ```
#let transformation(
  id: none, name: none, tags: none, flags: none,
  description: none, features: none, questions: none, tracks: none, write-ins: none,
  ..unknown,
) = core.entity("transformation", transformation-schema,
  id: id, name: name, tags: tags, flags: flags,
  description: description, features: features, questions: questions, tracks: tracks, write-ins: write-ins,
  ..unknown)

/// The parts of a card below its title, shared by the card and the
/// character sheet: features (with their `replaces` notes), tracks,
/// write-ins and, when `questions` is true, the questions.
#let transformation-body(t, questions: true, entry: core.entry, section: core.section) = {
  for f in t.features {
    entry(f.name, {
      f.body
      if f.at("replaces", default: none) != none {
        // Same paragraph, so it keeps the entry's hanging indent.
        linebreak()
        text(size: 0.9em, style: "italic")[Replaces: #f.replaces]
      }
    })
  }
  for tr in t.tracks {
    block(above: 0.8em, below: 0.8em)[*#tr.name:*~#core.boxes(tr.boxes)]
  }
  for w in t.write-ins { core.write-in(w.label, lines: w.at("lines", default: 1)) }
  if questions and t.questions.len() > 0 {
    section("Transformation questions")
    list(..t.questions)
  }
}

/// One line for inline mentions: "Transformation · Fangs, Feed".
#let transformation-summary(t) = [Transformation · #t.features.map(f => f.name).join(", ")]

/// The transformation card: name, description, features, tracks,
/// write-ins and questions. Registers the entity; `register: false`
/// renders without registering.
#let transformation-card(t, register: true) = {
  if register { core.register(t) }
  core.card({
    core.card-title(t.name)
    block(below: 0.8em, text(weight: "bold", style: "italic", size: 1.1em)[Transformation])
    if t.at("description", default: none) != none { block(below: 0.8em, emph(t.description)) }
    transformation-body(t)
  })
}
