// expect: has 4 problems
// expect: missing `id`; an extended entity needs its own id
// expect: `features`: cannot remove "Fly", not found; it has "Stab", "Flee", "Darkvision"
// expect: `features` already has "Stab"; use replace("Stab", ...) to change it
// expect: field `hp` must be integer, got string "6"
#import "../support/creature.typ": *
#extend(goblin, hp: "6", features: (remove("Fly"), add(feature("Stab", kind: "action")[x])))
