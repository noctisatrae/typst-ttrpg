// Loot items, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Extracted with scripts/srd (loot.py, emit.py) and cross-checked against
// the SRD text with checkdata.py. Text is verbatim except: line breaks
// joined; the SRD's inline emphasis is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": item, loot-collection

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let premium-bedroll = item(
  id: "premium-bedroll",
  name: "Premium Bedroll",
  collection: loot-collection.core-set,
  roll: 1,
  description: "During downtime, you automatically clear a Stress.",
  flags: source(75),
)

#let piper-whistle = item(
  id: "piper-whistle",
  name: "Piper Whistle",
  collection: loot-collection.core-set,
  roll: 2,
  description: "This handcrafted whistle has a distinctive sound. When you blow this whistle, its piercing tone can be heard within a 1-mile radius.",
  flags: source(75),
)

#let charging-quiver = item(
  id: "charging-quiver",
  name: "Charging Quiver",
  collection: loot-collection.core-set,
  roll: 3,
  description: "When you succeed on an attack with an arrow stored in this quiver, gain a bonus to the damage roll equal to your current tier.",
  flags: source(75),
)

#let alistairs-torch = item(
  id: "alistairs-torch",
  name: "Alistair’s Torch",
  collection: loot-collection.core-set,
  roll: 4,
  description: "You can light this magic torch at will. The flame’s light fills a much larger space than it should, enough to illuminate a cave bright as day.",
  flags: source(75),
)

#let speaking-orbs = item(
  id: "speaking-orbs",
  name: "Speaking Orbs",
  collection: loot-collection.core-set,
  roll: 5,
  description: "This pair of orbs allows any creatures holding them to communicate with each other across any distance.",
  flags: source(75),
)

#let manacles = item(
  id: "manacles",
  name: "Manacles",
  collection: loot-collection.core-set,
  roll: 6,
  description: "This pair of locking cuffs comes with a key.",
  flags: source(75),
)

#let arcane-cloak = item(
  id: "arcane-cloak",
  name: "Arcane Cloak",
  collection: loot-collection.core-set,
  roll: 7,
  description: "A creature with a Spellcast trait wearing this cloak can adjust its color, texture, and size at will.",
  flags: source(75),
)

#let woven-net = item(
  id: "woven-net",
  name: "Woven Net",
  collection: loot-collection.core-set,
  roll: 8,
  description: "You can make a Finesse Roll using this net to trap a small creature. A trapped target can break free with a successful Attack Roll (16).",
  flags: source(75),
)

#let fire-jar = item(
  id: "fire-jar",
  name: "Fire Jar",
  collection: loot-collection.core-set,
  roll: 9,
  description: "You can pour out the strange liquid contents of this jar to instantly produce fire. The contents regenerate when you take a long rest.",
  flags: source(75),
)

#let suspended-rod = item(
  id: "suspended-rod",
  name: "Suspended Rod",
  collection: loot-collection.core-set,
  roll: 10,
  description: "This flat rod is inscribed with runes. When you activate the rod, it is immediately suspended in place. Until the rod is deactivated, it can’t move, doesn’t abide by the rules of gravity, and remains in place.",
  flags: source(75),
)

#let glamour-stone = item(
  id: "glamour-stone",
  name: "Glamour Stone",
  collection: loot-collection.core-set,
  roll: 11,
  description: "Activate this pebble-sized stone to memorize the appearance of someone you can see. Spend a Hope to magically recreate this guise on yourself as an illusion.",
  flags: source(75),
)

#let empty-chest = item(
  id: "empty-chest",
  name: "Empty Chest",
  collection: loot-collection.core-set,
  roll: 12,
  description: "This magical chest appears empty. When you speak a specific trigger word or action and open the chest, you can see the items stored within it.",
  flags: source(75),
)

#let companion-case = item(
  id: "companion-case",
  name: "Companion Case",
  collection: loot-collection.core-set,
  roll: 13,
  description: "This case can fit a small animal companion. While the companion is inside, the animal and case are immune to all damage and harmful effects.",
  flags: source(75),
)

#let piercing-arrows = item(
  id: "piercing-arrows",
  name: "Piercing Arrows",
  collection: loot-collection.core-set,
  roll: 14,
  description: "Three times per rest when you succeed on an attack with one of these arrows, you can add your Proficiency to the damage roll.",
  flags: source(75),
)

#let valorstone = item(
  id: "valorstone",
  name: "Valorstone",
  collection: loot-collection.core-set,
  roll: 15,
  description: [#"You can attach this stone to armor that doesn’t already have a feature. The armor gains the following feature." \ #"Resilient: Before you mark your last Armor Slot, roll a d6. On a result of 6, reduce the severity by one threshold without marking an Armor Slot."],
  flags: source(75),
)

#let skeleton-key = item(
  id: "skeleton-key",
  name: "Skeleton Key",
  collection: loot-collection.core-set,
  roll: 16,
  description: "When you use this key to open a locked door, you gain advantage on the Finesse Roll.",
  flags: source(75),
)

