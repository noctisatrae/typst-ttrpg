// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Player characters. A character stores CHOICES and LEVEL HISTORY only;
// every number on the sheet is derived by `derive`, a fold over the
// history that records where each value comes from ("+1 Evasion, level 4").
// This is a book engine: play state (marked HP, Stress, Hope, gold) is never
// stored; the sheet prints empty boxes for it.
//
// Rules: character creation (SRD pp. 4-6), leveling up and multiclassing
// (pp. 53-54), equipment (p. 55), armor (p. 72), loadout & vault, Hope
// maximum of 6, starting Stress of 6.

#import "@local/ttrpg-core:0.1.0" as core
#import core: field
#import "player.typ": trait
#import "companion.typ": check-companion, trainings
#import "beastform.typ": beastform-numbers

/// Traits as keys (`agility`) and as printed (`Agility`).
#let trait-keys = trait.keys()
#let trait-key(printed) = lower(printed)

// ---------------------------------------------------------------------
// Level-up advancements (p. 54). Each takes one advancement slot, except
// Proficiency and multiclassing, which take both.

/// +1 to two unmarked traits; they stay marked until the next tier.
#let increase-traits(a, b) = (advancement: "traits", traits: (a, b), slots: 1)
/// One more Hit Point slot.
#let add-hit-point() = (advancement: "hp", slots: 1)
/// One more Stress slot.
#let add-stress() = (advancement: "stress", slots: 1)
/// +1 to two Experiences, by name.
#let increase-experiences(a, b) = (advancement: "experiences", experiences: (a, b), slots: 1)
/// A card with choices ("Vitality", p. 208) is written as a pair:
/// `(cards.vitality, ("hp", "stress"))`; the choices are kept on the card.
#let with-choices(k) = if type(k) == array and k.len() == 2 and type(k.at(0)) == dictionary and type(k.at(1)) == array {
  k.at(0) + (chosen: k.at(1))
} else { k }

/// An additional domain card.
#let extra-card(card) = (advancement: "card", card: with-choices(card), slots: 1)
/// +1 Evasion.
#let increase-evasion() = (advancement: "evasion", slots: 1)
/// The next subclass card: specialization, then mastery. Once you have
/// multiclassed you have two subclasses: name the one you upgrade,
/// `upgrade-subclass(subclasses.warden-of-renewal)`.
#let upgrade-subclass(..which) = {
  let p = which.pos()
  if p.len() > 1 or which.named().len() > 0 { panic("upgrade-subclass takes at most one subclass, e.g. upgrade-subclass(subclasses.moon)") }
  (advancement: "subclass", subclass: p.at(0, default: none), slots: 1)
}
/// +1 Proficiency (takes both slots).
#let increase-proficiency() = (advancement: "proficiency", slots: 2)
/// Multiclass (takes both slots, level 5+, once, p. 54): another class, one
/// of its domains, the foundation card of one of its subclasses, and its
/// class features: `multiclass(classes.druid, "Sage",
/// subclasses.warden-of-renewal)`.
///
/// ALL of the class's features, not one: the SRD says "its class feature"
/// (p. 54), but Darrington Press's official multiclass sheets (Additional
/// Sheets, 2026-08-25) are headed "Multiclass Features" and print every
/// feature of the class (Warlock: Patron's Pact and Favor; Witch: Hex and
/// Commune). Never the class's Hope feature.
#let multiclass(class, domain, subclass) = (advancement: "multiclass", class: class, domain: domain, subclass: subclass, slots: 2)

/// One level-up (p. 53): a new Experience at levels 2, 5 and 8 (tier
/// achievements), two advancements, and the new domain card (step four).
/// `level(2, experience: "Survivalist", card: cards.x, advancements: (...))`
/// When a feature grants cards at this level ("Accomplished"), `card:`
/// takes a list. With a companion: its training marks (`companion:`, see
/// `train`) and, at levels 2, 5 and 8, its new Experience.
/// With martial stances ("Stance Fighter"): the stance learned (`stance:`,
/// a list when more are due).
#let level(n, experience: none, card: none, advancements: (), companion: (), companion-experience: none, stance: none) = (
  level: n, experience: experience,
  stances: if stance == none { () } else if type(stance) == dictionary { (stance,) } else { stance },
  cards: if card == none { () } else if type(card) == dictionary or with-choices(card) != card { (with-choices(card),) } else { card.map(with-choices) },
  advancements: advancements, companion: companion, companion-experience: companion-experience,
)

