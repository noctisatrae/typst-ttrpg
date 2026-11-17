// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// The Beastbound companion (SRD pp. 20-22) through five levels, cards due
// per level (grants gained later, "Accomplished"), and a card with choices
// ("Vitality").
#import "@local/heartweaver:0.1.0" as hw: level, train, add-hit-point, add-stress, increase-evasion, increase-traits, upgrade-subclass, increase-proficiency
#import "@local/daggerheart-srd:0.1.0": cards
#import "../examples/characters/inskel/inskel.typ": inskel
#import "../examples/characters/paneolus/paneolus.typ": paneolus

// Level 1: Evasion 10, Stress 3, two Experiences at +2, d6 Melee,
// damage with the Ranger's Proficiency, commands are Spellcast Rolls.
#let k = hw.derive-companion(inskel, hw.derive(inskel))
#assert.eq((k.evasion.value, k.stress.value), (10, 3))
#assert.eq(k.experiences.map(e => (e.name, e.bonus.value)), (("Scout", 2), ("Bold Distraction", 2)))
#assert.eq((k.attack.range, k.attack.damage), ("Melee", "1d6"))
#assert.eq(k.command, (trait: "Agility", modifier: 1))

#let veteran = hw.character(..inskel + (vault: (cards.gifted-tracker,), levels: (
  level(2, experience: "Tracker", card: cards.conjure-swarm,
    advancements: (add-hit-point(), increase-evasion()),
    companion: (train.vicious("damage"),), companion-experience: "Fetch"),
  level(3, card: cards.brace, advancements: (add-stress(), increase-traits("Agility", "Instinct")),
    companion: (train.intelligent("Scout"),)),
  // Expert Training (specialization): one more mark at this level.
  level(4, card: cards.towering-stalk, advancements: (upgrade-subclass(), add-hit-point()),
    companion: (train.aware(), train.light-in-the-dark())),
  level(5, experience: "Survivor", card: cards.thorn-skin, advancements: (increase-proficiency(),),
    companion: (train.resilient(),), companion-experience: "On High Alert"),
)))
#let d = hw.derive(veteran)
#let k = hw.derive-companion(veteran, d)
#assert.eq((k.evasion.value, k.stress.value), (12, 4), message: "Aware +2, Resilient +1")
#assert.eq(k.experiences.map(e => (e.name, e.bonus.value)), (("Scout", 3), ("Bold Distraction", 2), ("Fetch", 2), ("On High Alert", 2)))
#assert.eq(k.attack.damage, "4d8", message: "Proficiency 4 (levels 2, 5, advancement), Vicious d6 -> d8")
#assert.eq(k.command.modifier, 2, message: "Agility 1 + 1 at level 3")
#assert.eq(d.hope.max, 7, message: "Light in the Dark: an additional Hope slot")
#assert.eq(hw.training-due(veteran, 4), 4)
#assert.eq(hw.training-due(veteran, 5), 5)

// Accomplished (School of Knowledge specialization, p. 31) grants a card
// at the level it is taken: `card:` takes a list there.
#let scholar = hw.character(..paneolus + (levels: (
  level(2, experience: "Archivist", card: (cards.book-of-sitil, cards.final-words),
    advancements: (upgrade-subclass(), add-hit-point())),
)))
#assert.eq(hw.cards-due(scholar, 1).total, 3, message: "2 + Prepared")
#assert.eq(hw.cards-due(scholar, 2).total, 5, message: "+1 level-up, +1 Accomplished")
#assert.eq(hw.derive(scholar).loadout.len(), 5)

// Vitality (p. 208): two choices, then the card sits in the vault for good
// and its benefits stay. (Swapped onto a finished character to test the
// arithmetic; Paneolus could not take a Blade card.)
#let base = hw.derive(paneolus)
#let d = hw.derive(paneolus + (cards: ((cards.vitality + (chosen: ("hp", "thresholds"))),)))
#assert.eq(d.hp.value, base.hp.value + 1)
#assert.eq(d.stress.value, base.stress.value)
#assert.eq(d.thresholds.major.value, base.thresholds.major.value + 2)
#assert.eq((d.loadout.len(), d.vault.map(k => k.id)), (0, ("vitality",)))

#hw.sheet(veteran)
