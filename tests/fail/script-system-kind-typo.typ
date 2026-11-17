// expect: system kind "adversary" has 2 problems
// expect: unknown field `sumary` (did you mean `summary`?)
// expect: field `outline` must be boolean, got string "yes"
#import "@local/ttrpg-script:0.1.0": *
#show: setup.with(system: (kinds: (adversary: (section: "Cast", sumary: e => [x], outline: "yes"))))
Text.
