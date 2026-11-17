// The owner's five level 1 characters, written with the generated SRD
// data: every derived number matches the SRD rules (class Evasion/HP plus
// permanent modifiers, thresholds = armor base + level, Proficiency 1,
// attack = trait + bonuses, damage = Proficiency x weapon dice).
#import "@local/heartweaver:0.1.0" as hw
#import "../examples/characters/paneolus/paneolus.typ": paneolus
#import "../examples/characters/inskel/inskel.typ": inskel
#import "../examples/characters/hydenok/hydenok.typ": hydenok
#import "../examples/characters/dor/dor.typ": dor
#import "../examples/characters/daryl/daryl.typ": daryl

#let summary(c) = {
  let d = hw.derive(c)
  (
    evasion: d.evasion.value,
    hp: d.hp.value,
    stress: d.stress.value,
    thresholds: (d.thresholds.major.value, d.thresholds.severe.value),
    armor: d.armor-score.value,
    proficiency: d.proficiency.value,
    attacks: d.attacks.map(a => (a.weapon.name, a.modifier, a.damage + " " + a.weapon.damage-type)),
    cards: d.loadout.len(),
  )
}

// Wizard 11/5 (p. 30); Leather 6/13 (p. 72); Greatstaff Knowledge d6 mag;
// School of Knowledge "Prepared" grants a third card (p. 31).
#assert.eq(summary(paneolus), (
  evasion: 11, hp: 5, stress: 6, thresholds: (7, 14), armor: 3, proficiency: 1,
  attacks: (("Greatstaff", 2, "1d6 mag"),), cards: 3,
))

// Ranger 12/6 (p. 20) + Gambeson "Flexible: +1 to Evasion" (p. 72);
// Human "High Stamina": an additional Stress slot (p. 36).
#assert.eq(summary(inskel), (
  evasion: 13, hp: 6, stress: 7, thresholds: (6, 12), armor: 3, proficiency: 1,
  attacks: (("Light-Frame Wheelchair", 1, "1d8 phy"), ("Hand Crossbow", 0, "1d6+1 phy")), cards: 2,
))

// Rogue 12/6 (p. 22) + Gambeson +1 Evasion; Finesse +2 for both weapons.
#assert.eq(summary(hydenok), (
  evasion: 13, hp: 6, stress: 6, thresholds: (6, 12), armor: 3, proficiency: 1,
  attacks: (("Returning Blade", 2, "1d8 mag"), ("Small Dagger", 2, "1d8 phy")), cards: 2,
))

// Rogue 12/6 + Gambeson +1 + Simiah "Nimble: a permanent +1 bonus to
// your Evasion at character creation" (p. 38).
#assert.eq(summary(dor), (
  evasion: 14, hp: 6, stress: 6, thresholds: (6, 12), armor: 3, proficiency: 1,
  attacks: (("Dagger", 0, "1d8+1 phy"), ("Small Dagger", 0, "1d8 phy")), cards: 2,
))

// Druid 10/6 (p. 14); Leather 6/13; Faerie "Wings" is situational (only
// while flying), so it stays text.
#assert.eq(summary(daryl), (
  evasion: 10, hp: 6, stress: 6, thresholds: (7, 14), armor: 3, proficiency: 1,
  attacks: (("Hand Runes", 2, "1d10 mag"), ("Grappler", 1, "1d6 phy")), cards: 2,
))

// Provenance: Dor's Evasion names every source.
#assert.eq(hw.derive(dor).evasion.parts.map(((l, v)) => v), (12, 1, 1))

// All five sheets render.
#for c in (paneolus, inskel, hydenok, dor, daryl) { hw.sheet(c) }
