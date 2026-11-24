// Factions (SRD p. 190) in the screenplay theme: two made-up factions
// that name each other, objectives with and without countdowns, mentioned
// in a scene, on the session sheet and in the appendix. Made-up text for
// checking the renderer, not game content.
#import "@local/heartweaver:0.1.0" as hw: faction
#import "@local/ttrpg-script:0.1.0": *
#show: setup.with(system: hw.system)

#let crown = faction(
  id: "test-iron-crown", name: "Test Iron Crown",
  description: [A made-up faction for this test.],
  relationships: ((with: "Test Lantern Guild", rank: -2), (with: "The Docks", rank: 0)),
  assets: ("A standing army", "The old treasury"),
  problems: ("An heir nobody trusts",),
  major-objectives: ((goal: "Annex the river towns", countdown: 10),),
  minor-objectives: ((goal: "Repair the north wall", countdown: 4), (goal: "Crown a new champion", countdown: 6), "Tax the guilds"),
)
#let guild = faction(
  id: "test-lantern-guild", name: "Test Lantern Guild",
  relationships: ((with: crown, rank: -2),),
  assets: ([Every *lamplighter* in the city],),
  problems: ("Broke since the fire",),
  minor-objectives: ("Hold the midwinter festival",),
)

#assert.eq(hw.relationship-name(-2), "Opposed")
#assert.eq(hw.relationship-name(3), "Close Allies")
#assert.eq(guild.relationships.first().with.name, "Test Iron Crown")

#session-sheet()

#scene("INT.", "Throne room")

The Crown's envoy waits: #mention(crown). The guild sends a lamplighter: #mention(guild).

#appendix()
