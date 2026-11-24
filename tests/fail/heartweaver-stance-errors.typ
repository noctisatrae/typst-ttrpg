// expect: character "test-martial-artist" has 2 problems
// expect: `stances`: choose 2 Tier 1 stances at creation (p. 12), got Favored (tier 1), Anchored (tier 2)
// expect: level 2: learn 1 martial stance (p. 12), got 0; use `level(2, stance: stances.<name>)`
#import "@local/heartweaver:0.1.0" as hw: character, level, add-hit-point, add-stress
#import "@local/daggerheart-srd:0.1.0": classes, subclasses, ancestries, communities, cards, stances
#let brawler-cards = cards.values().filter(k => k.domain in classes.brawler.domains and k.level == 1)
#character(
  id: "test-martial-artist", name: "Test Martial Artist",
  class: classes.brawler, subclass: subclasses.martial-artist,
  ancestry: ancestries.human, community: communities.highborne,
  traits: (agility: 2, strength: 1, finesse: 1, instinct: 0, presence: 0, knowledge: -1),
  experiences: ("Street Fighter", "Monk"),
  cards: brawler-cards.slice(0, 2),
  stances: (stances.favored, stances.anchored),
  levels: (level(2, experience: "Bouncer", card: brawler-cards.at(2), advancements: (add-hit-point(), add-stress())),),
)