#let arcane-prism = item(
  id: "arcane-prism",
  name: "Arcane Prism",
  collection: loot-collection.core-set,
  roll: 17,
  description: "Position this prism in a location of your choosing and activate it. All allies within Close range of it gain a +1 bonus to their Spellcast Rolls. While activated, the prism can’t be moved. Once the prism is deactivated, it can’t be activated again until your next long rest.",
  flags: source(75),
)

#let minor-stamina-potion-recipe = item(
  id: "minor-stamina-potion-recipe",
  name: "Minor Stamina Potion Recipe",
  collection: loot-collection.core-set,
  roll: 18,
  description: "As a downtime move, you can use the bone of a creature to craft a Minor Stamina Potion.",
  flags: source(75),
)

#let minor-health-potion-recipe = item(
  id: "minor-health-potion-recipe",
  name: "Minor Health Potion Recipe",
  collection: loot-collection.core-set,
  roll: 19,
  description: "As a downtime move, you can use a vial of blood to craft a Minor Health Potion.",
  flags: source(76),
)

#let homing-compasses = item(
  id: "homing-compasses",
  name: "Homing Compasses",
  collection: loot-collection.core-set,
  roll: 20,
  description: "These two compasses point toward each other no matter how far apart they are.",
  flags: source(76),
)

#let corrector-sprite = item(
  id: "corrector-sprite",
  name: "Corrector Sprite",
  collection: loot-collection.core-set,
  roll: 21,
  description: "This tiny sprite sits in the curve of your ear canal and whispers helpful advice during combat. Once per short rest, you can gain advantage on an attack roll.",
  flags: source(76),
)

#let gecko-gloves = item(
  id: "gecko-gloves",
  name: "Gecko Gloves",
  collection: loot-collection.core-set,
  roll: 22,
  description: "You can climb up vertical surfaces and across ceilings.",
  flags: source(76),
)

#let lorekeeper = item(
  id: "lorekeeper",
  name: "Lorekeeper",
  collection: loot-collection.core-set,
  roll: 23,
  description: "You can store the name and details of up to three hostile creatures inside this book. You gain a +1 bonus to action rolls against those creatures.",
  flags: source(76),
)

#let vial-of-darksmoke-recipe = item(
  id: "vial-of-darksmoke-recipe",
  name: "Vial of Darksmoke Recipe",
  collection: loot-collection.core-set,
  roll: 24,
  description: "As a downtime move, you can mark a Stress to craft a Vial of Darksmoke.",
  flags: source(76),
)

#let bloodstone = item(
  id: "bloodstone",
  name: "Bloodstone",
  collection: loot-collection.core-set,
  roll: 25,
  description: [#"You can attach this stone to a weapon that doesn’t already have a feature. The weapon gains the following feature." \ #"Brutal: When you roll the maximum value on a damage die, roll an additional damage die."],
  flags: source(76),
)

#let greatstone = item(
  id: "greatstone",
  name: "Greatstone",
  collection: loot-collection.core-set,
  roll: 26,
  description: [#"You can attach this stone to a weapon that doesn’t already have a feature. The weapon gains the following feature." \ #"Powerful: On a successful attack, roll an additional damage die and discard the lowest result."],
  flags: source(76),
)

#let glider = item(
  id: "glider",
  name: "Glider",
  collection: loot-collection.core-set,
  roll: 27,
  description: "While falling, you can mark a Stress to deploy this small parachute and glide safely to the ground.",
  flags: source(76),
)

#let ring-of-silence = item(
  id: "ring-of-silence",
  name: "Ring of Silence",
  collection: loot-collection.core-set,
  roll: 28,
  description: "Spend a Hope to activate this ring. Your footsteps are silent until your next rest.",
  flags: source(76),
)

#let calming-pendant = item(
  id: "calming-pendant",
  name: "Calming Pendant",
  collection: loot-collection.core-set,
  roll: 29,
  description: "When you would mark your last Stress, roll a d6. On a result of 5 or higher, don’t mark it.",
  flags: source(76),
)

#let dual-flask = item(
  id: "dual-flask",
  name: "Dual Flask",
  collection: loot-collection.core-set,
  roll: 30,
  description: "This flask can hold two different liquids. You can swap between them by flipping a small switch on the flask’s side.",
  flags: source(76),
)

#let bag-of-ficklesand = item(
  id: "bag-of-ficklesand",
  name: "Bag of Ficklesand",
  collection: loot-collection.core-set,
  roll: 31,
  description: "You can convince this small bag of sand to be much heavier or lighter with a successful Presence Roll (10). Additionally, on a successful Finesse Roll (10), you can blow a bit of sand into a target’s face to make them temporarily Vulnerable.",
  flags: source(76),
)

#let ring-of-resistance = item(
  id: "ring-of-resistance",
  name: "Ring of Resistance",
  collection: loot-collection.core-set,
  roll: 32,
  description: "Once per long rest, you can activate this ring after a successful attack against you to halve the damage.",
  flags: source(76),
)

