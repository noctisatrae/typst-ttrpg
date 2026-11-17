// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Environments. Every field comes from the Daggerheart SRD 2.0,
// "Environment Stat Block" (p. 158); the stat blocks are on pp. 160-182.
// As with adversaries, nothing is derived: the p. 159 benchmarks are
// guidance for adapting an environment to another tier.

#import "@local/ttrpg-core:0.1.0" as core
#import core: field
#import "adversary.typ": feature-kind

/// Environment types, "the type of scene it most easily supports" (p. 158).
#let environment-type = (
  exploration: "Exploration",
  social: "Social",
  traversal: "Traversal",
  event: "Event",
)

/// The feature kinds environment stat blocks use: Passive, Action and
/// Reaction (the same words as adversary features; no Evolution).
#let environment-feature-kinds = (feature-kind.passive, feature-kind.action, feature-kind.reaction)

#let environment-schema = (
  // "The PC tier the environment is designed to challenge" (p. 158).
  tier: field(int, required: true, one-of: (1, 2, 3, 4)),
  type: field(str, required: true, one-of: environment-type.values()),
  // "An evocative one-line summary of the environment" (p. 158).
  description: field(str, content, required: true),
  // How the environment "pushes and pulls the people within" (p. 158),
  // kept verbatim as one line.
  impulses: field(str, content, required: true),
  // Usually a number; Events whose Difficulty depends on the adversaries
  // print text instead, e.g. "Special (see “Relative Strength”)" (p. 161).
  difficulty: field(int, str, required: true),
  // "Suggested adversaries" (p. 158), verbatim, e.g.
  // "Beasts (Bear, Dire Wolf, Glass Snake), Grove Guardians (...)".
  potential-adversaries: field(str, content, required: true),
  // Features and their feature questions, "prompts for plot hooks"
  // (p. 158). A feature's body may hold paragraphs and bullet lists.
  features: field(array, default: (), unique: "name",
    items: core.feature-schema + (
      kind: field(str, required: true, one-of: environment-feature-kinds),
      questions: field(str, content),
    )),
)

/// An environment. Every field is named; see `environment-schema`.
///
/// ```typ
/// #let grove = environment(
///   id: "abandoned-grove", name: "Abandoned Grove",
///   tier: 1, type: environment-type.exploration,
///   description: "...", impulses: "...", difficulty: 11,
///   potential-adversaries: "Beasts (Bear, Dire Wolf, Glass Snake)",
///   features: (
///     feature("Barbed Vines", kind: feature-kind.action,
///       questions: "How many vines are there?")[...],
///   ),
/// )
/// ```
#let environment(
  id: none, name: none, tags: none, features: none, flags: none,
  tier: none, type: none, description: none, impulses: none,
  difficulty: none, potential-adversaries: none,
  ..unknown,
) = core.entity("environment", environment-schema,
  id: id, name: name, tags: tags, features: features, flags: flags,
  tier: tier, type: type, description: description, impulses: impulses,
  difficulty: difficulty, potential-adversaries: potential-adversaries,
  ..unknown)

/// One line for inline mentions: Tier 1 Exploration · Difficulty 11.
#let environment-summary(e) = [Tier #e.tier #e.type · Difficulty #e.difficulty]

/// A feature's body followed by its questions in italics, as printed.
#let feature-text(f) = {
  f.body
  let q = f.at("questions", default: none)
  if q != none and q != "" {
    linebreak()
    emph(q)
  }
}

/// Renders an environment stat block and registers it in the document.
/// `register: false` renders without registering (e.g. a preview).
#let environment-block(e, register: true) = {
  if register { core.register(e) }
  core.statblock(
    title: e.name,
    subtitle: "Tier " + str(e.tier) + " " + e.type,
    description: e.description,
    header: (core.labeled("Impulses", e.impulses),),
    bands: ((
      core.stat-line(("Difficulty", if type(e.difficulty) == int { str(e.difficulty) } else { e.difficulty })),
      core.stat-line(("Potential Adversaries", e.potential-adversaries)),
    ),),
    sections: if e.features.len() > 0 {
      ((title: "Features", entries: e.features.map(f => core.entry(f.name, tag: f.kind, feature-text(f)))),)
    } else { () },
  )
}
