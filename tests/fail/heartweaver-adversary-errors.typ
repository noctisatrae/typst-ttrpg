// expect: adversary "bad" has 6 problems
// expect: unknown field `HP` (did you mean `hp`?)
// expect: a Horde needs `creatures-per-hp` (the X in "X/HP", p. 93)
// expect: field `thresholds.severe` must be integer or none, got string "None"
// expect: field `attack.range` must be one of "Melee", "Very Close", "Close", "Far", "Very Far", got "Near"
// expect: field `attack.modifier` must be integer or string, got boolean true
// expect: missing required field `attack.damage-type`
#import "@local/heartweaver:0.1.0": adversary
#adversary(
  id: "bad", name: "Bad", tier: 1, type: "Horde", description: "x", motives: "x",
  difficulty: 10, thresholds: (major: 4, severe: "None"), HP: 3,
  attack: (modifier: true, name: "Bite", range: "Near", damage: "1d6"),
)