#let phoenix-feather = item(
  id: "phoenix-feather",
  name: "Phoenix Feather",
  collection: loot-collection.core-set,
  roll: 33,
  description: "If you have at least one Phoenix Feather on you when you fall unconscious, you gain a +1 bonus to the roll you make to determine whether you gain a scar.",
  flags: source(76),
)

#let box-of-many-goods = item(
  id: "box-of-many-goods",
  name: "Box of Many Goods",
  collection: loot-collection.core-set,
  roll: 34,
  description: "Once per long rest, you can open this small box and roll a d12. On a result of 1–6, it’s empty. On a result of 7–10, it contains one random common consumable. On a result of 11–12, it contains two random common consumables.",
  flags: source(76),
)

#let airblade-charm = item(
  id: "airblade-charm",
  name: "Airblade Charm",
  collection: loot-collection.core-set,
  roll: 35,
  description: "You can attach this charm to a weapon with a Melee range. Three times per rest, you can activate the charm and attack a target within Close range.",
  flags: source(76),
)

#let portal-seed = item(
  id: "portal-seed",
  name: "Portal Seed",
  collection: loot-collection.core-set,
  roll: 36,
  description: "You can plant this seed in the ground to grow a portal in that spot. The portal is ready to use in 24 hours. You can use this portal to travel to any other location where you planted a portal seed. A portal can be destroyed by dealing any amount of magic damage to it.",
  flags: source(76),
)

#let paragons-chain = item(
  id: "paragons-chain",
  name: "Paragon’s Chain",
  collection: loot-collection.core-set,
  roll: 37,
  description: "As a downtime move, you can meditate on an ideal or principle you hold dear and focus your will into this chain. Once per long rest, you can spend a Hope to roll a d20 as your Hope Die for rolls that directly align with that principle.",
  flags: source(76),
)

#let elusive-amulet = item(
  id: "elusive-amulet",
  name: "Elusive Amulet",
  collection: loot-collection.core-set,
  roll: 38,
  description: "Once per long rest, you can activate this amulet to become Hidden until you move. While Hidden in this way, you remain unseen even if an adversary moves to where they would normally see you.",
  flags: source(76),
)

#let hopekeeper-locket = item(
  id: "hopekeeper-locket",
  name: "Hopekeeper Locket",
  collection: loot-collection.core-set,
  roll: 39,
  description: "During a long rest, if you have 6 Hope, you can spend a Hope to imbue this locket with your bountiful resolve. When you have 0 Hope, you can use the locket to immediately gain a Hope. The locket must be re-imbued before it can be used this way again.",
  flags: source(76),
)

#let infinite-bag = item(
  id: "infinite-bag",
  name: "Infinite Bag",
  collection: loot-collection.core-set,
  roll: 40,
  description: "When you store items in this bag, they are kept in a pocket dimension that never runs out of space. You can retrieve an item at any time.",
  flags: source(76),
)

#let stride-relic = item(
  id: "stride-relic",
  name: "Stride Relic",
  collection: loot-collection.core-set,
  roll: 41,
  description: "You gain a +1 bonus to your Agility. You can only carry one relic.",
  flags: source(76),
)

#let bolster-relic = item(
  id: "bolster-relic",
  name: "Bolster Relic",
  collection: loot-collection.core-set,
  roll: 42,
  description: "You gain a +1 bonus to your Strength. You can only carry one relic.",
  flags: source(76),
)

#let control-relic = item(
  id: "control-relic",
  name: "Control Relic",
  collection: loot-collection.core-set,
  roll: 43,
  description: "You gain a +1 bonus to your Finesse. You can only carry one relic.",
  flags: source(76),
)

#let attune-relic = item(
  id: "attune-relic",
  name: "Attune Relic",
  collection: loot-collection.core-set,
  roll: 44,
  description: "You gain a +1 bonus to your Instinct. You can only carry one relic.",
  flags: source(76),
)

#let charm-relic = item(
  id: "charm-relic",
  name: "Charm Relic",
  collection: loot-collection.core-set,
  roll: 45,
  description: "You gain a +1 bonus to your Presence. You can only carry one relic.",
  flags: source(77),
)

#let enlighten-relic = item(
  id: "enlighten-relic",
  name: "Enlighten Relic",
  collection: loot-collection.core-set,
  roll: 46,
  description: "You gain a +1 bonus to your Knowledge. You can only carry one relic.",
  flags: source(77),
)

#let honing-relic = item(
  id: "honing-relic",
  name: "Honing Relic",
  collection: loot-collection.core-set,
  roll: 47,
  description: "You gain a +1 bonus to an Experience of your choice. You can only carry one relic.",
  flags: source(77),
)

#let flickerfly-pendant = item(
  id: "flickerfly-pendant",
  name: "Flickerfly Pendant",
  collection: loot-collection.core-set,
  roll: 48,
  description: "While you carry this pendant, your weapons with a Melee range that deal physical damage have a gossamer sheen and can attack targets within Very Close range.",
  flags: source(77),
)

