// The combat wheelchair (SRD pp. 70-71) on a character: "All combat
// wheelchairs are equipped as Primary Weapons"; the Arcane Frame uses "the
// Spellcast trait indicated by your subclass"; "the only wheelchair that
// gives a penalty to a PC's Evasion is the Heavy Frame model".
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": weapons
#import "../examples/characters/paneolus/paneolus.typ": paneolus

#let chairs = weapons.values().filter(w => "combat-wheelchair" in w.tags)
#assert.eq(chairs.len(), 12)
#assert(chairs.all(w => w.category == "Primary"))

// Arcane Frame: Paneolus (School of Knowledge, Spellcast Knowledge +2)
// attacks with Knowledge, +1 from Reliable, magic damage with Proficiency.
#let arcane = hw.character(..paneolus + (id: "paneolus-arcane-chair", weapons: (weapons.arcane-frame-wheelchair,)))
#let d = hw.derive(arcane)
#let base = hw.derive(paneolus)
#assert.eq(d.attacks.first().modifier, 2 + 1)
#assert.eq(d.attacks.first().damage, "1d6")
#assert.eq(d.evasion.value, base.evasion.value, message: "no Evasion penalty")

// Light Frame: Agility, no Evasion penalty.
#let light = hw.derive(paneolus + (weapons: (weapons.light-frame-wheelchair,)))
#assert.eq(light.attacks.first().modifier, -1)
#assert.eq(light.evasion.value, base.evasion.value)

// Heavy Frame: Strength, two hands, −1 Evasion.
#let heavy = hw.derive(paneolus + (weapons: (weapons.heavy-frame-wheelchair,)))
#assert.eq(heavy.evasion.value, base.evasion.value - 1)
#assert.eq(heavy.attacks.first().damage, "1d12+3")

#hw.sheet(arcane)