#let character-schema = (
  pronouns: field(str),
  class: field(dictionary, required: true),
  subclass: field(dictionary, required: true),
  ancestry: field(dictionary, required: true),
  community: field(dictionary, required: true),
  traits: field(dictionary, required: true, keys: trait-keys.map(k => (k, field(int, required: true))).to-dict()),
  experiences: field(array, required: true, items: str),
  weapons: field(array, default: (), items: dictionary),
  armor: field(dictionary),
  cards: field(array, required: true, items: dictionary),
  companion: field(dictionary),
  // Transformations (p. 42), always a list here; `character` takes one
  // entity or a list. A PC can't have more than `transformation-limit`.
  transformation: field(array, default: (), items: dictionary),
  transformation-limit: field(int, default: 1),
  // Beastform options (p. 15) in place of those a Beastform feature grants
  // (daggerheart-srd's Druid: the SRD's forms), e.g. to add homebrew forms:
  // `beastforms: beastforms.values() + (my-form,)`. A dictionary is taken
  // as its values.
  beastforms: field(array, items: dictionary),
  // Martial stances known from the start (Martial Artist, p. 12); later
  // ones come with `level(n, stance: ...)`.
  stances: field(array, default: (), items: dictionary),
  vault: field(array, default: (), items: dictionary),
  inventory: field(array, default: ()),
  story: field(dictionary, default: (:)),
  levels: field(array, default: (), items: dictionary),
)

#let tier-of(level) = if level == 1 { 1 } else if level <= 4 { 2 } else if level <= 7 { 3 } else { 4 }

/// The character's multiclass advancement with the level it was taken at,
/// or none.
#let multiclass-of(c) = {
  for (i, l) in c.levels.enumerate() {
    for a in l.advancements.filter(a => a.advancement == "multiclass") { return a + (level: i + 2) }
  }
  none
}

/// How many times subclass `sub` was upgraded; an upgrade naming no
/// subclass is the main one's.
#let subclass-upgrades(c, sub) = c.levels.map(l => l.advancements).flatten().filter(a => a.advancement == "subclass" and a.at("subclass", default: none) == none and sub.id == c.subclass.id or a.advancement == "subclass" and a.at("subclass", default: none) != none and a.subclass.at("id", default: none) == sub.id).len()

/// The class features a multiclass gives: all of them, as on the official
/// multiclass sheets (see `multiclass`).
#let multiclass-features(mc) = mc.class.features

// ---------------------------------------------------------------------
// Tracked numbers: a value with the parts that add up to it.

#let stat(label, value) = (value: value, parts: ((label, value),))
#let bump(s, label, delta) = (value: s.value + delta, parts: s.parts + ((label, delta),))

/// Every feature in effect, with where it comes from: class, subclass cards
/// taken so far, heritage, equipped weapons and armor, loadout cards.
#let active-features(c, subclass-cards, mc: none, mc-cards: 0) = {
  let out = ()
  out.push((c.class.name + " (Hope)", c.class.hope-feature))
  for f in c.class.features { out.push((c.class.name, f)) }
  for (i, step) in ("foundation", "specialization", "mastery").enumerate() {
    if i < subclass-cards { for f in c.subclass.at(step) { out.push((c.subclass.name, f)) } }
  }
  // Multiclass (p. 54): the class feature, not its Hope feature, and the
  // other subclass's cards.
  if mc != none {
    for f in multiclass-features(mc) { out.push((mc.class.name, f)) }
    for (i, step) in ("foundation", "specialization", "mastery").enumerate() {
      if i < mc-cards { for f in mc.subclass.at(step) { out.push((mc.subclass.name, f)) } }
    }
  }
  for f in c.ancestry.features { out.push((c.ancestry.name, f)) }
  for f in c.community.features { out.push((c.community.name, f)) }
  for t in c.transformation { for f in t.features { out.push((t.name, f)) } }
  for w in c.weapons { for f in w.features { out.push((w.name, f)) } }
  if c.at("armor", default: none) != none { for f in c.armor.features { out.push((c.armor.name, f)) } }
  // Cards whose choices are permanent ("Vitality") count from the vault too.
  for card in c.loadout + c.vault.filter(k => k.at("permanent-vault", default: false)) {
    if "choices" in card {
      let mods = (:)
      for o in card.at("chosen", default: ()) {
        for (key, v) in card.choices.options.at(o, default: (:)) { mods.insert(key, mods.at(key, default: 0) + v) }
      }
      out.push((card.name, (name: card.name, body: card.at("text", default: []), modifiers: mods)))
      continue
    }
    for f in card.features { out.push((card.name, f)) }
    // A card with plain text may carry its effects on the card itself.
    if "modifiers" in card or "grants" in card {
      out.push((card.name, (name: card.name, body: card.at("text", default: []))
        + if "modifiers" in card { (modifiers: card.modifiers) } else { (:) }
        + if "grants" in card { (grants: card.grants) } else { (:) }))
    }
  }
  out
}