#let lakestrider-boots = item(
  id: "lakestrider-boots",
  name: "Lakestrider Boots",
  collection: loot-collection.core-set,
  roll: 49,
  description: "You can walk on the surface of water as if it were soft ground.",
  flags: source(77),
)

#let clay-companion = item(
  id: "clay-companion",
  name: "Clay Companion",
  collection: loot-collection.core-set,
  roll: 50,
  description: "When you sculpt this ball of clay into a clay animal companion, it behaves as that animal. For example, a clay spider can spin clay webs, while a clay bird can fly. The clay companion retains memory and identity across different shapes, but they can adopt new mannerisms with each form.",
  flags: source(77),
)

#let mythic-dust-recipe = item(
  id: "mythic-dust-recipe",
  name: "Mythic Dust Recipe",
  collection: loot-collection.core-set,
  roll: 51,
  description: "As a downtime move, you can use a handful of fine gold dust to craft Mythic Dust.",
  flags: source(77),
)

#let shard-of-memory = item(
  id: "shard-of-memory",
  name: "Shard of Memory",
  collection: loot-collection.core-set,
  roll: 52,
  description: "Once per long rest, you can spend 2 Hope to recall a domain card from your vault instead of paying its Recall Cost.",
  flags: source(77),
)

#let gem-of-alacrity = item(
  id: "gem-of-alacrity",
  name: "Gem of Alacrity",
  collection: loot-collection.core-set,
  roll: 53,
  description: "You can attach this gem to a weapon, allowing you to use your Agility when making an attack with that weapon.",
  flags: source(77),
)

#let gem-of-might = item(
  id: "gem-of-might",
  name: "Gem of Might",
  collection: loot-collection.core-set,
  roll: 54,
  description: "You can attach this gem to a weapon, allowing you to use your Strength when making an attack with that weapon.",
  flags: source(77),
)

#let gem-of-precision = item(
  id: "gem-of-precision",
  name: "Gem of Precision",
  collection: loot-collection.core-set,
  roll: 55,
  description: "You can attach this gem to a weapon, allowing you to use your Finesse when making an attack with that weapon.",
  flags: source(77),
)

#let gem-of-insight = item(
  id: "gem-of-insight",
  name: "Gem of Insight",
  collection: loot-collection.core-set,
  roll: 56,
  description: "You can attach this gem to a weapon, allowing you to use your Instinct when making an attack with that weapon.",
  flags: source(77),
)

#let gem-of-audacity = item(
  id: "gem-of-audacity",
  name: "Gem of Audacity",
  collection: loot-collection.core-set,
  roll: 57,
  description: "You can attach this gem to a weapon, allowing you to use your Presence when making an attack with that weapon.",
  flags: source(77),
)

#let gem-of-sagacity = item(
  id: "gem-of-sagacity",
  name: "Gem of Sagacity",
  collection: loot-collection.core-set,
  roll: 58,
  description: "You can attach this gem to a weapon, allowing you to use your Knowledge when making an attack with that weapon.",
  flags: source(77),
)

#let ring-of-unbreakable-resolve = item(
  id: "ring-of-unbreakable-resolve",
  name: "Ring of Unbreakable Resolve",
  collection: loot-collection.core-set,
  roll: 59,
  description: "Once per session, when the GM spends a Fear, you can spend 4 Hope to cancel the effects of that spent Fear.",
  flags: source(77),
)

#let belt-of-unity = item(
  id: "belt-of-unity",
  name: "Belt of Unity",
  collection: loot-collection.core-set,
  roll: 60,
  description: "Once per session, you can spend 5 Hope to lead a Tag Team Roll with three PCs instead of two.",
  flags: source(77),
)

#let caltrops = item(
  id: "caltrops",
  name: "Caltrops",
  collection: loot-collection.hope-and-fear,
  roll: 1,
  description: "You can spread these caltrops in a Very Close area around you. A creature hastening through that area must mark a Stress.",
  flags: source(77),
)

#let grapnel = item(
  id: "grapnel",
  name: "Grapnel",
  collection: loot-collection.hope-and-fear,
  roll: 2,
  description: "You gain advantage on action rolls to climb sheer surfaces.",
  flags: source(77),
)

#let ball-bearings = item(
  id: "ball-bearings",
  name: "Ball Bearings",
  collection: loot-collection.hope-and-fear,
  roll: 3,
  description: "This pouch contains perfectly smooth metal spheres.",
  flags: source(77),
)

#let box-of-dragon-dust = item(
  id: "box-of-dragon-dust",
  name: "Box of Dragon Dust",
  collection: loot-collection.hope-and-fear,
  roll: 4,
  description: "This snuffbox is filled with combustible powder.",
  flags: source(77),
)

