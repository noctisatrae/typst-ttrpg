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
/// An additional domain card.
#let extra-card(card) = (advancement: "card", card: card, slots: 1)
/// +1 Evasion.
#let increase-evasion() = (advancement: "evasion", slots: 1)
/// The next subclass card: specialization, then mastery.
#let upgrade-subclass() = (advancement: "subclass", slots: 1)
/// +1 Proficiency (takes both slots).
#let increase-proficiency() = (advancement: "proficiency", slots: 2)
/// Multiclass (takes both slots, level 5+): another class, one of its
/// domains, and a subclass of it. Allowed by the format; derivation of its
/// effects is not implemented yet.
#let multiclass(class, domain, subclass) = (advancement: "multiclass", class: class, domain: domain, subclass: subclass, slots: 2)

/// One level-up (p. 53): a new Experience at levels 2, 5 and 8 (tier
/// achievements), two advancements, and the new domain card (step four).
/// `level(2, experience: "Survivalist", card: cards.x, advancements: (...))`
#let level(n, experience: none, card: none, advancements: ()) = (
  level: n, experience: experience, card: card, advancements: advancements,
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
  vault: field(array, default: (), items: dictionary),
  inventory: field(array, default: ()),
  story: field(dictionary, default: (:)),
  levels: field(array, default: (), items: dictionary),
)

#let tier-of(level) = if level == 1 { 1 } else if level <= 4 { 2 } else if level <= 7 { 3 } else { 4 }

// ---------------------------------------------------------------------
// Tracked numbers: a value with the parts that add up to it.

#let stat(label, value) = (value: value, parts: ((label, value),))
#let bump(s, label, delta) = (value: s.value + delta, parts: s.parts + ((label, delta),))

/// Every feature in effect, with where it comes from: class, subclass cards
/// taken so far, heritage, equipped weapons and armor, loadout cards.
#let active-features(c, subclass-cards) = {
  let out = ()
  out.push((c.class.name + " (Hope)", c.class.hope-feature))
  for f in c.class.features { out.push((c.class.name, f)) }
  for (i, step) in ("foundation", "specialization", "mastery").enumerate() {
    if i < subclass-cards { for f in c.subclass.at(step) { out.push((c.subclass.name, f)) } }
  }
  for f in c.ancestry.features { out.push((c.ancestry.name, f)) }
  for f in c.community.features { out.push((c.community.name, f)) }
  for w in c.weapons { for f in w.features { out.push((w.name, f)) } }
  if c.at("armor", default: none) != none { for f in c.armor.features { out.push((c.armor.name, f)) } }
  for card in c.loadout { for f in card.features { out.push((card.name, f)) } }
  out
}

