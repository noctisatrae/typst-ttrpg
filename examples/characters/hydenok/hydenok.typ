// Hydenok Mpiady Sabatra, a level 1 infernis rogue: a real player
// character used to test the character API. Rules and text come from the
// SRD 2.0.
#import "@local/heartweaver:0.1.0": character
#import "@local/daggerheart-srd:0.1.0": classes, subclasses, ancestries, communities, cards, weapons, armors

#let hydenok = character(
  id: "hydenok",
  name: "Hydenok Mpiady Sabatra",
  class: classes.rogue,
  subclass: subclasses.nightwalker,
  ancestry: ancestries.infernis,
  community: communities.wanderborne,
  traits: (agility: 1, strength: 0, finesse: 2, instinct: 1, presence: -1, knowledge: 0),
  experiences: ("See me?", "Party Pooper"),
  weapons: (weapons.returning-blade, weapons.small-dagger),
  armor: armors.gambeson-armor,
  cards: (cards.uncanny-disguise, cards.enrapture),
  inventory: ("Grappling Hook", "Minor Health Potion", "Torch", "50 feet of rope", "Basic supplies"),
  story: (
    background: include "background.typ",
    connections: include "connections.typ",
  ),
)
