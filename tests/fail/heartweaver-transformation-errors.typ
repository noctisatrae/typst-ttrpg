// expect: character "paneolus" has 1 problem
// expect: `transformation`: a PC can't have more than one transformation (p. 42), got 2 (Ghost, Vampire)
// expect: set `transformation-limit: 2`
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": transformations
#import "../../examples/characters/paneolus/paneolus.typ": paneolus
#hw.character(..paneolus + (transformation: (transformations.ghost, transformations.vampire)))
