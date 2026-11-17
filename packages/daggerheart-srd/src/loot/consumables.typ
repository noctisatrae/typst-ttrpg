// Consumables, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Extracted with scripts/srd (loot.py, emit.py) and cross-checked against
// the SRD text with checkdata.py. Text is verbatim except: line breaks
// joined; the SRD's inline emphasis is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": consumable, loot-collection

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let stride-potion = consumable(
  id: "stride-potion",
  name: "Stride Potion",
  collection: loot-collection.core-set,
  roll: 1,
  description: "You gain a +1 bonus to your next Agility Roll.",
  flags: source(80),
)

#let bolster-potion = consumable(
  id: "bolster-potion",
  name: "Bolster Potion",
  collection: loot-collection.core-set,
  roll: 2,
  description: "You gain a +1 bonus to your next Strength Roll.",
  flags: source(80),
)

#let control-potion = consumable(
  id: "control-potion",
  name: "Control Potion",
  collection: loot-collection.core-set,
  roll: 3,
  description: "You gain a +1 bonus to your next Finesse Roll.",
  flags: source(80),
)

#let attune-potion = consumable(
  id: "attune-potion",
  name: "Attune Potion",
  collection: loot-collection.core-set,
  roll: 4,
  description: "You gain a +1 bonus to your next Instinct Roll.",
  flags: source(80),
)

#let charm-potion = consumable(
  id: "charm-potion",
  name: "Charm Potion",
  collection: loot-collection.core-set,
  roll: 5,
  description: "You gain a +1 bonus to your next Presence Roll.",
  flags: source(80),
)

#let enlighten-potion = consumable(
  id: "enlighten-potion",
  name: "Enlighten Potion",
  collection: loot-collection.core-set,
  roll: 6,
  description: "You gain a +1 bonus to your next Knowledge Roll.",
  flags: source(80),
)

#let minor-health-potion = consumable(
  id: "minor-health-potion",
  name: "Minor Health Potion",
  collection: loot-collection.core-set,
  roll: 7,
  description: "Clear 1d4 HP.",
  flags: source(80),
)

#let minor-stamina-potion = consumable(
  id: "minor-stamina-potion",
  name: "Minor Stamina Potion",
  collection: loot-collection.core-set,
  roll: 8,
  description: "Clear 1d4 Stress.",
  flags: source(80),
)

#let grindletooth-venom = consumable(
  id: "grindletooth-venom",
  name: "Grindletooth Venom",
  collection: loot-collection.core-set,
  roll: 9,
  description: "You can apply this venom to a weapon that deals physical damage to add a d6 to your next damage roll with that weapon.",
  flags: source(80),
)

#let varik-leaves = consumable(
  id: "varik-leaves",
  name: "Varik Leaves",
  collection: loot-collection.core-set,
  roll: 10,
  description: "You can eat these paired leaves to immediately gain 2 Hope.",
  flags: source(80),
)

#let vial-of-moondrip = consumable(
  id: "vial-of-moondrip",
  name: "Vial of Moondrip",
  collection: loot-collection.core-set,
  roll: 11,
  description: "When you drink the contents of this vial, you can see in total darkness until your next rest.",
  flags: source(80),
)

#let unstable-arcane-shard = consumable(
  id: "unstable-arcane-shard",
  name: "Unstable Arcane Shard",
  collection: loot-collection.core-set,
  roll: 12,
  description: "You can make a Finesse Roll to throw this shard at a group of adversaries within Far range. Targets you succeed against take 1d20 magic damage.",
  flags: source(80),
)

#let potion-of-stability = consumable(
  id: "potion-of-stability",
  name: "Potion of Stability",
  collection: loot-collection.core-set,
  roll: 13,
  description: "You can drink this potion to choose one additional downtime move.",
  flags: source(80),
)

#let improved-grindletooth-venom = consumable(
  id: "improved-grindletooth-venom",
  name: "Improved Grindletooth Venom",
  collection: loot-collection.core-set,
  roll: 14,
  description: "You can apply this venom to a weapon that deals physical damage to add a d8 to your next damage roll with that weapon.",
  flags: source(80),
)

#let morphing-clay = consumable(
  id: "morphing-clay",
  name: "Morphing Clay",
  collection: loot-collection.core-set,
  roll: 15,
  description: "You can spend a Hope to use this clay, altering your face enough to make you unrecognizable until your next rest.",
  flags: source(80),
)

#let vial-of-darksmoke = consumable(
  id: "vial-of-darksmoke",
  name: "Vial of Darksmoke",
  collection: loot-collection.core-set,
  roll: 16,
  description: "When an adversary attacks you, use this vial and roll a number of d6s equal to your Agility. Add the highest result to your Evasion against the attack.",
  flags: source(80),
)

#let jumping-root = consumable(
  id: "jumping-root",
  name: "Jumping Root",
  collection: loot-collection.core-set,
  roll: 17,
  description: "Eat this root to leap up to Far range once without needing to roll.",
  flags: source(80),
)

#let snap-powder = consumable(
  id: "snap-powder",
  name: "Snap Powder",
  collection: loot-collection.core-set,
  roll: 18,
  description: "Mark a Stress and clear a HP.",
  flags: source(80),
)