#let nighthawkers-ring = item(
  id: "nighthawkers-ring",
  name: "Nighthawker’s Ring",
  collection: loot-collection.hope-and-fear,
  roll: 5,
  description: "Spend a Hope to activate the gemstone in this ring until the end of the scene. While active, the gemstone changes color to indicate the wearer’s proximity to hidden treasure: warm colors for near, cool colors for far.",
  flags: source(77),
)

#let elven-spyglass = item(
  id: "elven-spyglass",
  name: "Elven Spyglass",
  collection: loot-collection.hope-and-fear,
  roll: 6,
  description: "You can use this spyglass to magnify your vision a hundredfold.",
  flags: source(77),
)

#let gourmet-granules = item(
  id: "gourmet-granules",
  name: "Gourmet Granules",
  collection: loot-collection.hope-and-fear,
  roll: 7,
  description: "This savory powder makes any food it’s sprinkled on delicious and healthy, no matter how bland or rotten it is.",
  flags: source(77),
)

#let collapsible-pole = item(
  id: "collapsible-pole",
  name: "Collapsible Pole",
  collection: loot-collection.hope-and-fear,
  roll: 8,
  description: "You can break down this 18-foot pole into six interlinked 3-foot segments.",
  flags: source(77),
)

#let blackwing-quill = item(
  id: "blackwing-quill",
  name: "Blackwing Quill",
  collection: loot-collection.hope-and-fear,
  roll: 9,
  description: "This writing quill never runs out of ink or needs to be sharpened.",
  flags: source(77),
)

#let silees-folding-knife = item(
  id: "silees-folding-knife",
  name: "Silee’s Folding Knife",
  collection: loot-collection.hope-and-fear,
  roll: 10,
  description: "This 3-inch blade has an edge that easily cuts through anything except the handle it’s stored in.",
  flags: source(77),
)

#let windup-toy = item(
  id: "windup-toy",
  name: "Windup Toy",
  collection: loot-collection.hope-and-fear,
  roll: 11,
  description: "This small mechanical device is shaped like a strixwolf pup and can be programmed to perform simple tricks.",
  flags: source(78),
)

#let loaded-dice = item(
  id: "loaded-dice",
  name: "Loaded Dice",
  collection: loot-collection.hope-and-fear,
  roll: 12,
  description: "You can choose what result this set of weighted dice rolls with a successful Finesse Roll (14). If you roll with Fear, anyone watching knows the dice are loaded.",
  flags: source(78),
)

#let hollowbark-horn = item(
  id: "hollowbark-horn",
  name: "Hollowbark Horn",
  collection: loot-collection.hope-and-fear,
  roll: 13,
  description: "You can blow this horn to summon a small woodland creature to perform a simple task.",
  flags: source(78),
)

#let self-tying-rope = item(
  id: "self-tying-rope",
  name: "Self-Tying Rope",
  collection: loot-collection.hope-and-fear,
  roll: 14,
  description: "You can command this rope to tie or untie itself.",
  flags: source(78),
)

#let thiefs-compass = item(
  id: "thiefs-compass",
  name: "Thief’s Compass",
  collection: loot-collection.hope-and-fear,
  roll: 15,
  description: "This compass points the way toward the nearest exit while indoors and the closest entrance while outdoors.",
  flags: source(78),
)

#let travelers-bell = item(
  id: "travelers-bell",
  name: "Traveler’s Bell",
  collection: loot-collection.hope-and-fear,
  roll: 16,
  description: "Once per long rest, you can ring this bell to magically open the shortest safe path through rough terrain for 1 hour.",
  flags: source(78),
)

#let mandragorian-torch = item(
  id: "mandragorian-torch",
  name: "Mandragorian Torch",
  collection: loot-collection.hope-and-fear,
  roll: 17,
  description: "This torch gives off light only the bearer can see.",
  flags: source(78),
)

#let boots-of-supple-mystique = item(
  id: "boots-of-supple-mystique",
  name: "Boots of Supple Mystique",
  collection: loot-collection.hope-and-fear,
  roll: 18,
  description: "While wearing these boots, you don’t leave tracks or footprints.",
  flags: source(78),
)

#let zephyrs-jar = item(
  id: "zephyrs-jar",
  name: "Zephyr’s Jar",
  collection: loot-collection.hope-and-fear,
  roll: 19,
  description: "You can open this empty jar during inclement weather to capture the storm and leave behind clear skies. The storm remains inside until unleashed by reopening the jar.",
  flags: source(78),
)

#let returning-ring = item(
  id: "returning-ring",
  name: "Returning Ring",
  collection: loot-collection.hope-and-fear,
  roll: 20,
  description: "When you throw your primary weapon while wearing this ring, the weapon appears in your hand immediately after the attack.",
  flags: source(78),
)

#let kingfishers-net = item(
  id: "kingfishers-net",
  name: "Kingfisher’s Net",
  collection: loot-collection.hope-and-fear,
  roll: 21,
  description: "Once per long rest, you can use this net to scoop one live fish out of any amount of water, no matter how unlikely it is for that water to have fish in it.",
  flags: source(78),
)

