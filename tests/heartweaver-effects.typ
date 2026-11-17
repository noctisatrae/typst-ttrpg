// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Effects that depend on the loadout, the armor or other stats. Cards and
// armor are swapped on a finished character (bypassing level checks) to
// test the arithmetic only.
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": cards, armors
#import "../examples/characters/paneolus/paneolus.typ": paneolus

#let with(..changes) = hw.derive(paneolus + changes.named())
#let base = hw.derive(paneolus)
#let severe(d) = d.thresholds.severe.value

// Bare Bones (p. 222): unarmored, Armor Score 3 + Strength and Tier 1 base
// thresholds 9/19, plus level like armor.
#let d = with(armor: none, cards: (cards.bare-bones,))
#assert.eq(d.armor-score.value, 3 + d.traits.strength.value)
#assert.eq((d.thresholds.major.value, severe(d)), (10, 20))
// With armor on, Bare Bones does nothing.
#assert.eq(with(cards: (cards.bare-bones,)).armor-score.value, base.armor-score.value)

// Rise Up (p. 223): Severe + Proficiency.
#assert.eq(severe(with(cards: (cards.rise-up,))), severe(base) + base.proficiency.value)

// "-Touched" (p. 222): 4 Splendor cards in the loadout, the card included.
#let splendor = (cards.bolt-beacon, cards.mending-touch, cards.reassurance)
#assert.eq(severe(with(cards: splendor + (cards.splendor-touched,))), severe(base) + 3)
#assert.eq(severe(with(cards: splendor.slice(1) + (cards.splendor-touched,))), severe(base), message: "3 Splendor cards: no bonus")
#assert.eq(severe(with(cards: splendor + (cards.splendor-touched,), vault: (cards.bolt-beacon,))), severe(base), message: "vaulted cards don't count")

// Bone-Touched (p. 210): a trait modifier that depends on the loadout.
#let bone = (cards.deft-maneuvers, cards.i-see-it-coming, cards.untouchable)
#let d = with(cards: bone + (cards.bone-touched,))
#assert.eq(d.traits.agility.value, base.traits.agility.value + 1)

// Spellcast Rolls: Channeling armor (p. 74) and Arcana-Touched (p. 207).
#assert.eq(base.spellcast-bonus.value, 0)
#assert.eq(with(armor: armors.channeling-armor).spellcast-bonus.value, 1)
#let arcana = (cards.rune-ward, cards.unleash-chaos, cards.wall-walk)
#assert.eq(with(cards: arcana + (cards.arcana-touched,)).spellcast-bonus.value, 1)

#hw.sheet(paneolus + (armor: armors.channeling-armor))

// Rune-Forged Exosuit "Attuned" (p. 74): thresholds + tier; the loadout
// limit drops to 4 (checked by `character`, which needs level 8 for it).
#let d = with(armor: armors.rune-forged-exosuit)
#assert.eq(d.thresholds.major.value, 12 + 1 + 1)
#assert.eq(d.features.filter(((_, f)) => f.name == "Attuned").first().last().modifiers.loadout, -1)