/// Everything the sheet shows, computed from the character's choices.
/// Numbers are `(value:, parts:)`; `parts` lists (source, amount) pairs.
#let derive(c) = {
  let lvl = 1 + c.levels.len()
  let tier = tier-of(lvl)
  let ups = c.levels.map(l => l.advancements).flatten()
  let count(name) = ups.filter(a => a.advancement == name).len()
  let mc = multiclass-of(c)
  let subclass-cards = 1 + subclass-upgrades(c, c.subclass)
  let mc-cards = if mc == none { 0 } else { 1 + subclass-upgrades(c, mc.subclass) }

  let acquired = c.cards + c.levels.map(l => l.cards).flatten() + ups.filter(a => a.advancement == "card").map(a => a.card)
  let vault-ids = c.vault.map(v => v.id) + acquired.filter(k => k.at("permanent-vault", default: false)).map(k => k.id)
  let loadout = acquired.filter(k => k.id not in vault-ids)
  let vault = acquired.filter(k => k.id in vault-ids)
  let features = active-features(c + (loadout: loadout, vault: vault), subclass-cards, mc: mc, mc-cards: mc-cards)
  // Modifiers for `key` from every active feature, except those of the
  // sources named in `except` (a weapon's attack bonus is its own).
  let mods(key, except: ()) = features.filter(((src, f)) => key in f.at("modifiers", default: (:)) and src not in except).map(((src, f)) => (src + ": " + f.name, f.modifiers.at(key)))

  // What effects may depend on before traits exist: "-Touched" cards count
  // the loadout's domains (pp. 207-223).
  let armor = c.at("armor", default: none)
  let loadout-domains = (:)
  for k in loadout { loadout-domains.insert(k.domain, loadout-domains.at(k.domain, default: 0) + 1) }
  let early = (level: lvl, tier: tier, loadout-domains: loadout-domains, armored: armor != none)

  // Traits first: other modifiers may depend on them.
  let traits = (:)
  for k in trait-keys {
    let s = stat("chosen", c.traits.at(k))
    for (i, l) in c.levels.enumerate() {
      for a in l.advancements.filter(a => a.advancement == "traits") {
        if a.traits.map(trait-key).contains(k) { s = bump(s, "level " + str(i + 2), 1) }
      }
    }
    for (label, m) in mods(k) { s = bump(s, label, if type(m) == function { m(early) } else { m }) }
    traits.insert(k, s)
  }
  // "If your foundation cards specify different Spellcast traits, you can
  // choose which one to apply when making a Spellcast roll" (p. 54): the
  // sheet counts the higher one (the main subclass's on a tie).
  let spellcasts = (c.subclass,) + if mc != none { (mc.subclass,) } else { () }
  let spellcasts = spellcasts.map(s => s.at("spellcast-trait", default: none)).filter(x => x != none).dedup()
  let spellcast = spellcasts.sorted(key: t => -traits.at(trait-key(t)).value).at(0, default: none)
  let by-level(s, name) = {
    for (i, l) in c.levels.enumerate() {
      for a in l.advancements.filter(a => a.advancement == name) { s = bump(s, "level " + str(i + 2), 1) }
    }
    s
  }
  // Proficiency before the context, so effects can depend on it (Galapa
  // "Shell": thresholds + Proficiency); its own modifiers are numbers.
  let proficiency = stat("level 1", 1)
  for n in (2, 5, 8) { if lvl >= n { proficiency = bump(proficiency, "tier achievement, level " + str(n), 1) } }
  proficiency = by-level(proficiency, "proficiency")
  for (label, m) in mods("proficiency") { proficiency = bump(proficiency, label, m) }
  let ctx = early + (traits: traits.pairs().map(((k, s)) => (k, s.value)).to-dict(), spellcast-trait: spellcast, proficiency: proficiency.value)
  let apply(s, key) = {
    for (label, m) in mods(key) { s = bump(s, label, if type(m) == function { m(ctx) } else { m }) }
    s
  }

  let evasion = apply(by-level(stat(c.class.name, c.class.evasion), "evasion"), "evasion")
  let hp = apply(by-level(stat(c.class.name, c.class.hp), "hp"), "hp")
  let stress = apply(by-level(stat("start", 6), "stress"), "stress")

  // Thresholds: armor's base + level; unarmored, level and twice level,
  // unless a feature gives an unarmored base (`base-armor`, "Bare Bones",
  // p. 222), which then counts like armor.
  let base-armor = if armor != none { none } else {
    mods("base-armor").map(((label, m)) => (label: label, ..m(ctx))).at(0, default: none)
  }
  let (major, severe, armor-score) = if armor != none {
    (stat(armor.name, armor.thresholds.major), stat(armor.name, armor.thresholds.severe), stat(armor.name, armor.score))
  } else if base-armor != none {
    (stat(base-armor.label, base-armor.major), stat(base-armor.label, base-armor.severe), stat(base-armor.label, base-armor.score))
  } else { (stat("unarmored", 0), stat("unarmored", lvl), stat("unarmored", 0)) }
  major = apply(apply(bump(major, "level", lvl), "thresholds"), "major")
  severe = apply(apply(bump(severe, "level", lvl), "thresholds"), "severe")
  armor-score = apply(armor-score, "armor-score")
  armor-score = (value: calc.min(armor-score.value, 12), parts: armor-score.parts)

  // Experiences: +2 each; +1 per "increase experiences" naming them.
  let names = c.experiences + c.levels.map(l => l.experience).filter(x => x != none)
  let experiences = names.map(n => {
    let s = stat("start", 2)
    for (i, l) in c.levels.enumerate() {
      for a in l.advancements.filter(a => a.advancement == "experiences") {
        if n in a.experiences { s = bump(s, "level " + str(i + 2), 1) }
      }
    }
    (name: n, bonus: s)
  })

  // Attack bonuses: a weapon's own features ("Reliable: +1 to attack
  // rolls") count for that weapon only; other sources for every attack;
  // `primary-attack` ("Trusty", p. 68) for primary weapon attacks.
  let value(m) = if type(m) == function { m(ctx) } else { m }
  let weapon-names = c.weapons.map(w => w.name)
  let attack-bonus = mods("attack", except: weapon-names).map(((_, m)) => value(m)).sum(default: 0)
  let primary-bonus = mods("primary-attack").map(((_, m)) => value(m)).sum(default: 0)
  let attacks = c.weapons.map(w => {
    let own = w.features.map(f => f.at("modifiers", default: (:)).at("attack", default: 0)).map(value).sum(default: 0)
    (
      weapon: w,
      // "Spellcast" weapons use the Spellcast trait (p. 71).
      // Without a Spellcast trait it counts as 0; `character` reports it.
      modifier: (if w.trait != "Spellcast" { traits.at(trait-key(w.trait)).value } else if spellcast != none { traits.at(trait-key(spellcast)).value } else { 0 })
        + attack-bonus + own + if w.category == "Primary" { primary-bonus } else { 0 },
      damage: str(proficiency.value) + w.damage,
    )
  })

  let grants = ("domain-cards", "companion", "companion-training").map(k => (k, features.map(((_, f)) => f.at("grants", default: (:)).at(k, default: 0)).sum(default: 0))).to-dict()
  // Beastform options: the character's own list, else those its features grant.
  let beast-grants = features.filter(((_, f)) => "beastforms" in f.at("grants", default: (:)))
  let forms = c.at("beastforms", default: beast-grants.map(((_, f)) => f.grants.beastforms).flatten())
  let partial = (traits: traits, evasion: evasion, proficiency: proficiency, attack-bonus: attack-bonus)

  (
    level: lvl,
    tier: tier,
    traits: traits,
    spellcast-trait: spellcast,
    // Every Spellcast trait the character can choose from (multiclass).
    spellcast-traits: spellcasts,
    // Bonus to Spellcast Rolls on top of the trait ("Channeling", p. 74).
    spellcast-bonus: apply((value: 0, parts: ()), "spellcast"),
    proficiency: proficiency,
    evasion: evasion,
    hp: hp,
    stress: stress,
    // Hope max 6 (p. 5); a companion's "Light in the Dark" adds a slot.
    hope: (start: 2, max: 6 + trainings(c).filter(t => t.training == "light-in-the-dark").len()),
    thresholds: (major: major, severe: severe),
    armor-score: armor-score,
    experiences: experiences,
    attacks: attacks,
    loadout: loadout,
    vault: vault,
    features: features,
    subclass-cards: subclass-cards,
    // The multiclass advancement (class, domain, subclass, level)
    // with its subclass cards taken and the class features it gives.
    multiclass: if mc == none { none } else { mc + (subclass-cards: mc-cards, features: multiclass-features(mc)) },
    grants: grants,
    // Attack bonus from every source but weapons (weapons can't be used in
    // Beastform, p. 14).
    attack-bonus: attack-bonus,
    // The forms of the character's tier or lower (p. 14), with their numbers.
    // Martial stances: the rules from the granting feature, and the stances
    // known with the level each was learned.
    stance-rules: features.map(((_, f)) => f.at("grants", default: (:)).at("stances", default: none)).filter(x => x != none).at(0, default: none),
    stances: c.stances.map(s => (stance: s, level: 1)) + c.levels.enumerate().map(((i, l)) => l.at("stances", default: ()).map(s => (stance: s, level: i + 2))).flatten(),
    beastforms: if beast-grants.len() > 0 { forms.filter(b => b.tier <= tier).map(b => beastform-numbers(b, partial)) } else { () },
  )
}

