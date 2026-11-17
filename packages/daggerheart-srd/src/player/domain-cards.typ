// Domain cards, transcribed from the Daggerheart SRD 2.0 appendix
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
// Text is verbatim except joined line breaks.

#import "@local/heartweaver:0.1.0": domain-card, card-type, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let book-of-ava = domain-card(
  id: "book-of-ava", name: "Book of Ava",
  domain: "Codex", level: 1, type: card-type.grimoire, recall-cost: 2,
  features: (
    feature("Power Push")[Make a Spellcast Roll against a target within Melee range. On a success, they’re knocked back to Far range and take d10+2 magic damage using your Proficiency.],
    feature("Tava’s Armor")[Spend a Hope to give a target you can touch a +1 bonus to their Armor Score until their next rest or you cast Tava’s Armor again.],
    feature("Ice Spike")[Make a Spellcast Roll (12) to summon a large ice spike within Far range. If you use it as a weapon, make the Spellcast Roll against the target’s Difficulty instead. On a success, deal d6 physical damage using your Proficiency.],
  ),
  flags: source(211),
)

#let book-of-illiat = domain-card(
  id: "book-of-illiat", name: "Book of Illiat",
  domain: "Codex", level: 1, type: card-type.grimoire, recall-cost: 2,
  features: (
    feature("Slumber")[Make a Spellcast Roll against a target within Very Close range. On a success, they’re Asleep until they take damage or the GM spends a Fear on their turn to clear this condition.],
    feature("Arcane Barrage")[Once per rest, spend any number of Hope and shoot magical projectiles that strike a target of your choice within Close range. Roll a number of d6s equal to the Hope spent and deal that much magic damage to the target.],
    feature("Telepathy")[Spend a Hope to open a line of mental communication with one target you can see. This connection lasts until your next rest or you cast Telepathy again.],
  ),
  flags: source(211),
)

#let book-of-tyfar = domain-card(
  id: "book-of-tyfar", name: "Book of Tyfar",
  domain: "Codex", level: 1, type: card-type.grimoire, recall-cost: 2,
  features: (
    feature("Wild Flame")[Make a Spellcast Roll against up to three adversaries within Melee range. Targets you succeed against take 2d6 magic damage and must mark a Stress as flames erupt from your hand.],
    feature("Magic Hand")[You conjure a magical hand with the same size and strength as your own within Far range.],
    feature("Mysterious Mist")[Make a Spellcast Roll (13) to cast a temporary thick fog that gathers in a stationary area within Very Close range. The fog heavily obscures this area and everything in it.],
  ),
  flags: source(211),
)
