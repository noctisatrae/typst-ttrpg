// Inskel, a level 1 human ranger in a combat wheelchair: a real player
// character used to test the character API. Rules and text come from the
// SRD 2.0. The Beastbound companion (pp. 20-22) is not modelled yet.
#import "@local/heartweaver:0.1.0": character
#import "@local/daggerheart-srd:0.1.0": classes, subclasses, ancestries, communities, cards, weapons, armors

#let inskel = character(
  id: "inskel",
  name: "Inskel",
  class: classes.ranger,
  subclass: subclasses.beastbound,
  ancestry: ancestries.human,
  community: communities.highborne,
  traits: (agility: 1, strength: -1, finesse: 0, instinct: 1, presence: 2, knowledge: 0),
  experiences: ("J'en veux deux!", "Moi d'abord!"),
  weapons: (weapons.light-frame-wheelchair, weapons.hand-crossbow),
  armor: armors.gambeson-armor,
  cards: (cards.vicious-entangle, cards.gifted-tracker),
  inventory: ("Broken Compass", "Minor Health Potion", "Torch", "50 feet of rope", "Basic supplies"),
  story: (
    background: include "background.typ",
    connections: include "connections.typ",
  ),
)
