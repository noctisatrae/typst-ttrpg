#import "@local/ttrpg-core:0.1.0" as core
#import "support/creature.typ": goblin, extend

#let boss = extend(goblin, id: "goblin-boss", hp: 6)

#core.register(goblin)
#core.register(goblin) // identical: counts once
#core.register(boss)

#context assert.eq(core.registered().keys(), ("goblin", "goblin-boss"))
#context assert.eq(core.registered().at("goblin-boss").hp, 6)