#let titans-girdle = item(
  id: "titans-girdle",
  name: "Titan’s Girdle",
  collection: loot-collection.hope-and-fear,
  roll: 22,
  description: "Once per scene, you can activate this girdle to gain a +1 bonus to your Proficiency for your next attack.",
  flags: source(78),
)

#let iron-veil = item(
  id: "iron-veil",
  name: "Iron Veil",
  collection: loot-collection.hope-and-fear,
  roll: 23,
  description: "This chain-link head covering renders the wearer invisible to fey creatures.",
  flags: source(78),
)

#let furball-bag = item(
  id: "furball-bag",
  name: "Furball Bag",
  collection: loot-collection.hope-and-fear,
  roll: 24,
  description: "Once per rest, you can produce 2d20 harmless, cat-sized fur creatures of indeterminate origin and species from this bag.",
  flags: source(78),
)

#let whisperstep-anklet = item(
  id: "whisperstep-anklet",
  name: "Whisperstep Anklet",
  collection: loot-collection.hope-and-fear,
  roll: 25,
  description: "This anklet makes your steps silent as long as you don’t move faster than walking speed.",
  flags: source(78),
)

#let enchanters-loupe = item(
  id: "enchanters-loupe",
  name: "Enchanter’s Loupe",
  collection: loot-collection.hope-and-fear,
  roll: 26,
  description: "You can use this loupe to see through illusions and enchantments.",
  flags: source(78),
)

#let eschers-mirrorball = item(
  id: "eschers-mirrorball",
  name: "Escher’s Mirrorball",
  collection: loot-collection.hope-and-fear,
  roll: 27,
  description: "Once per long rest, you can command this fist-sized silver orb to capture an omnidirectional image of its surroundings on its surface. This image lasts until your next long rest.",
  flags: source(78),
)

#let cheaters-coin = item(
  id: "cheaters-coin",
  name: "Cheater’s Coin",
  collection: loot-collection.hope-and-fear,
  roll: 28,
  description: "When you flip this coin, you can spend a Hope to determine which side it lands on.",
  flags: source(78),
)

#let gravewardens-bell = item(
  id: "gravewardens-bell",
  name: "Gravewarden’s Bell",
  collection: loot-collection.hope-and-fear,
  roll: 29,
  description: "This bell rings when a ghost or undead creature moves within Far range of it.",
  flags: source(78),
)

#let reliquary-of-the-sightless-saint = item(
  id: "reliquary-of-the-sightless-saint",
  name: "Reliquary of the Sightless Saint",
  collection: loot-collection.hope-and-fear,
  roll: 30,
  description: "You gain a +1 bonus to your Hope Die when you make the Risk It All death move.",
  flags: source(78),
)

#let map-of-revelation = item(
  id: "map-of-revelation",
  name: "Map of Revelation",
  collection: loot-collection.hope-and-fear,
  roll: 31,
  description: "You can attune this map to one creature at a time. The map always shows the attuned creature’s location.",
  flags: source(78),
)

#let dagginaes-obsidian-slate = item(
  id: "dagginaes-obsidian-slate",
  name: "Dagginae’s Obsidian Slate",
  collection: loot-collection.hope-and-fear,
  roll: 32,
  description: "This wafer-thin sheet of volcanic glass is used by archivists to keep notes. Any information etched onto its surface disappears but can be recalled via a command you set.",
  flags: source(78),
)

#let gadimans-backpack = item(
  id: "gadimans-backpack",
  name: "Gadiman’s Backpack",
  collection: loot-collection.hope-and-fear,
  roll: 33,
  description: "Once per rest, you can spend a Hope to conjure a mundane item up to a cubic foot in size inside this satchel.",
  flags: source(78),
)

#let eclipse-coin = item(
  id: "eclipse-coin",
  name: "Eclipse Coin",
  collection: loot-collection.hope-and-fear,
  roll: 34,
  description: "Once per rest, flip a coin. On heads, you gain a +1 bonus to attack rolls until your next successful attack. On tails, you gain +1 to your Evasion until an attack fails against you.",
  flags: source(78),
)

#let sorcerers-hat = item(
  id: "sorcerers-hat",
  name: "Sorcerer’s Hat",
  collection: loot-collection.hope-and-fear,
  roll: 35,
  description: "This conical blue hat is covered in silver stars. Once per rest, you can cast a spell from your vault with a Recall Cost equal to or less than your tier. This doesn’t work for permanently vaulted cards.",
  flags: source(78),
)

#let ghoulskin-gloves = item(
  id: "ghoulskin-gloves",
  name: "Ghoulskin Gloves",
  collection: loot-collection.hope-and-fear,
  roll: 36,
  description: "When you attack with a physical weapon while wearing these gloves, the damage is considered both physical and magic.",
  flags: source(78),
)

#let gloves-of-alacrity = item(
  id: "gloves-of-alacrity",
  name: "Gloves of Alacrity",
  collection: loot-collection.hope-and-fear,
  roll: 37,
  description: "When you would mark a Stress to reload a weapon, you don’t mark it.",
  flags: source(78),
)

