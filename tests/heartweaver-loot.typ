// Loot: both roll tables per kind load, rolls 1-60 each, render, extend.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": items, consumables

#for (data, kind) in ((items, "item"), (consumables, "consumable")) {
  assert.eq(data.len(), 120)
  for coll in hw.loot-collection.values() {
    let rolls = data.values().filter(e => e.collection == coll).map(e => e.roll)
    assert.eq(rolls, range(1, 61), message: kind + " rolls in " + coll)
  }
  assert(data.values().all(e => e.kind == kind))
}

#let stone = items.valorstone
#assert.eq(stone.roll, 15)
#assert.eq(stone.flags.source.page, 75)
#assert.eq(consumables.minor-health-potion.description, "Clear 1d4 HP.")
#assert.eq(hw.loot-summary(stone), "Item")
#assert.eq(hw.loot-summary(consumables.minor-health-potion), "Consumable")

// No id is shared between items and consumables (the registry is global).
#assert.eq(items.keys().filter(k => k in consumables).len(), 0)

// Homebrew: a stronger potion based on the SRD one.
#let big = hw.extend(consumables.minor-health-potion, id: "big-health-potion",
  name: "Big Health Potion", description: "Clear 2d4 HP.")
#assert.eq(big.kind, "consumable")
#assert.eq(big.roll, 7)

#hw.loot-card(stone)
#hw.loot-card(big)
#show: core.setup.with(theme: hw.book-theme)
#hw.loot-card(consumables.minor-health-potion)