// ---------------------------------------------------------------------
// What is due by a level, from the history up to it.

/// Domain cards a character must have taken by level `n` (pp. 6, 54): two
/// at creation, one per level-up, one per "extra card" advancement, plus
/// what features grant by then ("Prepared", "Accomplished"). Returns
/// `(total:, why:)`.
#let cards-due(c, n) = {
  let ls = c.levels.slice(0, n - 1)
  let d = derive(c + (levels: ls))
  let extra = ls.map(l => l.advancements.filter(a => a.advancement == "card")).flatten().len()
  let granted = d.features.filter(((_, f)) => f.at("grants", default: (:)).at("domain-cards", default: 0) > 0).map(((_, f)) => f.name)
  (
    total: 2 + (n - 1) + extra + d.grants.domain-cards,
    why: ("2 at creation",) + if n > 1 { ("1 per level-up",) } + if extra > 0 { (str(extra) + " extra card",) } + granted.map(g => "+ " + g),
  )
}

/// The level at which a feature granting `key` (`"companion"`, `"stances"`)
/// is first in effect: 1 from the class, later through multiclassing; none
/// if never.
#let gained-at(c, key) = {
  for n in range(1, c.levels.len() + 2) {
    let d = derive(c + (levels: c.levels.slice(0, n - 1)))
    if d.features.any(((_, f)) => key in f.at("grants", default: (:))) { return n }
  }
  none
}

