// expect: character "inskel" has 3 problems
// expect: level 2: 1 companion training marks due by now
// expect: level 2: your companion gains an Experience with yours; add `companion-experience:` (p. 21)
// expect: companion training "aware" can be marked 3 times, got 4
#import "@local/heartweaver:0.1.0" as hw: level, train, add-hit-point, increase-evasion
#import "@local/daggerheart-srd:0.1.0": cards
#import "../../examples/characters/inskel/inskel.typ": inskel
#hw.character(..inskel + (levels: (
  level(2, experience: "Tracker", card: cards.conjure-swarm, advancements: (add-hit-point(), increase-evasion()),
    companion: (train.aware(), train.aware(), train.aware(), train.aware())),
)))