#let health-potion = consumable(
  id: "health-potion",
  name: "Health Potion",
  collection: loot-collection.core-set,
  roll: 19,
  description: "Clear 1d4+1 HP.",
  flags: source(80),
)

#let stamina-potion = consumable(
  id: "stamina-potion",
  name: "Stamina Potion",
  collection: loot-collection.core-set,
  roll: 20,
  description: "Clear 1d4+1 Stress.",
  flags: source(80),
)

#let armor-stitcher = consumable(
  id: "armor-stitcher",
  name: "Armor Stitcher",
  collection: loot-collection.core-set,
  roll: 21,
  description: "You can use this stitcher to spend any number of Hope and clear that many Armor Slots.",
  flags: source(80),
)

#let gill-salve = consumable(
  id: "gill-salve",
  name: "Gill Salve",
  collection: loot-collection.core-set,
  roll: 22,
  description: "You can apply this salve to your neck to breathe underwater for a number of minutes equal to your level.",
  flags: source(80),
)

#let replication-parchment = consumable(
  id: "replication-parchment",
  name: "Replication Parchment",
  collection: loot-collection.core-set,
  roll: 23,
  description: "By touching this piece of parchment to another, you can perfectly copy the second parchment’s contents. Once used, this parchment becomes mundane paper.",
  flags: source(80),
)

#let improved-arcane-shard = consumable(
  id: "improved-arcane-shard",
  name: "Improved Arcane Shard",
  collection: loot-collection.core-set,
  roll: 24,
  description: "You can make a Finesse Roll to throw this shard at a group of adversaries within Far range. Targets you succeed against take 2d20 magic damage.",
  flags: source(80),
)

#let major-stride-potion = consumable(
  id: "major-stride-potion",
  name: "Major Stride Potion",
  collection: loot-collection.core-set,
  roll: 25,
  description: "You gain a +1 bonus to your Agility until your next rest.",
  flags: source(80),
)

#let major-bolster-potion = consumable(
  id: "major-bolster-potion",
  name: "Major Bolster Potion",
  collection: loot-collection.core-set,
  roll: 26,
  description: "You gain a +1 bonus to your Strength until your next rest.",
  flags: source(80),
)

#let major-control-potion = consumable(
  id: "major-control-potion",
  name: "Major Control Potion",
  collection: loot-collection.core-set,
  roll: 27,
  description: "You gain a +1 bonus to your Finesse until your next rest.",
  flags: source(80),
)

#let major-attune-potion = consumable(
  id: "major-attune-potion",
  name: "Major Attune Potion",
  collection: loot-collection.core-set,
  roll: 28,
  description: "You gain a +1 bonus to your Instinct until your next rest.",
  flags: source(80),
)

#let major-charm-potion = consumable(
  id: "major-charm-potion",
  name: "Major Charm Potion",
  collection: loot-collection.core-set,
  roll: 29,
  description: "You gain a +1 bonus to your Presence until your next rest.",
  flags: source(80),
)

#let major-enlighten-potion = consumable(
  id: "major-enlighten-potion",
  name: "Major Enlighten Potion",
  collection: loot-collection.core-set,
  roll: 30,
  description: "You gain a +1 bonus to your Knowledge until your next rest.",
  flags: source(80),
)

#let blood-of-the-yorgi = consumable(
  id: "blood-of-the-yorgi",
  name: "Blood of the Yorgi",
  collection: loot-collection.core-set,
  roll: 31,
  description: "You can drink this blood to disappear from where you are and immediately reappear at a point you can see within Very Far range.",
  flags: source(81),
)

#let homets-secret-potion = consumable(
  id: "homets-secret-potion",
  name: "Homet’s Secret Potion",
  collection: loot-collection.core-set,
  roll: 32,
  description: "After drinking this potion, the next successful attack you make critically succeeds.",
  flags: source(81),
)

#let redthorn-saliva = consumable(
  id: "redthorn-saliva",
  name: "Redthorn Saliva",
  collection: loot-collection.core-set,
  roll: 33,
  description: "You can apply this saliva to a weapon that deals physical damage to add a d12 to your next damage roll with that weapon.",
  flags: source(81),
)

#let channelstone = consumable(
  id: "channelstone",
  name: "Channelstone",
  collection: loot-collection.core-set,
  roll: 34,
  description: "You can use this stone to take a spell or grimoire from your vault, use it once, and return it to your vault.",
  flags: source(81),
)

#let mythic-dust = consumable(
  id: "mythic-dust",
  name: "Mythic Dust",
  collection: loot-collection.core-set,
  roll: 35,
  description: "You can apply this dust to a weapon that deals magic damage to add a d12 to your next damage roll with that weapon.",
  flags: source(81),
)

#let acidpaste = consumable(
  id: "acidpaste",
  name: "Acidpaste",
  collection: loot-collection.core-set,
  roll: 36,
  description: "This paste eats away walls and other surfaces in bright flashes.",
  flags: source(81),
)

