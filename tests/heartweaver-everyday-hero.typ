// Everyday Hero starting equipment (SRD pp. 191-192): the tables, tier 1,
// tagged, and their effects on a character's numbers.
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": everyday-hero, weapons
#import "../examples/characters/paneolus/paneolus.typ": paneolus

#let hero = everyday-hero
#assert.eq(hero.weapons.len(), 32, message: "15 physical + 10 magic primaries, 7 secondaries")
#assert.eq(hero.armors.len(), 4)
#assert(hero.weapons.values().all(w => w.tier == 1 and "everyday-hero" in w.tags))
#assert(hero.weapons.keys().all(k => k not in weapons), message: "no id clashes with the core tables")
#assert.eq(hero.armors.leather-apron.features, (), message: "no feature printed")

// Paneolus (Wizard, Knowledge) with a Whisk Wand, a Table Shield and
// Quilted Clothing: Barrier +2 Armor Score / −1 Evasion, Flexible +1 Evasion.
#let base = hw.derive(paneolus)
#let homely = hw.character(..paneolus + (id: "homely-paneolus",
  weapons: (hero.weapons.whisk-wand, hero.weapons.table-shield), armor: hero.armors.quilted-clothing))
#let d = hw.derive(homely)
#assert.eq(d.evasion.value, 11 - 1 + 1)
#assert.eq(d.armor-score.value, 3 + 2)
#assert.eq((d.thresholds.major.value, d.thresholds.severe.value), (5 + 1, 11 + 1))
#assert.eq(d.attacks.first().damage, "1d6+1")
#hw.sheet(homely)
