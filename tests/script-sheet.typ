// Music cues and the session sheet group events by scene.
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": adversaries
#import "@local/ttrpg-script:0.1.0": *

#let lackey = adversaries.tier-1.jagged-knife-lackey
#show: setup.with(system: hw.system)

#session-sheet()

#scene("INT.", "Hideout")
#music[quiet dread]
A #intro(lackey) waits.
#music(track: "Theme", by: "Someone", url: "https://example.com")[spotlight]
#leads-to("Roof")

#scene("EXT.", "Roof")
#say(lackey)[Up here!]
#music(track: "No Link")

#context {
  let events = query(<ttrpg-script-event>).map(m => m.value)
  let in-scene(name, kind) = events.filter(e => e.scene == name and e.kind == kind)
  assert.eq(in-scene("Hideout", "music").len(), 2)
  assert.eq(in-scene("Hideout", "appearance").map(e => e.id), ("jagged-knife-lackey",))
  assert.eq(in-scene("Hideout", "leads-to").first().scenes, ("Roof",))
  assert.eq(in-scene("Roof", "appearance").len(), 1)
  assert.eq(in-scene("Roof", "music").first().track, "No Link")
}