#let hopehold-flare = consumable(
  id: "hopehold-flare",
  name: "Hopehold Flare",
  collection: loot-collection.core-set,
  roll: 37,
  description: "When you use this flare, allies within Close range roll a d6 when they spend a Hope. On a result of 6, they gain the effect of that Hope without spending it. The flare lasts until the end of the scene.",
  flags: source(81),
)

#let major-arcane-shard = consumable(
  id: "major-arcane-shard",
  name: "Major Arcane Shard",
  collection: loot-collection.core-set,
  roll: 38,
  description: "You can make a Finesse Roll to throw this shard at a group of adversaries within Far range. Targets you succeed against take 4d20 magic damage.",
  flags: source(81),
)

#let featherbone = consumable(
  id: "featherbone",
  name: "Featherbone",
  collection: loot-collection.core-set,
  roll: 39,
  description: "You can use this bone to control your falling speed for a number of minutes equal to your level.",
  flags: source(81),
)

#let circle-of-the-void = consumable(
  id: "circle-of-the-void",
  name: "Circle of the Void",
  collection: loot-collection.core-set,
  roll: 40,
  description: "Mark a Stress to create a void that extends up to Far range. No magic can be cast inside the void, and creatures within the void are immune to magic damage.",
  flags: source(81),
)

#let sun-tree-sap = consumable(
  id: "sun-tree-sap",
  name: "Sun Tree Sap",
  collection: loot-collection.core-set,
  roll: 41,
  description: "Consume this sap to roll a d6. On a result of 5–6, clear 2 HP. On a result of 2–4, clear 3 Stress. On a result of 1, see through the veil of death and return changed, gaining one scar.",
  flags: source(81),
)

#let dripfang-poison = consumable(
  id: "dripfang-poison",
  name: "Dripfang Poison",
  collection: loot-collection.core-set,
  roll: 42,
  description: "A creature who consumes this poison takes 8d10 direct magic damage.",
  flags: source(81),
)

#let major-health-potion = consumable(
  id: "major-health-potion",
  name: "Major Health Potion",
  collection: loot-collection.core-set,
  roll: 43,
  description: "Clear 1d4+2 HP.",
  flags: source(81),
)

#let major-stamina-potion = consumable(
  id: "major-stamina-potion",
  name: "Major Stamina Potion",
  collection: loot-collection.core-set,
  roll: 44,
  description: "Clear 1d4+2 Stress.",
  flags: source(81),
)

#let ogre-musk = consumable(
  id: "ogre-musk",
  name: "Ogre Musk",
  collection: loot-collection.core-set,
  roll: 45,
  description: "You can use this musk to prevent anyone from tracking you by mundane or magical means until your next rest.",
  flags: source(81),
)

#let wingsprout = consumable(
  id: "wingsprout",
  name: "Wingsprout",
  collection: loot-collection.core-set,
  roll: 46,
  description: "You gain magic wings that allow you to fly for a number of minutes equal to your level.",
  flags: source(81),
)

#let jar-of-lost-voices = consumable(
  id: "jar-of-lost-voices",
  name: "Jar of Lost Voices",
  collection: loot-collection.core-set,
  roll: 47,
  description: "You can open this jar to release a deafening echo of voices for a number of minutes equal to your Instinct. Creatures within Far range unprepared for the sound take 6d8 magic damage.",
  flags: source(81),
)

#let dragonbloom-tea = consumable(
  id: "dragonbloom-tea",
  name: "Dragonbloom Tea",
  collection: loot-collection.core-set,
  roll: 48,
  description: "You can drink this tea to unleash a fiery breath attack. Make an Instinct Roll against all adversaries in front of you within Close range. Targets you succeed against take d20 physical damage using your Proficiency.",
  flags: source(81),
)

#let bridge-seed = consumable(
  id: "bridge-seed",
  name: "Bridge Seed",
  collection: loot-collection.core-set,
  roll: 49,
  description: "Thick vines grow from your location to a point of your choice within Far range, allowing you to climb up or across them. The vines dissipate on your next short rest.",
  flags: source(81),
)

#let sleeping-sap = consumable(
  id: "sleeping-sap",
  name: "Sleeping Sap",
  collection: loot-collection.core-set,
  roll: 50,
  description: "You can drink this potion to fall asleep for a full night’s rest. You clear all Stress upon waking.",
  flags: source(81),
)

#let feast-of-xuria = consumable(
  id: "feast-of-xuria",
  name: "Feast of Xuria",
  collection: loot-collection.core-set,
  roll: 51,
  description: "You can eat this meal to clear all HP and Stress and gain 1d4 Hope.",
  flags: source(81),
)

#let bonding-honey = consumable(
  id: "bonding-honey",
  name: "Bonding Honey",
  collection: loot-collection.core-set,
  roll: 52,
  description: "This honey can be used to glue two objects together permanently.",
  flags: source(81),
)

#let shrinking-potion = consumable(
  id: "shrinking-potion",
  name: "Shrinking Potion",
  collection: loot-collection.core-set,
  roll: 53,
  description: "You can drink this potion to halve your size until you choose to drop this form or your next rest. While in this form, you have a +2 bonus to Agility and a−1 penalty to your Proficiency.",
  flags: source(81),
)

