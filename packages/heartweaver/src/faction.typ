// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Factions (SRD p. 190, Supplemental Campaign Mechanics). A Faction Card
// holds a name, relationships with other factions (-3 to +3), 1-3 assets,
// 1-3 problems, 1-3 major and 1-3 minor objectives. An objective being
// pursued carries an Objective Countdown, printed as boxes to tick: 10 for
// a major objective, 4-6 for a minor one, and at most one major and two
// minor countdowns active at a time.
//
// Ticking a countdown is play state: the card prints empty boxes and
// stores nothing.

#import "@local/ttrpg-core:0.1.0" as core
#import core: field
#import "adversary.typ": signed

/// The name of a relationship rank, -3 to +3 (p. 190):
/// `relationship-name(-2) == "Opposed"`.
#let relationship-name(rank) = (
  "Nemeses", "Opposed", "Unfriendly", "Neutral", "Friendly", "Allied", "Close Allies",
).at(rank + 3)

// "1-3 advantages", "1-3 goals" (p. 190). Lists may be empty while a
// faction is being drafted; more than three is an error.
#let at-most-three(name) = (value, _) => {
  let problems = ()
  if value.len() > 3 { problems.push("field `" + name + "` has " + str(value.len()) + " entries; a Faction Card holds 1-3 (p. 190)") }
  let bad = value.enumerate().filter(((i, x)) => type(x) not in (str, content))
  if bad.len() > 0 { problems.push("field `" + name + "` items must be text, got " + bad.map(((i, x)) => "[" + str(i) + "] " + repr(x)).join(", ")) }
  if problems.len() > 0 { problems.join("; ") }
}

// Objectives are text, or `(goal: ..., countdown: n)` when a countdown is
// running. Major countdowns are 10, minor ones 4-6, and a faction runs at
// most one major and two minor at a time (p. 190).
#let objectives-check(name, sizes, active) = (value, _) => {
  let problems = ()
  if value.len() > 3 { problems.push("field `" + name + "` has " + str(value.len()) + " entries; a Faction Card holds 1-3 (p. 190)") }
  let running = 0
  for (i, o) in value.enumerate() {
    let at = "`" + name + "[" + str(i) + "]`"
    if type(o) in (str, content) { continue }
    if type(o) != dictionary { problems.push(at + " must be text or (goal:, countdown:), got " + repr(o)); continue }
    let extra = o.keys().filter(k => k not in ("goal", "countdown"))
    if extra.len() > 0 { problems.push(at + ": unknown key " + extra.map(k => "`" + k + "`").join(", ") + "; allowed: `goal`, `countdown`") }
    if type(o.at("goal", default: none)) not in (str, content) { problems.push(at + ": `goal` (text) is required") }
    let n = o.at("countdown", default: none)
    if n != none {
      running += 1
      if type(n) != int or n not in sizes { problems.push(at + ": countdown must be " + sizes.map(str).join(" or ") + " (p. 190), got " + repr(n)) }
    }
  }
  if running > active { problems.push("field `" + name + "` has " + str(running) + " countdowns running; at most " + str(active) + " at a time (p. 190)") }
  if problems.len() > 0 { problems.join("; ") }
}

#let relationships-check(value, _) = {
  let problems = ()
  for (i, r) in value.enumerate() {
    let at = "`relationships[" + str(i) + "]`"
    if type(r) != dictionary { problems.push(at + " must be (with:, rank:), got " + repr(r)); continue }
    let extra = r.keys().filter(k => k not in ("with", "rank"))
    if extra.len() > 0 { problems.push(at + ": unknown key " + extra.map(k => "`" + k + "`").join(", ") + "; allowed: `with`, `rank`") }
    let w = r.at("with", default: none)
    if not (type(w) in (str, content) or (type(w) == dictionary and w.at("kind", default: none) == "faction")) {
      problems.push(at + ": `with` must be a faction or its name, got " + repr(w))
    }
    let n = r.at("rank", default: none)
    if type(n) != int or n < -3 or n > 3 { problems.push(at + ": `rank` must be a number from -3 to 3 (p. 190), got " + repr(n)) }
  }
  if problems.len() > 0 { problems.join("; ") }
}

#let faction-schema = (
  description: field(str, content),
  relationships: field(array, default: (), check: relationships-check),
  assets: field(array, default: (), check: at-most-three("assets")),
  problems: field(array, default: (), check: at-most-three("problems")),
  major-objectives: field(array, default: (), check: objectives-check("major-objectives", (10,), 1)),
  minor-objectives: field(array, default: (), check: objectives-check("minor-objectives", (4, 5, 6), 2)),
)

/// A Faction Card.
///
/// ```typ
/// #let guild = faction(id: "lantern-guild", name: "Lantern Guild",
///   relationships: ((with: crown, rank: -2),),
///   assets: ("Every lamplighter in the city",),
///   problems: ("Broke since the fire",),
///   major-objectives: ((goal: "Win the street-lighting charter", countdown: 10),),
///   minor-objectives: ("Hold the midwinter festival",))
/// ```
#let faction(
  id: none, name: none, tags: none, flags: none,
  description: none, relationships: none, assets: none, problems: none,
  major-objectives: none, minor-objectives: none,
  ..unknown,
) = core.entity("faction", faction-schema,
  id: id, name: name, tags: tags, flags: flags,
  description: description, relationships: relationships, assets: assets, problems: problems,
  major-objectives: major-objectives, minor-objectives: minor-objectives,
  ..unknown)

// "−2", "+1", and "0" for Neutral as printed (p. 190).
#let rank-text(n) = if n == 0 { "0" } else { signed(n) }

#let other-name(r) = if type(r.with) == dictionary { r.with.name } else { r.with }

/// "Iron Crown −2 (Opposed)".
#let relationship-text(r) = [#other-name(r) #rank-text(r.rank) (#relationship-name(r.rank))]

/// One line for inline mentions: "Faction · Iron Crown −2, Guild +1".
#let faction-summary(f) = [Faction#if f.relationships.len() > 0 [ · #f.relationships.map(r => [#other-name(r) #rank-text(r.rank)]).join(", ")]]

#let objective(o) = if type(o) == dictionary {
  o.goal
  if o.at("countdown", default: none) != none [ \ Countdown (#o.countdown):~#core.boxes(o.countdown)]
} else { o }

/// The Faction Card: name, description, relationships, assets, problems,
/// objectives with their countdowns. Registers the entity; `register:
/// false` renders without registering.
#let faction-card(f, register: true) = {
  if register { core.register(f) }
  core.card({
    core.card-title(f.name)
    block(below: 0.8em, text(weight: "bold", style: "italic", size: 1.1em)[Faction])
    if f.at("description", default: none) != none { block(below: 0.8em, emph(f.description)) }
    if f.relationships.len() > 0 { core.entry("Relationships", f.relationships.map(relationship-text).join(" · ")) }
    for (title, items) in (
      ("Assets", f.assets),
      ("Problems", f.problems),
      ("Major objectives", f.major-objectives.map(objective)),
      ("Minor objectives", f.minor-objectives.map(objective)),
    ) {
      if items.len() > 0 {
        core.section(title)
        list(..items)
      }
    }
  })
}
