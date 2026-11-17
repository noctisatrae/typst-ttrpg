// expect: level 2: 5 domain cards due by now (2 at creation, 1 per level-up, + Prepared, + Accomplished), got 4
// expect: Vitality needs 2 different choices, written `(cards.vitality, ("stress", "hp"))`; options: "stress", "hp", "thresholds"; unknown: "evasion"
#import "@local/heartweaver:0.1.0" as hw: level, upgrade-subclass, add-hit-point
#import "@local/daggerheart-srd:0.1.0": cards
#import "../../examples/characters/paneolus/paneolus.typ": paneolus
#hw.character(..paneolus + (levels: (
  level(2, experience: "Archivist", card: (cards.vitality, ("hp", "evasion")),
    advancements: (upgrade-subclass(), add-hit-point())),
)))