#let growing-potion = consumable(
  id: "growing-potion",
  name: "Growing Potion",
  collection: loot-collection.core-set,
  roll: 54,
  description: "You can drink this potion to double your size until you choose to drop this form or your next rest. While in this form, you have a +2 bonus to Strength and a+1 bonus to your Proficiency.",
  flags: source(81),
)

#let knowledge-stone = consumable(
  id: "knowledge-stone",
  name: "Knowledge Stone",
  collection: loot-collection.core-set,
  roll: 55,
  description: "If you die while holding this stone, an ally can take a card from your loadout to place in their loadout or vault. After they take this knowledge, the stone crumbles.",
  flags: source(81),
)

#let sweet-moss = consumable(
  id: "sweet-moss",
  name: "Sweet Moss",
  collection: loot-collection.core-set,
  roll: 56,
  description: "You can consume this moss during a rest to clear 1d10 HP or 1d10 Stress.",
  flags: source(81),
)

#let blinding-orb = consumable(
  id: "blinding-orb",
  name: "Blinding Orb",
  collection: loot-collection.core-set,
  roll: 57,
  description: "You can activate this orb to create a flash of bright light. All targets within Close range become Vulnerable until they mark HP.",
  flags: source(81),
)

#let death-tea = consumable(
  id: "death-tea",
  name: "Death Tea",
  collection: loot-collection.core-set,
  roll: 58,
  description: "After you drink this tea, you instantly kill your target when you critically succeed on an attack. If you don’t critically succeed on an attack before your next long rest, you die.",
  flags: source(81),
)

#let mirror-of-marigold = consumable(
  id: "mirror-of-marigold",
  name: "Mirror of Marigold",
  collection: loot-collection.core-set,
  roll: 59,
  description: "When you take damage, you can spend a Hope to negate that damage, after which the mirror shatters.",
  flags: source(81),
)

#let stardrop = consumable(
  id: "stardrop",
  name: "Stardrop",
  collection: loot-collection.core-set,
  roll: 60,
  description: "You can use this stardrop to summon a hailstorm of comets that deals 8d20 physical damage to all targets within Very Far range.",
  flags: source(81),
)

#let warding-candle = consumable(
  id: "warding-candle",
  name: "Warding Candle",
  collection: loot-collection.hope-and-fear,
  roll: 1,
  description: "You can light this candle to fill an area within Close range with a halo of light. A creature outside the halo can’t enter it if they have ill intent toward a creature within it. The candle burns for an hour.",
  flags: source(82),
)

#let iridian-dust = consumable(
  id: "iridian-dust",
  name: "Iridian Dust",
  collection: loot-collection.hope-and-fear,
  roll: 2,
  description: "This multicolored powder sticks to everything and prevents creatures covered in it from becoming Hidden.",
  flags: source(82),
)

#let verglasian-seed = consumable(
  id: "verglasian-seed",
  name: "Verglasian Seed",
  collection: loot-collection.hope-and-fear,
  roll: 3,
  description: "You can use this ice shard to instantly freeze an area of water up to Close range.",
  flags: source(82),
)

#let cupbearers-bezoar = consumable(
  id: "cupbearers-bezoar",
  name: "Cupbearer’s Bezoar",
  collection: loot-collection.hope-and-fear,
  roll: 4,
  description: "You can swallow this bezoar to become immune to poisons until your next long rest.",
  flags: source(82),
)

#let mossmantle-potion = consumable(
  id: "mossmantle-potion",
  name: "Mossmantle Potion",
  collection: loot-collection.hope-and-fear,
  roll: 5,
  description: "You can drink this tea to perfectly blend into natural environments until your next rest.",
  flags: source(82),
)

#let lyrebird-lozenge = consumable(
  id: "lyrebird-lozenge",
  name: "Lyrebird Lozenge",
  collection: loot-collection.hope-and-fear,
  roll: 6,
  description: "You can dissolve this lozenge in your mouth to perfectly mimic any voice you’ve heard until the end of the scene.",
  flags: source(82),
)

#let vial-of-featherfall = consumable(
  id: "vial-of-featherfall",
  name: "Vial of Featherfall",
  collection: loot-collection.hope-and-fear,
  roll: 7,
  description: "You can drink this potion to ignore damage from falling for the next 10 minutes.",
  flags: source(82),
)

#let chimeric-saliva = consumable(
  id: "chimeric-saliva",
  name: "Chimeric Saliva",
  collection: loot-collection.hope-and-fear,
  roll: 8,
  description: "You can apply this saliva to a weapon that deals physical damage to change its damage type to magic until your next rest.",
  flags: source(82),
)

#let packet-of-space-dust = consumable(
  id: "packet-of-space-dust",
  name: "Packet of Space Dust",
  collection: loot-collection.hope-and-fear,
  roll: 9,
  description: "This dust causes anything it covers to become lighter than air. One packet contains enough dust to cover the contents of a picnic basket, and the effects last for an hour.",
  flags: source(82),
)

