// expect: creature "goblin-boss" (extending "goblin") has 1 problem
// expect: `features` is a list and got a plain list; extend won't guess
// expect: to replace all of it: features: all(...)
#import "../support/creature.typ": *
#extend(goblin, id: "goblin-boss", features: (feature("Rally", kind: "action")[Rally.],))
