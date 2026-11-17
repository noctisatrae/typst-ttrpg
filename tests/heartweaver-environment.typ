// Environments: SRD data loads and validates, counts match the SRD's own
// list (p. 159), renders in both themes, extend re-validates.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": environments

#let t1 = environments.tier-1

// p. 159 lists 16 Tier 1 environments: 3 Exploration, 5 Social, 4 Traversal, 4 Event.
#assert.eq(t1.len(), 16)
#let count(kind) = t1.values().filter(e => e.type == kind).len()
#assert.eq(count(hw.environment-type.exploration), 3)
#assert.eq(count(hw.environment-type.social), 5)
#assert.eq(count(hw.environment-type.traversal), 4)
#assert.eq(count(hw.environment-type.event), 4)

#let grove = t1.abandoned-grove
#assert.eq(grove.kind, "environment")
#assert.eq(grove.difficulty, 11)
#assert.eq(grove.flags.source.page, 160)
#assert.eq(grove.features.map(f => f.kind), ("Passive", "Action", "Action", "Action"))
#assert(grove.features.first().questions.starts-with("Why did these groups"))
// Events whose Difficulty depends on the adversaries keep the SRD's words.
#assert.eq(t1.ambushed.difficulty, "Special (see “Relative Strength”)")
#assert.eq(hw.environment-summary(grove), "Tier 1 Exploration · Difficulty 11")
#assert.eq(hw.environment-summary(t1.ambushed), "Tier 1 Event")

// Homebrew variant: replace a scalar, drop a feature.
#let overgrown = hw.extend(grove, id: "overgrown-grove", name: "Overgrown Grove",
  difficulty: 12, features: hw.remove("Defiler"))
#assert.eq(overgrown.difficulty, 12)
#assert.eq(overgrown.features.len(), 3)
#assert.eq(overgrown.flags.extends, "abandoned-grove")

#hw.environment-block(grove)
#hw.environment-block(t1.ambushed)
#show: core.setup.with(theme: hw.book-theme)
#hw.environment-block(t1.abandoned-mine)
#hw.environment-block(overgrown)

#context assert("abandoned-grove" in core.registered())
