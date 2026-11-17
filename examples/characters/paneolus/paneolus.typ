// Paneolus, a level 1 Fungril wizard: a real player character used to
// test the character API. Rules and card text come from the SRD 2.0.
#import "@local/heartweaver:0.1.0": character
#import "@local/daggerheart-srd:0.1.0": classes, subclasses, ancestries, communities, cards, weapons, armors

#let paneolus = character(
  id: "paneolus",
  name: "Paneolus",
  class: classes.wizard,
  subclass: subclasses.school-of-knowledge,
  ancestry: ancestries.fungril,
  community: communities.wildborne,
  traits: (agility: -1, strength: 0, finesse: 0, instinct: 1, presence: 1, knowledge: 2),
  experiences: ("Cours ma belle !!!", "Herbologue"),
  weapons: (weapons.greatstaff,),
  armor: armors.leather-armor,
  cards: (cards.book-of-illiat, cards.book-of-ava, cards.book-of-tyfar),
  inventory: ("Untranslated Book", "Minor Health Potion", "Torch", "50 feet of rope", "Basic supplies"),
  story: (
    background: include "background.typ",
    connections: include "connections.typ",
  ),
)
