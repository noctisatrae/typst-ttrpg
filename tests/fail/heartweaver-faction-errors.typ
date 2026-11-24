// expect: faction "bad" has
// expect: a Faction Card holds 1-3 (p. 190)
// expect: `rank` must be a number from -3 to 3 (p. 190), got 4
// expect: countdown must be 10 (p. 190), got 8
// expect: has 3 countdowns running; at most 2 at a time (p. 190)
#import "@local/heartweaver:0.1.0" as hw: faction
#faction(id: "bad", name: "Bad",
  relationships: ((with: "Other", rank: 4),),
  assets: ("a", "b", "c", "d"),
  major-objectives: ((goal: "Big", countdown: 8),),
  minor-objectives: ((goal: "x", countdown: 4), (goal: "y", countdown: 5), (goal: "z", countdown: 6)))