#let insomniacs-periapt = item(
  id: "insomniacs-periapt",
  name: "Insomniac’s Periapt",
  collection: loot-collection.hope-and-fear,
  roll: 38,
  description: "When you take a rest without clearing Hit Points or Stress, you gain a +2 bonus to attack and damage rolls until your next rest.",
  flags: source(78),
)

#let wildriders-saddle = item(
  id: "wildriders-saddle",
  name: "Wildrider’s Saddle",
  collection: loot-collection.hope-and-fear,
  roll: 39,
  description: "This saddle grants any animal it’s strapped onto the ability to understand their rider’s commands.",
  flags: source(78),
)

#let soul-twin-circlets = item(
  id: "soul-twin-circlets",
  name: "Soul-Twin Circlets",
  collection: loot-collection.hope-and-fear,
  roll: 40,
  description: "Two creatures can wear this pair of circlets. You can spend a Hope to switch places with whoever is wearing the other circlet.",
  flags: source(79),
)

#let namers-oracle = item(
  id: "namers-oracle",
  name: "Namer’s Oracle",
  collection: loot-collection.hope-and-fear,
  roll: 41,
  description: "Once per session, you can roll this set of runic dice to reveal the full name of the last person you touched.",
  flags: source(79),
)

#let crucible-frames = item(
  id: "crucible-frames",
  name: "Crucible Frames",
  collection: loot-collection.hope-and-fear,
  roll: 42,
  description: "These eyeglasses reveal weak points in objects and creatures. Three times per rest, you can spend a Hope to gain advantage on an attack roll.",
  flags: source(79),
)

#let two-faced-aegis-brooch = item(
  id: "two-faced-aegis-brooch",
  name: "Two-Faced Aegis Brooch",
  collection: loot-collection.hope-and-fear,
  roll: 43,
  description: "Once per rest, flip a coin. On heads, you become immune to the next physical damage you take. On tails, you become immune to the next magic damage you take.",
  flags: source(79),
)

#let knockback-bracelets = item(
  id: "knockback-bracelets",
  name: "Knockback Bracelets",
  collection: loot-collection.hope-and-fear,
  roll: 44,
  description: "On a successful weapon attack, you can knock your target back up to Close range from their location.",
  flags: source(79),
)

#let force-disc = item(
  id: "force-disc",
  name: "Force Disc",
  collection: loot-collection.hope-and-fear,
  roll: 45,
  description: "This shimmering two-dimensional disc of magical force has a 4-foot diameter and is magically tethered to a pebble. The disc always floats 3 feet north of, and at the same elevation as, the pebble. The pebble has a mass equal to one-hundredth of the total mass carried by the disc.",
  flags: source(79),
)

#let molepaw-mittens = item(
  id: "molepaw-mittens",
  name: "Molepaw Mittens",
  collection: loot-collection.hope-and-fear,
  roll: 46,
  description: "Spend a Hope to swim through earth as if it were water for the next 10 minutes.",
  flags: source(79),
)

#let timekeepers-pendant = item(
  id: "timekeepers-pendant",
  name: "Timekeeper’s Pendant",
  collection: loot-collection.hope-and-fear,
  roll: 47,
  description: "You can choose an additional downtime move each rest.",
  flags: source(79),
)

#let iron-dagger-pendant = item(
  id: "iron-dagger-pendant",
  name: "Iron Dagger Pendant",
  collection: loot-collection.hope-and-fear,
  roll: 48,
  description: "Once per long rest, you can spend a Hope to tell the pendant a creature’s name. The pendant gently pulls you toward that creature’s current location until your next long rest.",
  flags: source(79),
)

#let collar-of-ascendancy = item(
  id: "collar-of-ascendancy",
  name: "Collar of Ascendancy",
  collection: loot-collection.hope-and-fear,
  roll: 49,
  description: "An animal who wears this collar gains the ability to speak and understand common speech.",
  flags: source(79),
)

#let temporal-sanctuary = item(
  id: "temporal-sanctuary",
  name: "Temporal Sanctuary",
  collection: loot-collection.hope-and-fear,
  roll: 50,
  description: "A PC who takes a rest in the temporal sanctuary can choose an additional downtime move.",
  flags: source(79),
)

#let heros-helm = item(
  id: "heros-helm",
  name: "Hero’s Helm",
  collection: loot-collection.hope-and-fear,
  roll: 51,
  description: "When you critically succeed on an attack, all allies within Close range gain a Hope.",
  flags: source(79),
)

#let rings-of-friendship = item(
  id: "rings-of-friendship",
  name: "Rings of Friendship",
  collection: loot-collection.hope-and-fear,
  roll: 52,
  description: "Two creatures can wear this pair of rings shaped like coiled snakes. You can spend the Hope of whoever is wearing the other ring (with their permission) as if it were your own.",
  flags: source(79),
)

