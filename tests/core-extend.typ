#import "support/creature.typ": *

#let boss = extend(goblin,
  id: "goblin-boss", name: "Goblin Boss",
  hp: 6,
  defense: (low: 6, high: 11),
  tags: add("leader"),
  features: (
    replace("Stab", kind: "action")[Deals more damage.],
    remove("Flee"),
    add(feature("Rally", kind: "action")[Allies take heart.]),
  ),
)

#assert.eq(boss.id, "goblin-boss")
#assert.eq(boss.hp, 6)
#assert.eq(boss.size, "small", message: "untouched fields are inherited")
#assert.eq(boss.tags, ("sneaky", "leader"))
#assert.eq(boss.features.map(f => f.name), ("Stab", "Darkvision", "Rally"),
  message: "replaced items keep their position, added ones go last")
#assert.eq(boss.features.first().body, [Deals more damage.])
#assert.eq(boss.flags.extends, "goblin")
#assert.eq(goblin.hp, 3, message: "the base is never changed")

// all(...) replaces a whole list.
#let mute = extend(goblin, id: "mute-goblin", tags: all(), features: all(
  feature("Stab", kind: "action")[Deals a little damage.],
))
#assert.eq(mute.tags, ())
#assert.eq(mute.features.len(), 1)

// Plain values in lists: replace by value.
#let renamed = extend(goblin, id: "renamed", tags: replace("sneaky", "loud"))
#assert.eq(renamed.tags, ("loud",))
