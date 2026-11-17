// heartweaver adversaries: construction, constants, extend, rendering, and
// the SRD data package loading through them.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw: adversary, adversary-type, feature-kind, attack-range, damage-type, feature, add, replace
#import "@local/daggerheart-srd:0.1.0": adversaries

#let lackey = adversaries.tier-1.jagged-knife-lackey
#assert.eq(lackey.kind, "adversary")
#assert.eq(lackey.type, adversary-type.minion)
#assert.eq(lackey.thresholds, (major: none, severe: none))
#assert.eq(lackey.attack.direct, false, message: "defaults apply inside nested dictionaries")
#assert.eq(lackey.flags.source.page, 102)

// Formatting matches how the SRD prints values.
#assert.eq(hw.signed(-2), "−2")
#assert.eq(hw.signed(0), "+0")
#assert.eq(hw.format-thresholds((major: none, severe: none)), "None")
#assert.eq(hw.format-thresholds((major: 3, severe: none)), "3/None")
#assert.eq(hw.format-thresholds((major: 7, severe: 14)), "7/14")
#assert.eq(hw.format-damage((damage: "40", direct: true, damage-type: "phy")), "40 direct phy")

// A homebrew Horde, then an extended copy of an SRD adversary.
#let swarm = adversary(
  id: "test-swarm", name: "Test Swarm", tier: 1, type: adversary-type.horde, creatures-per-hp: 3,
  description: "Placeholder.", motives: "Test",
  difficulty: 10, thresholds: (major: 4, severe: 8), hp: 4, stress: 2,
  attack: (modifier: 0, name: "Bites", range: attack-range.melee, damage: "1d6", damage-type: damage-type.physical),
)
#assert.eq(swarm.experiences, ())

#let boss = hw.extend(adversaries.tier-1.jagged-knife-bandit,
  id: "test-bandit-boss", name: "Test Bandit Boss", hp: 7,
  features: (replace("Climber")[Changed.], add(feature("Extra", kind: feature-kind.reaction)[Added.])),
)
#assert.eq(boss.hp, 7)
#assert.eq(boss.features.map(f => f.name), ("Climber", "From Above", "Extra"))
#assert.eq(boss.attack, adversaries.tier-1.jagged-knife-bandit.attack)

// Rendering registers each adversary once.
#show: core.setup
#for a in adversaries.tier-1.values() { hw.statblock(a) }
#hw.statblock(swarm)
#hw.statblock(swarm)
#hw.statblock(boss, register: false)
#hw.attribution(modifications: "Test content only.")
#context assert.eq(core.registered().len(), 6)
