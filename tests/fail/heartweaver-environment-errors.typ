// expect: environment "foggy-moor" has 5 problems
// expect: field `type` must be one of "Exploration", "Social", "Traversal", "Event", got "Dungeon"
// expect: unknown field `impulse` (did you mean `impulses`?)
// expect: field `features[0] ("Fog").kind` must be one of "Passive", "Action", "Reaction", got "Evolution"
// expect: field `difficulty` must be integer or string, got float 11.5
// expect: missing required field `potential-adversaries`
#import "@local/heartweaver:0.1.0" as hw
#hw.environment(
  id: "foggy-moor", name: "Foggy Moor", tier: 1, type: "Dungeon",
  description: "Fog.", impulse: "Hide", difficulty: 11.5,
  features: (hw.feature("Fog", kind: hw.feature-kind.evolution)[Fog rolls in.],),
)
