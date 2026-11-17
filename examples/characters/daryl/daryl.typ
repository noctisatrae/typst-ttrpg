// Daryl, a level 1 faerie druid: a real player character used to test the
// character API. Rules and text come from the SRD 2.0.
#import "@local/heartweaver:0.1.0": character
#import "@local/daggerheart-srd:0.1.0": classes, subclasses, ancestries, communities, cards, weapons, armors

#let daryl = character(
  id: "daryl",
  name: "Daryl",
  class: classes.druid,
  subclass: subclasses.warden-of-renewal,
  ancestry: ancestries.faerie,
  community: communities.underborne,
  traits: (agility: -1, strength: 0, finesse: 1, instinct: 2, presence: 0, knowledge: 1),
  experiences: ("Même pas mal!", "Même pas peur!"),
  weapons: (weapons.hand-runes, weapons.grappler),
  armor: armors.leather-armor,
  cards: (cards.vicious-entangle, cards.rune-ward),
  inventory: ("Small Bag (Rocks & Bones)", "Minor Health Potion", "Torch", "50 feet of rope", "Basic supplies"),
  story: (
    background: include "background.typ",
    connections: include "connections.typ",
  ),
)
