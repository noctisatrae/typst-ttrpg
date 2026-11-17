// expect: creature "goblin" is registered twice with different content
// expect: fields that differ: hp
#import "@local/ttrpg-core:0.1.0" as core
#import "../support/creature.typ": goblin
#core.register(goblin)
#core.register(goblin + (hp: 5))
