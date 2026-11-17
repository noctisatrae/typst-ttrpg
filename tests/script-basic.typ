// Every script element compiles; entities given to intro/say are registered
// once, plain-string names are not.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/ttrpg-script:0.1.0": *
#import "support/creature.typ": goblin

#show: setup.with(summary: e => [HP #e.hp])

#scene("INT.", "Cave", "Day")
A #intro(goblin) waits. A #intro("Rat") squeaks.
#say(goblin, paren: "quietly")[Hello.]
#say(goblin)[Again.]
#say("Rat")[Squeak.]
#leads-to("The Tunnel")
#transition("Cut to:")
#cast()

#context assert.eq(core.registered().keys(), ("goblin",))
