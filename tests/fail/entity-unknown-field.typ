// expect: creature "goblin" has 4 problems
// expect: unknown field `HP` (did you mean `hp`?)
// expect: field `size` must be one of "small", "medium", "large", got "tiny"
// expect: field `features[0] ("Stab").kind` must be one of "passive", "action", got "attack"
// expect: missing required field `defense`
// expect: allowed fields:
#import "../support/creature.typ": *
#creature(id: "goblin", name: "Goblin", size: "tiny", HP: 3,
  features: (feature("Stab", kind: "attack")[Stab.],))
