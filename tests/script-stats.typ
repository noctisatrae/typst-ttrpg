// Stat blocks, open play, scene links and the cast appendix with heartweaver.
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": adversaries
#import "@local/ttrpg-script:0.1.0": *
#import "@local/ttrpg-core:0.1.0": current-theme as core-theme

#let lackey = adversaries.tier-1.jagged-knife-lackey
#show: setup.with(summary: hw.summary, stats: hw.statblock)

#scene("INT.", "Hideout")
A #intro(lackey) waits.
#stats(lackey)
#open-play[Notes.]
#open-play[]
#leads-to("Hideout", "Unwritten Place")
#cast()

#context assert.eq(query(<ttrpg-script-scene>).len(), 1)
#context assert.eq(query(label("ttrpg-script-cast:jagged-knife-lackey")).len(), 1)
#context assert.eq(query(label("ttrpg-script-cast:jagged-knife-lackey")).first().location().page(), 2,
  message: "the cast starts on its own page")

// Stat blocks use their own font list.
#context assert.eq(core-theme().fonts.body.first(), "Geist Mono")