#let rings-of-camaraderie = item(
  id: "rings-of-camaraderie",
  name: "Rings of Camaraderie",
  collection: loot-collection.hope-and-fear,
  roll: 53,
  description: "Two creatures can wear this pair of wooden rings. You can mark the Stress of whoever is wearing the other ring (with their permission) as if it were your own.",
  flags: source(79),
)

#let rings-of-alliance = item(
  id: "rings-of-alliance",
  name: "Rings of Alliance",
  collection: loot-collection.hope-and-fear,
  roll: 54,
  description: "Two creatures can wear this pair of rose gold rings. Once per session, you can initiate a Tag Team Roll with whoever is wearing the other ring without spending Hope or counting against your session limit for Tag Team Rolls.",
  flags: source(79),
)

#let phobophages-circlet = item(
  id: "phobophages-circlet",
  name: "Phobophage’s Circlet",
  collection: loot-collection.hope-and-fear,
  roll: 55,
  description: "When the GM spends a Fear, roll a d4. Once per scene on a result of 4, you clear a Stress.",
  flags: source(79),
)

#let quillshawl = item(
  id: "quillshawl",
  name: "Quillshawl",
  collection: loot-collection.hope-and-fear,
  roll: 56,
  description: "If an adversary attacks you within Melee range, they must succeed on a Reaction Roll (12) or mark a Hit Point.",
  flags: source(79),
)

#let warp-pendant = item(
  id: "warp-pendant",
  name: "Warp Pendant",
  collection: loot-collection.hope-and-fear,
  roll: 57,
  description: "Once per rest, mark a Stress to teleport to a location you can clearly see.",
  flags: source(79),
)

#let portal-frames = item(
  id: "portal-frames",
  name: "Portal Frames",
  collection: loot-collection.hope-and-fear,
  roll: 58,
  description: "This pair of small ornate frames, one red and one blue, are connected. Anything that passes into one exits from the other.",
  flags: source(79),
)

#let communion-relic = item(
  id: "communion-relic",
  name: "Communion Relic",
  collection: loot-collection.hope-and-fear,
  roll: 59,
  description: "Once per rest, you can spend a Hope to use an ally’s Experience as if it were your own. You can carry only one relic.",
  flags: source(79),
)

#let augurs-relic = item(
  id: "augurs-relic",
  name: "Augur’s Relic",
  collection: loot-collection.hope-and-fear,
  roll: 60,
  description: "Once per long rest, you can activate your Hope feature without spending Hope. You can carry only one relic.",
  flags: source(79),
)

/// Every item in this file, in SRD table order.
#let entries = (premium-bedroll, piper-whistle, charging-quiver, alistairs-torch, speaking-orbs, manacles, arcane-cloak, woven-net, fire-jar, suspended-rod, glamour-stone, empty-chest, companion-case, piercing-arrows, valorstone, skeleton-key, arcane-prism, minor-stamina-potion-recipe, minor-health-potion-recipe, homing-compasses, corrector-sprite, gecko-gloves, lorekeeper, vial-of-darksmoke-recipe, bloodstone, greatstone, glider, ring-of-silence, calming-pendant, dual-flask, bag-of-ficklesand, ring-of-resistance, phoenix-feather, box-of-many-goods, airblade-charm, portal-seed, paragons-chain, elusive-amulet, hopekeeper-locket, infinite-bag, stride-relic, bolster-relic, control-relic, attune-relic, charm-relic, enlighten-relic, honing-relic, flickerfly-pendant, lakestrider-boots, clay-companion, mythic-dust-recipe, shard-of-memory, gem-of-alacrity, gem-of-might, gem-of-precision, gem-of-insight, gem-of-audacity, gem-of-sagacity, ring-of-unbreakable-resolve, belt-of-unity, caltrops, grapnel, ball-bearings, box-of-dragon-dust, nighthawkers-ring, elven-spyglass, gourmet-granules, collapsible-pole, blackwing-quill, silees-folding-knife, windup-toy, loaded-dice, hollowbark-horn, self-tying-rope, thiefs-compass, travelers-bell, mandragorian-torch, boots-of-supple-mystique, zephyrs-jar, returning-ring, kingfishers-net, titans-girdle, iron-veil, furball-bag, whisperstep-anklet, enchanters-loupe, eschers-mirrorball, cheaters-coin, gravewardens-bell, reliquary-of-the-sightless-saint, map-of-revelation, dagginaes-obsidian-slate, gadimans-backpack, eclipse-coin, sorcerers-hat, ghoulskin-gloves, gloves-of-alacrity, insomniacs-periapt, wildriders-saddle, soul-twin-circlets, namers-oracle, crucible-frames, two-faced-aegis-brooch, knockback-bracelets, force-disc, molepaw-mittens, timekeepers-pendant, iron-dagger-pendant, collar-of-ascendancy, temporal-sanctuary, heros-helm, rings-of-friendship, rings-of-camaraderie, rings-of-alliance, phobophages-circlet, quillshawl, warp-pendant, portal-frames, communion-relic, augurs-relic,)
