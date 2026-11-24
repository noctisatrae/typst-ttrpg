// Multiclassing (SRD pp. 53-54): Paneolus, a School of Knowledge Wizard,
// takes up the Druid at level 5 (Sage domain, Warden of Renewal) and plays
// on to level 9. Checks the class features (all of them, as on the
// official multiclass sheets, not only one), both subclasses' cards, both Spellcast traits, multiclass
// domain cards at half level, and the sheet.
#import "@local/heartweaver:0.1.0" as hw: level, multiclass, upgrade-subclass, add-hit-point, add-stress, increase-evasion, increase-traits, increase-proficiency
#import "@local/daggerheart-srd:0.1.0": cards, classes, subclasses
#import "../examples/characters/paneolus/paneolus.typ": paneolus

#let druid-wizard = hw.character(..paneolus + (
  id: "paneolus-multiclass",
  vault: (cards.book-of-illiat, cards.book-of-ava, cards.book-of-tyfar, cards.book-of-sitil, cards.book-of-korvax, cards.final-words, cards.book-of-exota),
  levels: (
    level(2, experience: "Archivist", card: cards.book-of-sitil, advancements: (increase-traits("Agility", "Strength"), add-hit-point())),
    // Accomplished (specialization) grants a card at the level it is taken.
    level(3, card: (cards.book-of-korvax, cards.final-words), advancements: (upgrade-subclass(), add-stress())),
    level(4, card: cards.book-of-exota, advancements: (increase-evasion(), add-hit-point())),
    // A Sage card at level 5: at or below half the level, rounded up (3).
    level(5, experience: "Woodwise", card: cards.towering-stalk,
      advancements: (multiclass(classes.druid, "Sage", subclasses.warden-of-renewal),)),
    level(6, card: cards.teleport, advancements: (increase-traits("Instinct", "Presence"), add-stress())),
    level(7, card: cards.healing-field, advancements: (add-hit-point(), increase-evasion())),
    // Tier 4: an upgrade again, naming which subclass.
    level(8, experience: "Old Roots", card: cards.banish,
      advancements: (upgrade-subclass(subclasses.warden-of-renewal), increase-traits("Agility", "Strength"))),
    level(9, card: cards.manifest-wall, advancements: (increase-proficiency(),)),
  ),
))
#let d = hw.derive(druid-wizard)
#assert.eq(d.level, 9)
#assert.eq((d.multiclass.class.id, d.multiclass.domain, d.multiclass.level), ("druid", "Sage", 5))
#assert.eq(d.multiclass.features.map(f => f.name), ("Beastform", "Wildtouch"))
#assert.eq((d.subclass-cards, d.multiclass.subclass-cards), (2, 2))
#let names = d.features.map(((_, f)) => f.name)
#assert("Beastform" in names and "Wildtouch" in names, message: "every class feature")
#assert("Regenerative Reach" in names and "Defender" not in names, message: "Warden of Renewal: foundation + specialization")
#assert("Accomplished" in names and "Brilliant" not in names, message: "School of Knowledge: foundation + specialization")
#assert("Unstoppable" not in names)
// Not the Druid's Hope feature: the official sheet prints class features only.
#assert(d.features.filter(((src, _)) => src == "Druid (Hope)").len() == 0)
// Beastform comes with its forms (daggerheart-srd binds them).
#assert(d.beastforms.len() > 0)
// Two Spellcast traits to choose from; the sheet counts the higher one.
#assert.eq(d.spellcast-traits, ("Knowledge", "Instinct"))
#assert.eq(d.spellcast-trait, "Knowledge")
// The main class still sets Evasion and HP.
#assert.eq(d.evasion.parts.first(), ("Wizard", classes.wizard.evasion))

#hw.sheet(druid-wizard)
