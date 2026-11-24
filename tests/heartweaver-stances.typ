// Martial stances (Brawler, Martial Artist, SRD pp. 12-13): the SRD's
// stances and rules, choices at creation and per level, the sheet.
#import "@local/heartweaver:0.1.0" as hw: character, level, add-hit-point, add-stress
#import "@local/daggerheart-srd:0.1.0": classes, subclasses, ancestries, communities, cards, stances, martial-stances

#assert.eq(stances.len(), 16)
#for t in (1, 2, 3, 4) { assert.eq(stances.values().filter(s => s.tier == t).len(), 4) }
#assert.eq((martial-stances.focus, martial-stances.start, martial-stances.per-level), (6, 2, 1))
#assert.eq(martial-stances.rules.map(r => r.name), ("Stances", "Focus", "Shifting into Stances", "Dropping Out of Stances"))
#for s in stances.values() { hw.stance-card(s) }

// A made-up level 2 Martial Artist (test data, not a real character).
#let brawler-cards = cards.values().filter(k => k.domain in classes.brawler.domains)
#let fighter = character(
  id: "test-martial-artist", name: "Test Martial Artist",
  class: classes.brawler, subclass: subclasses.martial-artist,
  ancestry: ancestries.human, community: communities.highborne,
  traits: (agility: 2, strength: 1, finesse: 1, instinct: 0, presence: 0, knowledge: -1),
  experiences: ("Street Fighter", "Monk"),
  cards: brawler-cards.filter(k => k.level == 1).slice(0, 2),
  stances: (stances.favored, stances.reliable),
  levels: (level(2, experience: "Bouncer", card: brawler-cards.filter(k => k.level == 1).at(2),
    advancements: (add-hit-point(), add-stress()), stance: stances.anchored),),
)
#let d = hw.derive(fighter)
#assert.eq(d.stance-rules.focus, 6)
#assert.eq(d.stances.map(k => (k.stance.id, k.level)), (("favored", 1), ("reliable", 1), ("anchored", 2)))
// Stance effects apply only in the active stance: Reliable's +1 is not on the sheet.
#assert.eq(d.attack-bonus, 0)
#hw.sheet(fighter)
