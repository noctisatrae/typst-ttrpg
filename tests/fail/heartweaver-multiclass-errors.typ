// expect: level 5: multiclass: domain must be one of Druid's, "Sage" or "Arcana" (p. 54), got "Codex"
// expect: level 5: multiclass: subclass School of Knowledge belongs to "wizard", not "druid"
// expect: level 6: no upgraded subclass in tier 3, where you multiclassed (level 5); one crosses out the other (p. 53)
// expect: level 6: you have two subclasses; name the one to upgrade
#import "@local/heartweaver:0.1.0" as hw: level, multiclass, upgrade-subclass, add-hit-point, add-stress, increase-evasion
#import "@local/daggerheart-srd:0.1.0": cards, classes, subclasses
#import "../../examples/characters/paneolus/paneolus.typ": paneolus
#hw.character(..paneolus + (levels: (
  level(2, experience: "A", card: cards.book-of-sitil, advancements: (add-hit-point(), add-stress())),
  level(3, card: cards.book-of-korvax, advancements: (add-hit-point(), add-stress())),
  level(4, card: cards.book-of-exota, advancements: (add-hit-point(), add-stress())),
  level(5, experience: "B", card: cards.teleport, advancements: (multiclass(classes.druid, "Codex", subclasses.school-of-knowledge),)),
  level(6, card: cards.banish, advancements: (upgrade-subclass(), increase-evasion())),
)))
