// expect: `creatures-per-hp` is only for Hordes, but `type` is "Minion"
#import "@local/heartweaver:0.1.0": adversary
#adversary(
  id: "bad", name: "Bad", tier: 1, type: "Minion", creatures-per-hp: 2, description: "x", motives: "x",
  difficulty: 10, thresholds: (major: none, severe: none), hp: 1, stress: 1,
  attack: (modifier: 0, name: "Bite", range: "Melee", damage: "2", damage-type: "phy"),
)
