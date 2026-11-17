#import "support/creature.typ": *

#assert.eq(goblin.kind, "creature")
#assert.eq(goblin.hp, 3)
#assert.eq(goblin.flags, (:))
#assert.eq(goblin.features.map(f => f.name), ("Stab", "Flee", "Darkvision"))

// Defaults fill in omitted list fields; constants are plain strings.
#let rat = creature(id: "rat", name: "Rat", size: size.small, hp: 1, defense: (low: 1, high: 2))
#assert.eq(rat.tags, ())
#assert.eq(rat.features, ())
#assert.eq(rat.size, "small")