#let pipeweed = consumable(
  id: "pipeweed",
  name: "Pipeweed",
  collection: loot-collection.hope-and-fear,
  roll: 10,
  description: "When you choose the Clear Stress downtime move during a short rest, you can smoke this non-intoxicating leaf to clear an additional Stress. Any other PCs who chose the Clear Stress downtime move also gain this benefit.",
  flags: source(82),
)

#let deathseers-powder = consumable(
  id: "deathseers-powder",
  name: "Deathseer’s Powder",
  collection: loot-collection.hope-and-fear,
  roll: 11,
  description: "You can sprinkle this powder over a recently deceased corpse to conjure a spectral reprise of their final minute of life.",
  flags: source(82),
)

#let slayers-salt = consumable(
  id: "slayers-salt",
  name: "Slayer’s Salt",
  collection: loot-collection.hope-and-fear,
  roll: 12,
  description: "You can spread this salt in a line along windowsills or thresholds to create a magical barrier that undead creatures can’t cross until the line is broken.",
  flags: source(82),
)

#let yakamel-milk = consumable(
  id: "yakamel-milk",
  name: "Yakamel Milk",
  collection: loot-collection.hope-and-fear,
  roll: 13,
  description: "After consuming this milk, the next time you clear 1 or more Hit Points, you clear an additional Hit Point.",
  flags: source(82),
)

#let glowmoss-mushroom = consumable(
  id: "glowmoss-mushroom",
  name: "Glowmoss Mushroom",
  collection: loot-collection.hope-and-fear,
  roll: 14,
  description: "You can break this mushroom into pieces, causing it to glow bright blue until your next long rest.",
  flags: source(82),
)

#let red-ooze-oil = consumable(
  id: "red-ooze-oil",
  name: "Red Ooze Oil",
  collection: loot-collection.hope-and-fear,
  roll: 15,
  description: "You can coat your weapon in this oil. The next successful attack you make with this weapon deals an extra 1d8 magic damage and temporarily Ignitesthe target. While Ignited, the target takes 1d4 magic damage when they take the spotlight.",
  flags: source(82),
)

#let instant-camp = consumable(
  id: "instant-camp",
  name: "Instant Camp",
  collection: loot-collection.hope-and-fear,
  roll: 16,
  description: "You can unfold this small mechanical box into a camping tent large enough to safely house six people. The tent collapses at the end of your next long rest.",
  flags: source(82),
)

#let bundle-of-spiderlegs = consumable(
  id: "bundle-of-spiderlegs",
  name: "Bundle of Spiderlegs",
  collection: loot-collection.hope-and-fear,
  roll: 17,
  description: "You can eat these spiderlegs to walk on walls until your next rest.",
  flags: source(82),
)

#let ciscan-fog-bottle = consumable(
  id: "ciscan-fog-bottle",
  name: "Ciscan Fog Bottle",
  collection: loot-collection.hope-and-fear,
  roll: 18,
  description: "You can break this jar to fill the area within Close range with magical mist. A creature who enters the mist clears a Stress and becomes Hidden.",
  flags: source(82),
)

#let snapthorn-seed = consumable(
  id: "snapthorn-seed",
  name: "Snapthorn Seed",
  collection: loot-collection.hope-and-fear,
  roll: 19,
  description: "You can throw this seed at a point you can see. It explodes into a tangle of binding vines that temporarily Restrains all creatures within Close range of that point.",
  flags: source(82),
)

#let sprite-bottle = consumable(
  id: "sprite-bottle",
  name: "Sprite Bottle",
  collection: loot-collection.hope-and-fear,
  roll: 20,
  description: "When you mark your last Hit Point, this bottle shatters to release the Sprite inside. The Sprite clears all your Hit Points before fading from the Mortal Realm.",
  flags: source(82),
)

#let gravity-bomb = consumable(
  id: "gravity-bomb",
  name: "Gravity Bomb",
  collection: loot-collection.hope-and-fear,
  roll: 21,
  description: "You can throw this peach-sized mechanical orb at a point within Far range. It implodes and pulls all creatures and objects within Close range of that point into Melee range with it.",
  flags: source(82),
)

#let gossip-flower = consumable(
  id: "gossip-flower",
  name: "Gossip Flower",
  collection: loot-collection.hope-and-fear,
  roll: 22,
  description: "You can plant this seed in soil. It instantly grows into a small flower that records everything it hears for up to one week. When plucked, the flower recites what it recorded in real time, then withers.",
  flags: source(82),
)

#let displacement-token = consumable(
  id: "displacement-token",
  name: "Displacement Token",
  collection: loot-collection.hope-and-fear,
  roll: 23,
  description: "You can swallow this token to conjure two illusions of yourself that you can control. Each illusion lasts until it takes damage or until your next rest.",
  flags: source(82),
)

#let night-hags-dust = consumable(
  id: "night-hags-dust",
  name: "Night Hag’s Dust",
  collection: loot-collection.hope-and-fear,
  roll: 24,
  description: "You can blow this dust in an adversary’s face to prevent them from clearing Stress until your next long rest.",
  flags: source(82),
)

