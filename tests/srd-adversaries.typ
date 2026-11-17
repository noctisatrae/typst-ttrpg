// The full SRD 2.0 adversary set loads, matches the SRD's own per-tier
// lists (pp. 95-96), and renders, including its unusual stat blocks.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": adversaries

// Counts of the "Adversaries by Tier" lists on pp. 95-96.
#assert.eq(adversaries.tier-1.len(), 86)
#assert.eq(adversaries.tier-2.len(), 78)
#assert.eq(adversaries.tier-3.len(), 55)
#assert.eq(adversaries.tier-4.len(), 45)

#let all = adversaries.values().map(t => t.values()).flatten()
#assert.eq(all.map(a => a.id).dedup().len(), all.len(), message: "ids are unique across tiers")
#for (tier, entries) in adversaries {
  for a in entries.values() {
    assert.eq("tier-" + str(a.tier), tier, message: a.id + " is filed under its own tier")
    assert(a.flags.source.page >= 97 and a.flags.source.page <= 158, message: a.id + " has an SRD page")
  }
}

// Shapes found only in the full set.
#let armor = adversaries.tier-1.spellbound-armor
#assert("stress" not in armor, message: "Spellbound Armor prints Stress: None (p. 110)")
#let abomination = adversaries.tier-4.outer-realms-abomination
#assert.eq(abomination.attack.modifier, "+2d4", message: "a dice attack modifier (p. 153)")
#assert.eq(hw.signed(abomination.attack.modifier), "+2d4")
#assert.eq(adversaries.tier-1.spellblade.attack.damage-type, "phy/mag")
#assert.eq(adversaries.tier-4.temporal-enforcer.attack.direct, true)

// Every adversary renders.
#show: core.setup.with(theme: hw.book-theme)
#for a in all { hw.statblock(a) }
#context assert.eq(core.registered().len(), all.len())
