// expect: `cards`: Towering Stalk is a Sage card, taken at level 4, before you multiclass at level 5
// expect: level 5: Death Grip is level 4; cards from your multiclass domain (Sage) are at or below half your level, rounded up: 3 (p. 54)
// expect: `cards`: Book of Norai is level 3, taken at level 2; a new card is at your level or lower (p. 53)
#import "@local/heartweaver:0.1.0" as hw: level, multiclass, add-hit-point, add-stress
#import "@local/daggerheart-srd:0.1.0": cards, classes, subclasses
#import "../../examples/characters/paneolus/paneolus.typ": paneolus
#hw.character(..paneolus + (vault: (cards.book-of-illiat, cards.book-of-ava), levels: (
  level(2, experience: "A", card: cards.book-of-norai, advancements: (add-hit-point(), add-stress())),
  level(3, card: cards.book-of-korvax, advancements: (add-hit-point(), add-stress())),
  level(4, card: cards.towering-stalk, advancements: (add-hit-point(), add-stress())),
  level(5, experience: "B", card: cards.death-grip, advancements: (multiclass(classes.druid, "Sage", subclasses.warden-of-renewal),)),
)))
