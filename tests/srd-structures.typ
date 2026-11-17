// Structures inside SRD features: numbered options and roll-table rows
// become lists after their intro; features that introduce others hold
// them as children (Roc, p. 139; Adonix, p. 155).
#import "@local/daggerheart-srd:0.1.0": adversaries, cards
#import "@local/heartweaver:0.1.0" as hw

#let roc = adversaries.tier-3.roc
#let warden = roc.features.find(f => f.name == "Nest Warden")
#assert.eq(warden.features.map(f => f.name), ("Wrathful", "Electrifying Aura"))
#assert(roc.features.all(f => f.name not in ("Wrathful", "Electrifying Aura")), message: "children are not repeated at the top level")

#let breath = adversaries.tier-4.dragon-mother-mitera.features.find(f => f.name == "Elemental Breath")
#let items = breath.body.children.filter(c => c.func() == enum.item)
#assert.eq(items.map(i => i.number), range(1, 8))

#let gaze = adversaries.tier-4.demon-lord-berzug.features.find(f => f.name == "Gaze into the Abyss")
#assert.eq(gaze.body.children.filter(c => c.func() == list.item).len(), 3)

#assert.eq(cards.forager.text.children.filter(c => c.func() == enum.item).len(), 6)

// Both render, children indented under their parent.
#hw.statblock(roc)
#hw.statblock(adversaries.tier-4.dragon-mother-mitera)