#let self-sewing-thread = consumable(
  id: "self-sewing-thread",
  name: "Self-Sewing Thread",
  collection: loot-collection.hope-and-fear,
  roll: 25,
  description: "You can use this thread to clear either a Hit Point or 2 Armor Slots.",
  flags: source(82),
)

#let stonemasons-fortune = consumable(
  id: "stonemasons-fortune",
  name: "Stonemason’s Fortune",
  collection: loot-collection.hope-and-fear,
  roll: 26,
  description: "When you throw this gray brick on the ground, it immediately grows into a 6-foot-tall, 10-foot-wide, and 2-foot-deep wall of solid stone.",
  flags: source(82),
)

#let mnemonic-potion = consumable(
  id: "mnemonic-potion",
  name: "Mnemonic Potion",
  collection: loot-collection.hope-and-fear,
  roll: 27,
  description: "You can drink this potion to Utilize an Experience without spending a Hope.",
  flags: source(83),
)

#let salamander-salve = consumable(
  id: "salamander-salve",
  name: "Salamander Salve",
  collection: loot-collection.hope-and-fear,
  roll: 28,
  description: "You can apply this salve to your skin to make yourself immune to heat until your next rest.",
  flags: source(83),
)

#let green-ooze-oil = consumable(
  id: "green-ooze-oil",
  name: "Green Ooze Oil",
  collection: loot-collection.hope-and-fear,
  roll: 29,
  description: "You can coat your weapon in this oil. The next successful attack you make with this weapon deals an extra 1d8 magic damage and temporarily Corrodes the target. While Corroded,the target gains a −2 penalty to their damage thresholds.",
  flags: source(83),
)

#let sunlight-orb = consumable(
  id: "sunlight-orb",
  name: "Sunlight Orb",
  collection: loot-collection.hope-and-fear,
  roll: 30,
  description: "You can shatter this orb to make the area within Very Far range appear as though it’s sunlit daytime for the next 24 hours.",
  flags: source(83),
)

#let moonlight-orb = consumable(
  id: "moonlight-orb",
  name: "Moonlight Orb",
  collection: loot-collection.hope-and-fear,
  roll: 31,
  description: "You can shatter this orb to make the area within Very Far range appear as though it’s moonlit nighttime for the next 24 hours.",
  flags: source(83),
)

#let midas-flask = consumable(
  id: "midas-flask",
  name: "Midas Flask",
  collection: loot-collection.hope-and-fear,
  roll: 32,
  description: "You can pour this small flask of alchemical liquid over a mundane item to instantly transmute it into a handful of gold.",
  flags: source(83),
)

#let staff-of-reversal = consumable(
  id: "staff-of-reversal",
  name: "Staff of Reversal",
  collection: loot-collection.hope-and-fear,
  roll: 33,
  description: "You can break this staff against the ground to reverse one magical transformation or effect within Far range.",
  flags: source(83),
)

#let berserkers-brew = consumable(
  id: "berserkers-brew",
  name: "Berserker’s Brew",
  collection: loot-collection.hope-and-fear,
  roll: 34,
  description: "When you drink this dram of liquid, you gain a bonus to your Strength and a penalty to your Finesse and Knowledge equal to your Instinct (minimum 1). This effect lasts until you make a death move or until your next rest.",
  flags: source(83),
)

#let emberite-shard = consumable(
  id: "emberite-shard",
  name: "Emberite Shard",
  collection: loot-collection.hope-and-fear,
  roll: 35,
  description: "Choose a point within Far range. All targets within Close range of that point must succeed on a Reaction Roll (16) or take 3d6 magic damage and become temporarily Ablaze. While Ablaze, a creature must roll a d4 whenever they make an action roll. On a result of 1, they mark a Hit Point. On a result of 4, they clear the Ablazecondition.",
  flags: source(83),
)

#let arcticite-shard = consumable(
  id: "arcticite-shard",
  name: "Arcticite Shard",
  collection: loot-collection.hope-and-fear,
  roll: 36,
  description: "Choose a point within Far range. All targets within Close range of that point must succeed on a Reaction Roll (16) or take 3d6 magic damage and become temporarily Restrained by ice.",
  flags: source(83),
)

#let fulgurite-shard = consumable(
  id: "fulgurite-shard",
  name: "Fulgurite Shard",
  collection: loot-collection.hope-and-fear,
  roll: 37,
  description: "Choose a point within Far range. All targets within Close range of that point must succeed on a Reaction Roll (16) or take 3d6 magic damage and mark 1d4 Stress as lightning crackles through the area.",
  flags: source(83),
)

#let demiurges-draught = consumable(
  id: "demiurges-draught",
  name: "Demiurge’s Draught",
  collection: loot-collection.hope-and-fear,
  roll: 38,
  description: "You can drink this draught to gain a +1 bonus to your Proficiency for your next successful attack roll.",
  flags: source(83),
)

#let cockerel-claw-tea = consumable(
  id: "cockerel-claw-tea",
  name: "Cockerel Claw Tea",
  collection: loot-collection.hope-and-fear,
  roll: 39,
  description: "You can drink this tea to refresh your features as if you had taken a long rest.",
  flags: source(83),
)

