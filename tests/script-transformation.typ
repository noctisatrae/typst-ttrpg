// A homebrew transformation in the screenplay theme: the shape of an
// "undead" card with a track, write-in lines and six questions, mentioned
// in a scene, in the appendix and on a character sheet. Made-up text for
// checking the renderer, not game content.
#import "@local/heartweaver:0.1.0" as hw: transformation, feature
#import "@local/daggerheart-srd:0.1.0": transformations
#import "@local/ttrpg-script:0.1.0": *
#import "../examples/characters/paneolus/paneolus.typ": paneolus
#show: setup.with(system: hw.system)

#let undead = transformation(
  id: "test-aware-undead", name: "Test Aware Undead",
  description: [A made-up card for this test.],
  features: (
    feature("Hollowing", replaces: "Stress overflow into HP (p. 50)")[When you must mark a Stress but can't, mark a Hollowing box instead of a Hit Point. When you mark the third box, you go hollow. At the end of a long rest, clear a box.],
    feature("Anchor")[Write the goal that keeps you yourself. When you act toward it at real cost, clear a Hollowing box.],
    feature("Unending", replaces: [the veil in Blaze of Glory and Risk It All (p. 53)])[When a death move would take you through the veil, you go hollow instead.],
  ),
  tracks: ((name: "Hollowing", boxes: 3),),
  write-ins: ((label: "Anchor", lines: 2),),
  questions: (
    "Question one?", "Question two?", "Question three?",
    "Question four?", "Question five?", "Question six?",
  ),
)

#scene("EXT.", "Graveyard")
The dead walk: #mention(undead). The vampire's card: #mention(transformations.vampire).

#appendix()

#pagebreak()
#hw.sheet(hw.character(..paneolus + (id: "undead-paneolus",
  transformation: (undead, transformations.vampire), transformation-limit: 2)), state: "boxes")

// Both cards land in the appendix under the system's section.
#context {
  let events = query(<ttrpg-script-event>).map(m => m.value)
  assert("test-aware-undead" in events.map(e => e.at("id", default: none)))
}
