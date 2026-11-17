// Kinds are generic: the system orders and titles them, `outline: false`
// kinds stay out of the session sheet, and kinds missing from the system
// still work. Made-up test kinds, not game content.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/ttrpg-script:0.1.0": *
#import "support/creature.typ": goblin

#let trinket = core.entity("trinket", (:), id: "lucky-coin", name: "Lucky Coin")
#let relic = core.entity("relic", (:), id: "old-bell", name: "Old Bell")
#let lore = core.entity("lore", (:), id: "goblin-lore", name: "Goblin Lore")

#let system = (kinds: (
  creature: (section: "Cast", summary: e => [HP #e.hp], render: e => [CREATURE BLOCK #e.name]),
  trinket: (section: "Items", summary: e => [trinket]),
  lore: (section: "Reference", outline: false),
))
#show: setup.with(system: system)

#session-sheet()

#scene("INT.", "Den")
A #mention(relic) hangs above a #intro(goblin) who flips a #mention(trinket).
#mention(lore) explains everything.
#stats(goblin)

#appendix()

// Session sheet groups: system order, outline: false dropped, unknown kinds
// last and titled by their name.
#context {
  let events = query(<ttrpg-script-event>).map(m => m.value)
  let groups = outline-groups(system, events)
  assert.eq(groups.map(g => g.section), ("Cast", "Items", "Relic"))
  assert.eq(groups.first().ids, ("goblin",))
  assert("lore" in events.map(e => e.at("entity-kind", default: none)), message: "outline: false kinds are still recorded")
}

// Every entity gets an appendix entry, including outline: false and unknown
// kinds.
#context for id in ("goblin", "lucky-coin", "old-bell", "goblin-lore") {
  assert.eq(query(label("ttrpg-script-entry:" + id)).len(), 1, message: id)
}

// Appendix sections follow the system order, then unknown kinds.
#assert.eq(kind-order(system, ("relic", "lore", "creature")), ("creature", "lore", "relic"))
#assert.eq(kind-info(system, "relic").section, "Relic")
#assert.eq(kind-info(none, "creature").outline, true)