#let potion-of-vigilance = consumable(
  id: "potion-of-vigilance",
  name: "Potion of Vigilance",
  collection: loot-collection.hope-and-fear,
  roll: 40,
  description: "You can drink this potion to gain a +1 bonus to your Evasion until you mark a Hit Point.",
  flags: source(83),
)

#let cacophonous-concoction = consumable(
  id: "cacophonous-concoction",
  name: "Cacophonous Concoction",
  collection: loot-collection.hope-and-fear,
  roll: 41,
  description: "When you drink this potion, anything you say or do in the next hour becomes impossible for a witness to recount. Any attempts they make to communicate what they saw, heard, or otherwise sensed comes out garbled or nonsensical.",
  flags: source(83),
)

#let nightmare-mead = consumable(
  id: "nightmare-mead",
  name: "Nightmare Mead",
  collection: loot-collection.hope-and-fear,
  roll: 42,
  description: "You can drink this potion to discover the deepest fear of the next person you make eye contact with. When you do, the GM gains a Fear.",
  flags: source(83),
)

#let stake-of-abjuration = consumable(
  id: "stake-of-abjuration",
  name: "Stake of Abjuration",
  collection: loot-collection.hope-and-fear,
  roll: 43,
  description: "You can hammer this stake into the ground and make a proclamation. Until your next rest, a creature within Far range of the stake who transgresses that proclamation must mark a Stress. The stake lasts until your next rest, then it shatters.",
  flags: source(83),
)

#let psychopomps-shroud = consumable(
  id: "psychopomps-shroud",
  name: "Psychopomp’s Shroud",
  collection: loot-collection.hope-and-fear,
  roll: 44,
  description: "You can place this shroud over the corpse of a recently deceased creature. The creature’s spirit enters the shroud and becomes your spectral assistant until the next sunrise, when they pass through the veil of death and take the shroud with them.",
  flags: source(83),
)

#let phial-of-deep-ink = consumable(
  id: "phial-of-deep-ink",
  name: "Phial of Deep Ink",
  collection: loot-collection.hope-and-fear,
  roll: 45,
  description: "You can drink this bottle of ink to transform into a cephalopod of roughly your size for the next hour. You gain rubbery skin, soft bones, the ability to breathe underwater, and new limbs until you have eight total.",
  flags: source(83),
)

#let mesmers-tonic = consumable(
  id: "mesmers-tonic",
  name: "Mesmer’s Tonic",
  collection: loot-collection.hope-and-fear,
  roll: 46,
  description: "When you drink this tonic, the only thing you can hear until your next rest are the surface thoughts of creatures within Very Close range.",
  flags: source(83),
)

#let invisibility-potion = consumable(
  id: "invisibility-potion",
  name: "Invisibility Potion",
  collection: loot-collection.hope-and-fear,
  roll: 47,
  description: "You are Hidden until you deal damage to another creature or until your next rest.",
  flags: source(83),
)

#let formoid-serum = consumable(
  id: "formoid-serum",
  name: "Formoid Serum",
  collection: loot-collection.hope-and-fear,
  roll: 48,
  description: "You can drink this potion to become a swarm of 16 million ants until the end of the scene. You keep and have access to all equipment, loot, and features.",
  flags: source(83),
)

#let steelskin-salve = consumable(
  id: "steelskin-salve",
  name: "Steelskin Salve",
  collection: loot-collection.hope-and-fear,
  roll: 49,
  description: "You can apply this salve to your skin to gain a bonus to your damage thresholds equal to your tier until the end of the scene.",
  flags: source(83),
)

#let godlings-pomelo = consumable(
  id: "godlings-pomelo",
  name: "Godling’s Pomelo",
  collection: loot-collection.hope-and-fear,
  roll: 50,
  description: "You can eat this citrus fruit to clear all Hit Points and Stress.",
  flags: source(83),
)

#let snakeskin-spirit = consumable(
  id: "snakeskin-spirit",
  name: "Snakeskin Spirit",
  collection: loot-collection.hope-and-fear,
  roll: 51,
  description: "You can drink this potion to slough off your outer layer of skin and heal a scar.",
  flags: source(83),
)

#let magic-users-malison = consumable(
  id: "magic-users-malison",
  name: "Magic-User’s Malison",
  collection: loot-collection.hope-and-fear,
  roll: 52,
  description: "When you release this spellcaster’s trapped soul, you can cast one spell from a card in your vault as if it were in your loadout. This doesn’t work for permanently vaulted cards.",
  flags: source(84),
)

#let quintessential-severant = consumable(
  id: "quintessential-severant",
  name: "Quintessential Severant",
  collection: loot-collection.hope-and-fear,
  roll: 53,
  description: "You can use this magic blade to cut one magical or metaphysical bond, such as an enchantment, contract, magical tether, or divine oath. When you do, the blade shatters.",
  flags: source(84),
)

#let mask-of-the-echoed-self = consumable(
  id: "mask-of-the-echoed-self",
  name: "Mask of the Echoed Self",
  collection: loot-collection.hope-and-fear,
  roll: 54,
  description: "You can wear this mask during your next level up to swap the values of any of your traits. When you do, the mask becomes your permanent face.",
  flags: source(84),
)

