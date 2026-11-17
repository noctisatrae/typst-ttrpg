// A level 1 character: derived numbers match the SRD rules.
#import "@local/heartweaver:0.1.0" as hw
#import "../examples/characters/paneolus/paneolus.typ": paneolus

#let d = hw.derive(paneolus)
#assert.eq(d.level, 1)
#assert.eq(d.evasion.value, 11, message: "Wizard starting Evasion (p. 30)")
#assert.eq(d.hp.value, 5, message: "Wizard starting HP (p. 30)")
#assert.eq(d.stress.value, 6, message: "every PC starts with 6 Stress slots (p. 5)")
#assert.eq(d.proficiency.value, 1)
#assert.eq((d.thresholds.major.value, d.thresholds.severe.value), (7, 14), message: "Leather 6/13 + level 1 (p. 72)")
#assert.eq(d.armor-score.value, 3)
#assert.eq(d.spellcast-trait, "Knowledge")
#assert.eq(d.attacks.first().damage, "1d6")
#assert.eq(d.attacks.first().modifier, 2, message: "Greatstaff uses Knowledge +2")
#assert.eq(d.experiences.map(e => (e.name, e.bonus.value)), (("Cours ma belle !!!", 2), ("Herbologue", 2)))
#assert.eq(d.loadout.len(), 3, message: "2 cards + 1 from Prepared")