/// Companion training marks due by level `n` (p. 22): one per level-up
/// since the companion came (level 1, or the multiclass level), plus
/// "Expert Training" (+1) and "Advanced Training" (+2) once taken.
#let training-due(c, n) = {
  let from = gained-at(c, "companion")
  if from == none or n <= from { return 0 }
  (n - from) + derive(c + (levels: c.levels.slice(0, n - 1))).grants.companion-training
}

// ---------------------------------------------------------------------
// Rules. Each returns error messages; `character` reports them all at once.

#let check-rules(c) = {
  let errors = ()
  let expect-kind(field, kind) = {
    let v = c.at(field)
    if v.at("kind", default: none) != kind {
      errors.push("`" + field + "` must be a " + kind + " entity (e.g. from daggerheart-srd), got " + repr(v.at("kind", default: v)))
    }
  }
  expect-kind("class", "class")
  expect-kind("subclass", "subclass")
  expect-kind("ancestry", "ancestry")
  expect-kind("community", "community")
  for t in c.transformation {
    if t.at("kind", default: none) != "transformation" {
      errors.push("`transformation` must be a transformation entity (e.g. from daggerheart-srd), got " + repr(t.at("kind", default: t)))
    }
  }
  if errors.len() > 0 { return errors }
  // p. 42: "A PC can't have more than one transformation."
  if c.transformation.len() > c.transformation-limit {
    errors.push("`transformation`: a PC can't have more than " + if c.transformation-limit == 1 { "one transformation (p. 42)" } else { str(c.transformation-limit) + " transformations (`transformation-limit`)" } + ", got " + str(c.transformation.len()) + " (" + c.transformation.map(t => t.name).join(", ") + "); for a house rule that allows more, set `transformation-limit: " + str(c.transformation.len()) + "`")
  }
  let tids = c.transformation.map(t => t.id)
  if tids.dedup().len() != tids.len() { errors.push("`transformation`: the same transformation is given twice") }

  if c.subclass.class != c.class.id {
    errors.push("subclass " + repr(c.subclass.name) + " belongs to " + repr(c.subclass.class) + ", not " + repr(c.class.id))
  }
  // p. 4: assign +2, +1, +1, +0, +0, -1.
  let spread = c.traits.values().sorted()
  if spread != (-1, 0, 0, 1, 1, 2) {
    errors.push("`traits` must use +2, +1, +1, +0, +0, −1 once each (p. 4), got " + c.traits.pairs().map(((k, v)) => k + " " + str(v)).join(", "))
  }
  // p. 5: two Experiences at creation.
  if c.experiences.len() != 2 {
    errors.push("`experiences` needs exactly 2 at creation (p. 5), got " + str(c.experiences.len()))
  }

  // Levels: 2, 3, ... in order; tier achievements need an Experience.
  for (i, l) in c.levels.enumerate() {
    let n = i + 2
    let at = "level " + str(n)
    if l.level != n { errors.push("`levels` must go 2, 3, 4, ... in order; entry " + str(i + 1) + " is level " + str(l.level)); continue }
    if n in (2, 5, 8) and l.experience == none { errors.push(at + ": tier achievement, needs a new `experience:` (p. 53)") }
    if n not in (2, 5, 8) and l.experience != none { errors.push(at + ": new Experiences come only at levels 2, 5 and 8 (p. 53)") }
    let slots = l.advancements.map(a => a.slots).sum(default: 0)
    if slots != 2 { errors.push(at + ": choose advancements worth exactly 2 slots (Proficiency and multiclass take both), got " + str(slots) + " (p. 54)") }
    for a in l.advancements.filter(a => a.advancement == "multiclass") {
      if n < 5 { errors.push(at + ": multiclassing starts at level 5 (p. 54)") }
    }
  }
  // Marked traits (p. 54): a trait raised in a tier can't be raised again
  // until marks clear at levels 5 and 8.
  let marked = ()
  for (i, l) in c.levels.enumerate() {
    let n = i + 2
    if n in (5, 8) { marked = () }
    for a in l.advancements.filter(a => a.advancement == "traits") {
      for t in a.traits {
        let k = trait-key(t)
        if k not in trait-keys { errors.push("level " + str(n) + ": unknown trait " + repr(t) + "; traits are " + trait-keys.join(", ")) }
        else if k in marked { errors.push("level " + str(n) + ": " + k + " is still marked from earlier in this tier (p. 54)") }
        else { marked.push(k) }
      }
    }
  }
  // Multiclassing (pp. 53-54): once; another class, one of its domains,
  // one of its subclasses (its class features come whole, see `multiclass`).
  let mcs = c.levels.map(l => l.advancements).flatten().filter(a => a.advancement == "multiclass")
  if mcs.len() > 1 { errors.push("multiclass only once: taking it crosses out every other multiclass option (p. 53), got " + str(mcs.len())) }
  let mc = multiclass-of(c)
  if mc != none {
    let at = "level " + str(mc.level) + ": multiclass"
    if mc.class.at("kind", default: none) != "class" { errors.push(at + ": the class must be a class entity (e.g. classes.druid), got " + repr(mc.class)); return errors }
    if mc.subclass.at("kind", default: none) != "subclass" { errors.push(at + ": the subclass must be a subclass entity (e.g. subclasses.moon), got " + repr(mc.subclass)); return errors }
    if mc.class.id == c.class.id { errors.push(at + ": choose an additional class (p. 54), not your own (" + c.class.name + ")") }
    if mc.subclass.class != mc.class.id { errors.push(at + ": subclass " + mc.subclass.name + " belongs to " + repr(mc.subclass.class) + ", not " + repr(mc.class.id)) }
    if mc.domain not in mc.class.domains { errors.push(at + ": domain must be one of " + mc.class.name + "'s, " + mc.class.domains.map(repr).join(" or ") + " (p. 54), got " + repr(mc.domain)) }
  }
  // Upgraded subclass cards (p. 53): taking one crosses out that tier's
  // multiclass option, and multiclassing crosses out that tier's upgrade.
  // With two subclasses, each upgrade names its subclass.
  for (i, l) in c.levels.enumerate() {
    let n = i + 2
    for a in l.advancements.filter(a => a.advancement == "subclass") {
      let target = a.at("subclass", default: none)
      if mc != none and tier-of(n) == tier-of(mc.level) {
        errors.push("level " + str(n) + ": no upgraded subclass in tier " + str(tier-of(n)) + ", where you multiclassed (level " + str(mc.level) + "); one crosses out the other (p. 53)")
      }
      if target == none {
        if mc != none and n >= mc.level { errors.push("level " + str(n) + ": you have two subclasses; name the one to upgrade, `upgrade-subclass(subclasses." + c.subclass.id + ")` or `upgrade-subclass(subclasses." + mc.subclass.id + ")`") }
      } else if target.at("kind", default: none) != "subclass" {
        errors.push("level " + str(n) + ": `upgrade-subclass` takes a subclass entity, got " + repr(target))
      } else if target.id != c.subclass.id and not (mc != none and target.id == mc.subclass.id and n >= mc.level) {
        errors.push("level " + str(n) + ": " + target.name + " is not one of your subclasses" + if mc != none and target.id == mc.subclass.id { " yet (you multiclass at level " + str(mc.level) + ")" } else { "" })
      }
    }
  }
  for s in (c.subclass,) + if mc != none { (mc.subclass,) } else { () } {
    if subclass-upgrades(c, s) > 2 { errors.push(s.name + ": upgraded " + str(subclass-upgrades(c, s)) + " times; a subclass has only a specialization and a mastery (p. 53)") }
  }
  if errors.len() > 0 { return errors }

  let d = derive(c)
  // Equipment (p. 55): one primary, one secondary, two hands, tier.
  let cats = c.weapons.map(w => w.category)
  for cat in ("Primary", "Secondary") {
    if cats.filter(x => x == cat).len() > 1 { errors.push("`weapons`: only one " + cat + " weapon can be equipped (p. 55)") }
  }
  let hands = c.weapons.map(w => if w.burden == "Two-Handed" { 2 } else { 1 }).sum(default: 0)
  if hands > 2 { errors.push("`weapons`: maximum burden is 2 hands, these take " + str(hands) + " (p. 55)") }
  for w in c.weapons {
    if w.tier > d.tier { errors.push("`weapons`: " + w.name + " is tier " + str(w.tier) + ", above the character's tier " + str(d.tier) + " (p. 55)") }
    if (w.damage-type != "phy" or w.trait == "Spellcast") and d.spellcast-trait == none { errors.push("`weapons`: " + w.name + " deals magic damage and needs a Spellcast trait (p. 55)") }
  }
  if c.at("armor", default: none) != none and c.armor.tier > d.tier {
    errors.push("`armor`: " + c.armor.name + " is tier " + str(c.armor.tier) + ", above the character's tier " + str(d.tier) + " (p. 55)")
  }
  // Domain cards (pp. 6, 54): from the class's domains, at or below level,
  // two at creation plus one per level, extra-card advancements and grants.
  // A multiclass domain's cards: taken from the multiclass level on, at or
  // below half the level they are taken at, rounded up (p. 54).
  let acquired = d.loadout + d.vault
  let taken-at = c.cards.map(k => (k, 1)) + c.levels.enumerate().map(((i, l)) => (l.cards + l.advancements.filter(a => a.advancement == "card").map(a => a.card)).map(k => (k, i + 2))).sum(default: ())
  for (k, n) in taken-at {
    if k.at("kind", default: none) != "domain-card" { errors.push("`cards`: " + repr(k.at("name", default: k)) + " is not a domain card"); continue }
    if k.domain in c.class.domains {
      if k.level > n { errors.push("`cards`: " + k.name + " is level " + str(k.level) + ", taken at " + (if n == 1 { "creation" } else { "level " + str(n) }) + "; a new card is at your level or lower (p. 53)") }
    } else if mc != none and k.domain == mc.domain {
      if n < mc.level { errors.push("`cards`: " + k.name + " is a " + k.domain + " card, taken at level " + str(n) + ", before you multiclass at level " + str(mc.level)) }
      else if k.level > calc.ceil(n / 2) { errors.push("level " + str(n) + ": " + k.name + " is level " + str(k.level) + "; cards from your multiclass domain (" + k.domain + ") are at or below half your level, rounded up: " + str(calc.ceil(n / 2)) + " (p. 54)") }
    } else {
      errors.push("`cards`: " + k.name + " is a " + k.domain + " card; " + c.class.name + " has " + c.class.domains.join(" and ") + if mc != none { ", and " + mc.domain + " through multiclassing" } + " (p. 6)")
    }
  }
  // Cards and companion training due at each level (`cards-due`,
  // `training-due`), so grants gained later ("Accomplished", "Expert
  // Training") are checked where they are gained.
  let has-companion = d.grants.companion > 0
  let companion-from = if has-companion { gained-at(c, "companion") } else { none }
  if has-companion and c.at("companion", default: none) == none {
    errors.push("`companion`: " + d.features.filter(((_, f)) => "companion" in f.at("grants", default: (:))).map(((_, f)) => f.name).join(", ") + " gives this character an animal companion; add `companion: companion(...)` (p. 21)")
  }
  if not has-companion and c.at("companion", default: none) != none {
    errors.push("`companion`: only a character with a companion feature (Beastbound, p. 20) has one")
  }
  for n in range(1, d.level + 1) {
    let at = if n == 1 { "creation" } else { "level " + str(n) }
    let ls = c.levels.slice(0, n - 1)
    let taken = c.cards.len() + ls.map(l => l.cards.len() + l.advancements.filter(a => a.advancement == "card").len()).sum(default: 0)
    let due = cards-due(c, n)
    if taken != due.total {
      errors.push(at + ": " + str(due.total) + " domain cards due by now (" + due.why.join(", ") + "), got " + str(taken)
        + if n == 1 { "; write them in `cards:`" } else { "; give level " + str(n) + " `card:` (a list when it gets more than one)" })
    }
    if has-companion and n > companion-from {
      let marked = ls.map(l => l.companion.len()).sum(default: 0)
      let due = training-due(c, n)
      if marked != due { errors.push(at + ": " + str(due) + " companion training marks due by now (one per level-up, plus Expert/Advanced Training), got " + str(marked) + "; use `companion:` in `level(...)`") }
      let l = ls.last()
      if n in (2, 5, 8) and l.companion-experience == none { errors.push(at + ": your companion gains an Experience with yours; add `companion-experience:` (p. 21)") }
      if n not in (2, 5, 8) and l.companion-experience != none { errors.push(at + ": a companion's new Experiences come with yours, at levels 2, 5 and 8 (p. 21)") }
    }
    if n > 1 and not (has-companion and n > companion-from) {
      let l = ls.last()
      if l.companion.len() > 0 or l.companion-experience != none { errors.push(at + ": `companion:` and `companion-experience:` need a companion" + if has-companion { ", which comes at level " + str(companion-from) + "; training starts the level after" } else { "" }) }
    }
  }
  if has-companion and c.at("companion", default: none) != none { errors += check-companion(c) }
  // Beastforms (p. 14): a feature that grants them needs the list of forms.
  let beast-features = d.features.filter(((_, f)) => "beastforms" in f.at("grants", default: (:)))
  if beast-features.len() == 0 and "beastforms" in c {
    errors.push("`beastforms`: only a character with a Beastform feature (Druid, p. 14) takes Beastform options")
  }
  // Martial stances (pp. 12-13): `start` Tier 1 stances when the feature is
  // taken (at creation), then `per-level` each level, of the tier or lower.
  let all-stances = d.stances
  if d.stance-rules == none {
    if all-stances.len() > 0 { errors.push("`stances`: only a character with a stance feature (Martial Artist's \"Stance Fighter\", p. 12) knows martial stances") }
  } else {
    let r = d.stance-rules
    let bad = all-stances.filter(k => k.stance.at("kind", default: none) != "stance")
    if bad.len() > 0 { errors.push("`stances`: " + bad.map(k => repr(k.stance.at("name", default: k.stance))).join(", ") + " is not a stance entity") } else {
      // The feature comes at creation, or later through multiclassing: the
      // starting stances are then written in that level.
      let from = gained-at(c, "stances")
      let first = if from == 1 { c.stances } else { c.levels.at(from - 2).at("stances", default: ()) }
      let where = if from == 1 { "at creation" } else { "at level " + str(from) + ", when you gain the feature" }
      if first.len() != r.start or first.any(s => s.tier != 1) {
        errors.push("`stances`: choose " + str(r.start) + " Tier 1 stances " + where + " (p. 12), got " + if first.len() == 0 { "none" } else { first.map(s => s.name + " (tier " + str(s.tier) + ")").join(", ") })
      }
      if from > 1 and c.stances.len() > 0 { errors.push("`stances`: you gain martial stances at level " + str(from) + "; write them in `level(" + str(from) + ", stance: (...))`") }
      for (i, l) in c.levels.enumerate() {
        let n = i + 2
        let got = l.at("stances", default: ())
        if n < from {
          if got.len() > 0 { errors.push("level " + str(n) + ": no martial stances before level " + str(from)) }
          continue
        }
        if n == from { continue }
        if got.len() != r.per-level { errors.push("level " + str(n) + ": learn " + str(r.per-level) + " martial stance (p. 12), got " + str(got.len()) + "; use `level(" + str(n) + ", stance: stances.<name>)`") }
        for s in got.filter(s => s.tier > tier-of(n)) { errors.push("level " + str(n) + ": " + s.name + " is a tier " + str(s.tier) + " stance; choose one of tier " + str(tier-of(n)) + " or lower (p. 12)") }
      }
      let ids = all-stances.map(k => k.stance.id)
      if ids.dedup().len() != ids.len() { errors.push("`stances`: the same stance is learned twice") }
    }
  }
  for b in c.at("beastforms", default: ()) {
    if b.at("kind", default: none) != "beastform" { errors.push("`beastforms`: " + repr(b.at("name", default: b)) + " is not a beastform entity") }
  }
  // Cards with choices ("Vitality", p. 208): exactly `pick` different options.
  for k in acquired.filter(k => "choices" in k) {
    let opts = k.choices.options.keys()
    let chosen = k.at("chosen", default: ())
    let bad = chosen.filter(o => o not in opts)
    if chosen.len() != k.choices.pick or bad.len() > 0 or chosen.dedup().len() != chosen.len() {
      errors.push("`cards`: " + k.name + " needs " + str(k.choices.pick) + " different choices, written `(cards." + k.id + ", (" + opts.slice(0, k.choices.pick).map(repr).join(", ") + "))`; options: " + opts.map(repr).join(", ") + if bad.len() > 0 { "; unknown: " + bad.map(repr).join(", ") })
    }
  }
  let ids = acquired.map(k => k.id)
  if ids.dedup().len() != ids.len() { errors.push("`cards`: the same card is taken twice") }
  for v in c.vault { if v.id not in ids { errors.push("`vault`: " + v.name + " is not among the character's cards") } }
  // Loadout size (p. 3), changed by `loadout` modifiers ("Attuned", p. 74).
  let max-loadout = 5 + d.features.filter(((_, f)) => "loadout" in f.at("modifiers", default: (:))).map(((_, f)) => f.modifiers.loadout).sum(default: 0)
  if d.loadout.len() > max-loadout { errors.push("loadout holds at most " + str(max-loadout) + " cards; move " + str(d.loadout.len() - max-loadout) + " to `vault:`") }
  errors
}

