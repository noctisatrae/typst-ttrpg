// Beastforms (Druid, SRD pp. 14-18): every SRD form renders; a Druid's
// sheet lists the forms of its tier or lower with their numbers.
#import "@local/heartweaver:0.1.0" as hw: beastform, feature
#import "@local/daggerheart-srd:0.1.0": beastforms
#import "../examples/characters/daryl/daryl.typ": daryl

#assert.eq(beastforms.len(), 24)
#for t in (1, 2, 3, 4) { assert.eq(beastforms.values().filter(b => b.tier == t).len(), 6, message: "six forms in tier " + str(t)) }
#for b in beastforms.values() { hw.beastform-block(b) }
// Upgraded forms have only their feature; hybrids no advantages.
#assert("trait" not in beastforms.legendary-beast)
#assert.eq(beastforms.mythic-hybrid.advantages, ())
#assert.eq(beastforms.mythic-hybrid.attack, (range: "Melee", trait: "Strength", damage: "d12+10", damage-type: "phy"))

// Daryl (level 1 Druid, Agility −1, Evasion 10 + armor): tier 1 forms only.
#let d = hw.derive(daryl)
#assert.eq(d.beastforms.len(), 6)
#let scout = d.beastforms.first()
#assert.eq(scout.form.id, "agile-scout")
#assert.eq(scout.evasion, d.evasion.value + 2, message: "Evasion +2 (p. 15)")
#assert.eq(scout.attack, d.traits.agility.value + 1, message: "Melee Agility, with the form's Agility +1")
#assert.eq(scout.damage, "1d4", message: "d4 with Proficiency 1")
// An attack with a trait the form doesn't raise gets no trait bonus.
#let odd = beastform(id: "odd", name: "Odd", tier: 1, trait: "Strength", trait-bonus: 2, evasion-bonus: 0,
  attack: (range: "Melee", trait: "Agility", damage: "d6", damage-type: "phy"), features: (feature("X")[x],))
#assert.eq(hw.derive(hw.character(..daryl + (beastforms: (odd,)))).beastforms.first().attack, d.traits.agility.value)
#hw.sheet(daryl)
