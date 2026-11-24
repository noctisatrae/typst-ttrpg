// expect: transformation "bad" has 2 problems
// expect: unknown field `tracks[0] ("Rot").box` (did you mean `tracks[0] ("Rot").boxes`?)
// expect: field `questions` items must be strings or content, got [1] 3
#import "@local/heartweaver:0.1.0" as hw: feature
#hw.transformation(id: "bad", name: "Bad", features: (feature("A")[a],), tracks: ((name: "Rot", box: 3),), questions: ("Why?", 3))