/// A player character. Write only choices; everything else is derived.
///
/// ```typ
/// #let mira = character(
///   id: "mira", name: "Mira", class: classes.wizard,
///   subclass: subclasses.school-of-knowledge, ...,
///   levels: (level(2, experience: "Herbalist", card: ..., advancements: (...)),),
/// )
/// ```
#let character(
  id: none, name: none, tags: none, flags: none, pronouns: none,
  class: none, subclass: none, ancestry: none, community: none,
  traits: none, experiences: none, weapons: none, armor: none,
  cards: none, vault: none, inventory: none, story: none, levels: none,
  companion: none, transformation: none, transformation-limit: none, beastforms: none, stances: none,
  ..unknown,
) = {
  let c = core.entity("character", character-schema,
    id: id, name: name, tags: tags, flags: flags, pronouns: pronouns,
    class: class, subclass: subclass, ancestry: ancestry, community: community,
    traits: traits, experiences: experiences, weapons: weapons, armor: armor,
    cards: if type(cards) == array { cards.map(with-choices) } else { cards },
    vault: vault, inventory: inventory, story: story, levels: levels, companion: companion,
    transformation: if type(transformation) == dictionary { (transformation,) } else { transformation },
    transformation-limit: transformation-limit,
    beastforms: if type(beastforms) == dictionary { beastforms.values() } else { beastforms },
    stances: stances,
    ..unknown)
  core.report("character " + repr(c.id), check-rules(c))
  c
}