#let necroprancers-bell = consumable(
  id: "necroprancers-bell",
  name: "Necroprancer’s Bell",
  collection: loot-collection.hope-and-fear,
  roll: 55,
  description: "You can break this rusted, clapperless bell against the ground to summon a skeletal steed that climbs out of the earth and serves you until the next sunrise.",
  flags: source(84),
)

#let drakemantle = consumable(
  id: "drakemantle",
  name: "Drakemantle",
  collection: loot-collection.hope-and-fear,
  roll: 56,
  description: "You can use this enchanted ancient dragon hide to gain draconic characteristics until the end of the scene, when the hide falls aways in tatters. Until then, you can fly and gain a +5 bonus to your damage thresholds and a +1 bonus to your Proficiency.",
  flags: source(84),
)

#let gamblers-fallacy = consumable(
  id: "gamblers-fallacy",
  name: "Gambler’s Fallacy",
  collection: loot-collection.hope-and-fear,
  roll: 57,
  description: "You can spend any number of handfuls of gold by placing them into this slotted ceramic jar shaped like a pig. When you throw the jar at a point within Far range, it explodes and deals 1d20 magic damage for each handful of gold spent to all creatures within Close range of that point. All gold within the jar is destroyed.",
  flags: source(84),
)

#let lionheart-tonic = consumable(
  id: "lionheart-tonic",
  name: "Lionheart Tonic",
  collection: loot-collection.hope-and-fear,
  roll: 58,
  description: "You can drink this tonic to gain a +1 bonus to your Proficiency until you roll with Fear.",
  flags: source(84),
)

#let tears-of-the-undying-hero = consumable(
  id: "tears-of-the-undying-hero",
  name: "Tears of the Undying Hero",
  collection: loot-collection.hope-and-fear,
  roll: 59,
  description: "When you drink this potion, death can’t touch you until your next long rest. When you would mark your last Hit Point, instead of making a death move, you make one final action roll before falling into a dreamless slumber until an ally chooses the Tend to Wounds downtime move to clear your Hit Points.",
  flags: source(84),
)

#let featherstep-potion = consumable(
  id: "featherstep-potion",
  name: "Featherstep Potion",
  collection: loot-collection.hope-and-fear,
  roll: 60,
  description: "You can drink this potion to sprout small wings from your ankles that give you a bonus to your Evasion equal to your tier until your next rest.",
  flags: source(84),
)

/// Every consumable in this file, in SRD table order.
#let entries = (stride-potion, bolster-potion, control-potion, attune-potion, charm-potion, enlighten-potion, minor-health-potion, minor-stamina-potion, grindletooth-venom, varik-leaves, vial-of-moondrip, unstable-arcane-shard, potion-of-stability, improved-grindletooth-venom, morphing-clay, vial-of-darksmoke, jumping-root, snap-powder, health-potion, stamina-potion, armor-stitcher, gill-salve, replication-parchment, improved-arcane-shard, major-stride-potion, major-bolster-potion, major-control-potion, major-attune-potion, major-charm-potion, major-enlighten-potion, blood-of-the-yorgi, homets-secret-potion, redthorn-saliva, channelstone, mythic-dust, acidpaste, hopehold-flare, major-arcane-shard, featherbone, circle-of-the-void, sun-tree-sap, dripfang-poison, major-health-potion, major-stamina-potion, ogre-musk, wingsprout, jar-of-lost-voices, dragonbloom-tea, bridge-seed, sleeping-sap, feast-of-xuria, bonding-honey, shrinking-potion, growing-potion, knowledge-stone, sweet-moss, blinding-orb, death-tea, mirror-of-marigold, stardrop, warding-candle, iridian-dust, verglasian-seed, cupbearers-bezoar, mossmantle-potion, lyrebird-lozenge, vial-of-featherfall, chimeric-saliva, packet-of-space-dust, pipeweed, deathseers-powder, slayers-salt, yakamel-milk, glowmoss-mushroom, red-ooze-oil, instant-camp, bundle-of-spiderlegs, ciscan-fog-bottle, snapthorn-seed, sprite-bottle, gravity-bomb, gossip-flower, displacement-token, night-hags-dust, self-sewing-thread, stonemasons-fortune, mnemonic-potion, salamander-salve, green-ooze-oil, sunlight-orb, moonlight-orb, midas-flask, staff-of-reversal, berserkers-brew, emberite-shard, arcticite-shard, fulgurite-shard, demiurges-draught, cockerel-claw-tea, potion-of-vigilance, cacophonous-concoction, nightmare-mead, stake-of-abjuration, psychopomps-shroud, phial-of-deep-ink, mesmers-tonic, invisibility-potion, formoid-serum, steelskin-salve, godlings-pomelo, snakeskin-spirit, magic-users-malison, quintessential-severant, mask-of-the-echoed-self, necroprancers-bell, drakemantle, gamblers-fallacy, lionheart-tonic, tears-of-the-undying-hero, featherstep-potion,)