/// Everything the sheet shows, computed from the character's choices.
/// Numbers are `(value:, parts:)`; `parts` lists (source, amount) pairs.
#let derive(c) = {
  let lvl = 1 + c.levels.len()
  let tier = tier-of(lvl)
  let ups = c.levels.map(l => l.advancements).flatten()
  let count(name) = ups.filter(a => a.advancement == name).len()
  let subclass-cards = 1 + count("subclass")

  let acquired = c.cards + c.levels.map(l => l.card).filter(x => x != none) + ups.filter(a => a.advancement == "card").map(a => a.card)
  let vault-ids = c.vault.map(v => v.id)
  let loadout = acquired.filter(k => k.id not in vault-ids)
  let features = active-features(c + (loadout: loadout), subclass-cards)
  // Modifiers for `key` from every active feature, except those of the
  // sources named in `except` (a weapon's attack bonus is its own).
  let mods(key, except: ()) = features.filter(((src, f)) => key in f.at("modifiers", default: (:)) and src not in except).map(((src, f)) => (src + ": " + f.name, f.modifiers.at(key)))

  // Traits first: other modifiers may depend on them.
  let traits = (:)
  for k in trait-keys {
    let s = stat("chosen", c.traits.at(k))
    for (i, l) in c.levels.enumerate() {
      for a in l.advancements.filter(a => a.advancement == "traits") {
        if a.traits.map(trait-key).contains(k) { s = bump(s, "level " + str(i + 2), 1) }
      }
    }
    for (label, m) in mods(k) { s = bump(s, label, m) }
    traits.insert(k, s)
  }
  let spellcast = c.subclass.at("spellcast-trait", default: none)
  let ctx = (level: lvl, tier: tier, traits: traits.pairs().map(((k, s)) => (k, s.value)).to-dict(), spellcast-trait: spellcast)
  let apply(s, key) = {
    for (label, m) in mods(key) { s = bump(s, label, if type(m) == function { m(ctx) } else { m }) }
    s
  }
  let by-level(s, name) = {
    for (i, l) in c.levels.enumerate() {
      for a in l.advancements.filter(a => a.advancement == name) { s = bump(s, "level " + str(i + 2), 1) }
    }
    s
  }

  let proficiency = stat("level 1", 1)
  for n in (2, 5, 8) { if lvl >= n { proficiency = bump(proficiency, "tier achievement, level " + str(n), 1) } }
  proficiency = apply(by-level(proficiency, "proficiency"), "proficiency")

  let evasion = apply(by-level(stat(c.class.name, c.class.evasion), "evasion"), "evasion")
  let hp = apply(by-level(stat(c.class.name, c.class.hp), "hp"), "hp")
  let stress = apply(by-level(stat("start", 6), "stress"), "stress")

  // Thresholds: armor's base + level; unarmored, level and twice level.
  let armor = c.at("armor", default: none)
  let (major, severe) = if armor != none {
    (stat(armor.name, armor.thresholds.major), stat(armor.name, armor.thresholds.severe))
  } else { (stat("unarmored", 0), stat("unarmored", lvl)) }
  major = apply(apply(bump(major, "level", lvl), "thresholds"), "major")
  severe = apply(apply(bump(severe, "level", lvl), "thresholds"), "severe")
  let armor-score = apply(stat(if armor != none { armor.name } else { "unarmored" }, if armor != none { armor.score } else { 0 }), "armor-score")
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

  (
    level: lvl,
    tier: tier,
    traits: traits,
    spellcast-trait: spellcast,
    proficiency: proficiency,
    evasion: evasion,
    hp: hp,
    stress: stress,
    hope: (start: 2, max: 6),
    thresholds: (major: major, severe: severe),
    armor-score: armor-score,
    experiences: experiences,
    attacks: attacks,
    loadout: loadout,
    vault: acquired.filter(k => k.id in vault-ids),
    features: features,
    subclass-cards: subclass-cards,
    grants: features.map(((_, f)) => f.at("grants", default: (:)).at("domain-cards", default: 0)).sum(default: 0),
  )
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
  if errors.len() > 0 { return errors }

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
    if l.card == none { errors.push(at + ": needs the new domain card, `card:` (p. 54, step four)") }
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
  if c.levels.map(l => l.advancements).flatten().filter(a => a.advancement == "multiclass").len() > 0 {
    errors.push("multiclassing is accepted by the format but not derived yet; remove it for now")
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
  let acquired = d.loadout + d.vault
  for k in acquired {
    if k.at("kind", default: none) != "domain-card" { errors.push("`cards`: " + repr(k.at("name", default: k)) + " is not a domain card"); continue }
    if k.domain not in c.class.domains { errors.push("`cards`: " + k.name + " is a " + k.domain + " card; " + c.class.name + " has " + c.class.domains.join(" and ") + " (p. 6)") }
    if k.level > d.level { errors.push("`cards`: " + k.name + " is level " + str(k.level) + ", above the character's level " + str(d.level)) }
  }
  // Grants in effect at creation (e.g. a foundation card's "Prepared").
  // Grants gained later (specialization, mastery) are not checked yet.
  let start = derive(c + (levels: ()))
  let expected-start = 2 + start.grants
  if c.cards.len() != expected-start {
    let why = if start.grants > 0 { " (2, plus " + str(start.grants) + " from " + start.features.filter(((_, f)) => "grants" in f).map(((s, f)) => f.name).join(", ") + ")" } else { " (p. 6)" }
    errors.push("`cards`: a new character takes " + str(expected-start) + " level-1 domain cards" + why + ", got " + str(c.cards.len()))
  }
  let ids = acquired.map(k => k.id)
  if ids.dedup().len() != ids.len() { errors.push("`cards`: the same card is taken twice") }
  for v in c.vault { if v.id not in ids { errors.push("`vault`: " + v.name + " is not among the character's cards") } }
  if d.loadout.len() > 5 { errors.push("loadout holds at most 5 cards; move " + str(d.loadout.len() - 5) + " to `vault:`") }
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
  ..unknown,
) = {
  let c = core.entity("character", character-schema,
    id: id, name: name, tags: tags, flags: flags, pronouns: pronouns,
    class: class, subclass: subclass, ancestry: ancestry, community: community,
    traits: traits, experiences: experiences, weapons: weapons, armor: armor,
    cards: cards, vault: vault, inventory: inventory, story: story, levels: levels,
    ..unknown)
  core.report("character " + repr(c.id), check-rules(c))
  c
}
