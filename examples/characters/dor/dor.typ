// Dor, a level 1 simiah rogue: a real player character used to test the
// character API. Rules and text come from the SRD 2.0.
#import "@local/heartweaver:0.1.0": character
#import "@local/daggerheart-srd:0.1.0": classes, subclasses, ancestries, communities, cards, weapons, armors

#let dor = character(
  id: "dor",
  name: "Dor",
  class: classes.rogue,
  subclass: subclasses.nightwalker,
  ancestry: ancestries.simiah,
  community: communities.ridgeborne,
  traits: (agility: 2, strength: -1, finesse: 0, instinct: 1, presence: 1, knowledge: 0),
  experiences: ("Spy", "Acolyte"),
  weapons: (weapons.dagger, weapons.small-dagger),
  armor: armors.gambeson-armor,
  cards: (cards.pick-and-pull, cards.uncanny-disguise),
  inventory: ("Grappling Hook", "Minor Health Potion", "Torch", "50 feet of rope", "Basic supplies"),
  story: (
    background: include "background.typ",
    connections: include "connections.typ",
  ),
)
