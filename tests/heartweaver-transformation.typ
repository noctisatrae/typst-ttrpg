// Transformations (SRD pp. 42-45): every SRD card renders, a homebrew card
// prints its tracks, write-ins and `replaces` notes, and a character's
// transformation counts in derivation and prints on the sheet.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw: transformation, feature
#import "@local/daggerheart-srd:0.1.0": transformations
#import "../examples/characters/paneolus/paneolus.typ": paneolus

#assert.eq(transformations.keys(), ("demigod", "ghost", "reanimated", "shapeshifter", "vampire", "werewolf"))
#for t in transformations.values() {
  assert.eq(t.features.len(), 2, message: t.name + ": two features")
  assert.eq(t.questions.len(), 6, message: t.name + ": six questions")
  hw.transformation-card(t)
}
// The Vampire's tokens: "You can hold up to 6 tokens at a time" (p. 45).
#assert.eq(transformations.vampire.tracks, ((name: "Tokens", boxes: 6),))

// Homebrew: a track, write-in lines, a `replaces` note and
// questions written as content.
#let undead = transformation(
  id: "test-undead", name: "Test Undead",
  features: (
    feature("Hollowing", replaces: "Stress overflow into HP (p. 50)")[When you must mark a Stress but can't, mark a Hollowing box instead.],
    feature("Anchor")[Write the goal that keeps you yourself.],
  ),
  tracks: ((name: "Hollowing", boxes: 3),),
  write-ins: ((label: "Anchor", lines: 2),),
  questions: ([What is your *anchor*?], "Who did you lose?"),
)
#hw.transformation-card(undead)

// On a character: Demigod's "Gifted" adds +1 to attack and Spellcast Rolls
// (effects.typ); the card prints on the sheet with the heritage.
#let base = hw.derive(paneolus)
#let demi = hw.character(..paneolus + (id: "demigod-paneolus", transformation: transformations.demigod))
#let d = hw.derive(demi)
#assert.eq(d.attacks.first().modifier, base.attacks.first().modifier + 1)
#assert.eq(d.spellcast-bonus.value, 1)
#assert.eq(d.loadout.len(), base.loadout.len(), message: "transformations don't count toward the loadout (p. 42)")
#hw.sheet(demi)

// Two cards need an explicit house rule (Red Mist: undead, then grafted).
#let both = hw.character(..paneolus + (id: "undead-vampire-paneolus", transformation: (undead, transformations.vampire), transformation-limit: 2))
#assert.eq(both.transformation.map(t => t.id), ("test-undead", "vampire"))
#hw.sheet(both, state: "boxes")
