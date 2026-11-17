// Tier 2 environments, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Extracted with scripts/srd (environments.py, emit.py) and cross-checked against
// the SRD text with checkdata.py. Text is verbatim except: line breaks
// joined; the SRD's inline emphasis is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": environment, environment-type, feature-kind, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let beach-day = environment(
  id: "beach-day",
  name: "Beach Day",
  tier: 2,
  type: environment-type.social,
  description: "The party takes a break from their adventure for some rest and relaxation in a seaside settlement.",
  impulses: "Conjure images of sand and surf, give them a breather, prepare them for the conflict ahead",
  difficulty: 14,
  potential-adversaries: "None",
  features: (
    feature("R&R", kind: feature-kind.passive, questions: "What’s so relaxing about this place? Does it remind you of somewhere you’ve been before?", "The party finds themselves in a location where the concerns and conflicts of the outside world melt away. When the PCs rest here, they gain an additional downtime move, the GM doesn’t gain Fear, and no long-term countdowns advance."),
    feature("“Our Story So Far…”", kind: feature-kind.passive, questions: "What sounds, smells, or sensations does the memory conjure in your mind? How did that moment permanently change you—or your opinion of your companion?", "Once per scene when a PC recounts a memorable moment from the campaign in conversation with another PC, they both gain a Hope."),
    feature("Local Trouble", kind: feature-kind.action, questions: "Why does this PC draw their attention? What do the locals care about more than these newly arrived adventurers?", "Spend a Fear to interrupt a PC’s respite with a minor complication, such as a gang of surly beach bums, an overly exuberant fan, or a really bad sunburn. The PC must gracefully resolve the situation or mark a Stress from the resulting embarrassment or frustration."),
    feature("Fashion Show", kind: feature-kind.reaction, questions: "What’s the fashion in this area? Where do the PCs source their new beach-themed articles and accessories?", "When the party prepares for their first day at the beach, have each player describe how their PC changes their attire to be more appropriate for the environment. The GM gives the PC with the freshest look a d6 Fresh Die that can be spent to add to any action or reaction roll."),
  ),
  flags: source(167),
)

#let cult-ritual = environment(
  id: "cult-ritual",
  name: "Cult Ritual",
  tier: 2,
  type: environment-type.event,
  description: "A Fallen cult assembles around a sigil of the defeated gods and a bonfire that burns a sickly shade of green.",
  impulses: "Profane the land, unite the Mortal Realm with the Circles Below",
  difficulty: 14,
  potential-adversaries: "Cult of the Fallen (Cult Adept, Cult Fang, Cult Initiate, Secret-Keeper)",
  features: (
    feature("Desecrated Ground", kind: feature-kind.passive, questions: "How do the PCs first notice that something is wrong about this place? What fears resurface while hope is kept at bay?", "Cultists dedicated this place to the Fallen Gods, and their foul influence seeps into it. Reduce the PCs’ Hope Die to a d10 while in this environment. The desecration can be removed with a Progress Countdown (6)."),
    feature("Blasphemous Might", kind: feature-kind.action, questions: "How does the enemy change in appearance? What fears do their blows bring to the surface?")[
      #"A portion of the ritual’s power is diverted into a cult member to fight off interlopers. Choose one adversary to become Imbued with terrible magic until the scene ends or they’re defeated. An Imbued adversary immediately takes the spotlight and gains one of the following benefits, or all three if you spend a Fear:"

      - #"They gain advantage on all attacks."
      - #"They deal an extra 1d10 damage on a successful attack."
      - #"They gain the following feature: Relentless (2) - Passive. This adversary can be spotlighted up to two times per GM turn. Spend Fear as usual to spotlight them."
    ],
    feature("The Summoning", kind: feature-kind.reaction, questions: "What will the cult do with this leashed demon if they succeed? What will they try to summon next?", "Countdown (6). When the PCs enter the scene or the cult begins the ritual to summon a demon, activate the countdown. Designate one adversary to lead the ritual. The countdown ticks down when a PC rolls with Fear. When it triggers, summon a Minor Demon within Very Close range of the ritual’s leader. If the leader is defeated, the countdown ends with no effect as the ritual fails."),
    feature("Complete the Ritual", kind: feature-kind.reaction, questions: "What does it feel like to see such devotion turned to the pursuit of fear and domination?", "If the ritual’s leader is targeted by an attack or spell, an ally within Very Close range of them can mark a Stress to be targeted by that attack or spell instead."),
  ),
  flags: source(167),
)

#let deadly-dungeon = environment(
  id: "deadly-dungeon",
  name: "Deadly Dungeon",
  tier: 2,
  type: environment-type.exploration,
  description: "A dimly lit subterranean network of tunnels and chambers filled with monsters, traps, and treasure.",
  impulses: "Devour the party’s resources, spring the trap, tempt them with treasure, throw monsters at them, turn them around",
  difficulty: 14,
  potential-adversaries: "Dungeon Denizens (Gobstalker, Green Ooze, Ravenous Mockery, Rust Eater), Rival Adventurers (Giant Brawler, Masked Thief, War Wizard)",
  features: (
    feature("Twists and Turns", kind: feature-kind.passive, questions: "What reward lies at the heart of the maze? Who built this labyrinth to protect it?", "Countdown (6). When the party enters the dungeon, activate the countdown. It ticks down when a PC succeeds on an action roll to navigate the passages. When it triggers, the PCs reach the deepest, darkest, best-defended part of the dungeon."),
    feature("Deep Pockets", kind: feature-kind.passive, questions: "What were the previous owners like? How do the PCs plan to get their purloined items out of the dungeon?")[
      #"Once per rest, the PCs can find a cache of treasure inside the dungeon, either on the corpses of previous delvers or behind hidden doors. On a successful roll to navigate the dungeon, a PC can spend up to 5 Hope to roll that number of d6s. Each result rolled gains the party the following loot or equipment:"

      1. #"Loose gemstones, jewelry, baubles, or coins equal to a handful of gold"
      2. #"A common item or consumable"
      3. #"An uncommon item or consumable"
      4. #"A rare item or consumable"
      5. #"A legendary item or consumable"
      6. #"A weapon or an armor from the party’s tier"
    ],
    feature("Wandering Monster", kind: feature-kind.reaction, questions: "How did these creatures come to be here? What were they doing when the PCs encountered them?", "When the party enters a new area of the dungeon, you can spend a Fear to summon 1d4 adversaries at or below the party’s tier within Far range and roll a d6. On a result of 1 or 2, the PCs notice warning signs and can prepare for the encounter; the first PC to make an action roll gains advantage on it. On a result of 3 or 4, the combat occurs as usual. On a result of 5 or 6, the adversaries get the drop on the PCs and immediately take the spotlight, and you gain a Fear."),
    feature("Booby Traps", kind: feature-kind.reaction, questions: "What kinds of traps and hazards fill this dungeon? What does their construction tell you about whoever designed them? Have any of them been triggered prior to the party’s arrival?", "When a PC fails an action roll to navigate the dungeon, activate a trap or hazard such as a spike pit, gauntlet of swinging blades, or locked room slowly filling with water. The party must succeed on a group action roll to deactivate, disarm, or escape it. On a failure, each PC involved in the group action roll takes 2d6+3 physical or magic damage (GM’s choice)."),
  ),
  flags: source(168),
)

#let duel = environment(
  id: "duel",
  name: "Duel",
  tier: 2,
  type: environment-type.event,
  description: "An adversary challenges one of the PCs to single combat as the rest of the party aids them from the sidelines.",
  impulses: "Focus on one PC, goad them into overcommitting, inflict an embarrassing defeat, sideline the rest of the party",
  difficulty: "Special (see “Relative Strength”)",
  potential-adversaries: "Any",
  features: (
    feature("“I Demand Satisfaction.”", kind: feature-kind.passive, questions: "Why was this PC chosen? What do they expect to win if they prove victorious?", "When an adversary challenges a PC to one-on-one combat, the PC chooses whether to accept. If they reject the challenge, they must mark a Stress, and you gain a Fear. If a PC accepts an adversary’s challenge, activate a Progress Countdown (6) and a Consequence Countdown (4). If the Progress Countdown triggers first, the PC wins the Duel and gains a favor or concession from their adversary. If the Consequence Countdown triggers first, the adversary wins the Duel and claims a favor or concession from the PC."),
    feature("Relative Strength", kind: feature-kind.passive, questions: "Who issues the challenge? What are they fighting for?", "The Difficulty of this environment equals that of the adversary who issued the challenge."),
    feature("Rules of Engagement", kind: feature-kind.passive, questions: "Where does this conflict take place? How does the environment offer the rest of the party an opportunity to aid their ally without interfering?", "During the Duel, the challenged PC is the only one who can make action rolls. Other PCs can only aid the challenged PC indirectly: They can Help an Ally, initiate group action rolls or Tag Team Rolls, and use any of their features that don’t directly affect the challenging adversary."),
    feature("Dirty Tricks", kind: feature-kind.action, questions: "What’s off-limits in this conflict? How does the adversary’s ally bend the rules without breaking them, or break the rules without getting caught? How can the PCs rebalance the scales?", "Spend a Fear to have the challenging adversary or one of their allies cheat. A PC can notice their underhanded action with a successful Instinct Reaction Roll and respond in kind."),
  ),
  flags: source(168),
)

#let hallowed-temple = environment(
  id: "hallowed-temple",
  name: "Hallowed Temple",
  tier: 2,
  type: environment-type.social,
  description: "A bustling but well-kept temple that provides healing and hosts regular services, overseen by a priest or seraph.",
  impulses: "Connect the Mortal Realm with the Hallows Above, display the power of the divine, provide aid and succor to the faithful",
  difficulty: 13,
  potential-adversaries: "Guards (Archer Guard, Bladed Guard, Head Guard)",
  features: (
    feature("A Place of Healing", kind: feature-kind.passive, questions: "What does the incense smell like? What kinds of songs do the acolytes sing?", "A PC who takes a rest in the Hallowed Temple automatically clears all HP."),
    feature("Divine Guidance", kind: feature-kind.passive, questions: "What does it feel like as you are touched by this vision? What feeling lingers after the images have passed?")[
      #"A PC who prays to a deity while in the Hallowed Temple can make an Instinct Roll to receive answers. If the god they beseech isn’t welcome in this temple, the roll is made with disadvantage."

      - #"Critical Success: The PC gains clear information. Additionally, they gain 1d4 Hope, which can be distributed between the party if they share the vision and guidance they received."
      - #"Success with Hope: The PC receives clear information."
      - #"Success with Fear: The PC receives brief flashes of insight and an emotional impression conveying an answer."
      - #"Any Failure: The PC receives only vague flashes. They can mark a Stress to receive one clear image without context."
    ],
    feature("Relentless Hope", kind: feature-kind.reaction, questions: "What emotions or memories do you connect with when fear presses in?", "Once per scene, each PC can mark a Stress to turn a result with Fear into a result with Hope."),
    feature("Divine Censure", kind: feature-kind.reaction, questions: "What symbols or icons do they bear that signal they are anointed agents of the divinity? Who leads the group and what led them to this calling?", "When the PCs have trespassed, blasphemed, or offended the clergy, you can spend a Fear to summon a High Seraph and 1d4 Bladed Guards within Close range of the senior priest to reinforce their will."),
  ),
  flags: source(169),
)

#let haunted-city = environment(
  id: "haunted-city",
  name: "Haunted City",
  tier: 2,
  type: environment-type.exploration,
  description: "An abandoned city populated by the restless spirits of eras past.",
  impulses: "Misdirect and disorient, replay apocalypses both public and personal",
  difficulty: 14,
  potential-adversaries: "Ghosts (Spectral Archer, Spectral Captain, Spectral Guardian), ghostly versions of other adversaries (see “Ghostly Form”)",
  features: (
    feature("Buried Knowledge", kind: feature-kind.passive, questions: "What greater secrets does the city contain? Why have so many ghosts lingered here? What doomed adventurers have met a bad fate here already?")[
      #"The city has countless mysteries to unfold. A PC who seeks knowledge about the fallen city can make an Instinct or Knowledge Roll to learn about this place and discover (potentially haunted) loot."

      - #"Critical Success: Gain valuable information and a related useful item."
      - #"Success with Hope: Gain valuable information."
      - #"Success with Fear: Uncover vague or incomplete information."
      - #"Any Failure: Mark a Stress to find a lead after an exhaustive search."
    ],
    feature("Ghostly Form", kind: feature-kind.passive, questions: "What injuries to their physical form speak to their cause of death? What unfulfilled purpose holds them in the Mortal Plane?", "Adversaries who appear here are of a ghostly form. They have resistance to physical damage and can mark a Stress to move up to Close range through solid objects."),
    feature("Dead Ends", kind: feature-kind.action, questions: "What do the ghosts want from you? What do you need from them?", "The ghosts of an earlier era manifest scenes from their bygone era, such as a street festival, a revolution, or a heist. These hauntings change the layout of the city around the PCs, blocking the way behind them, forcing a detour, or presenting them with a challenge, such as mistaking them for rival thieves during the heist."),
    feature("Apocalypse Then", kind: feature-kind.action, questions: "Is this the disaster that led the city to be abandoned? What is known about this disaster, and how could that help the PCs escape?", "Spend a Fear to manifest the echo of a past disaster that ravaged the city. Activate a Progress Countdown (5) as the disaster replays around the PCs. To complete the countdown and escape the catastrophe, the PCs must overcome threats such as rampaging fires, stampeding civilians, collapsing buildings, or crumbling streets, while recalling history and finding clues to escape the inevitable."),
  ),
  flags: source(169),
)

#let masquerade-ball = environment(
  id: "masquerade-ball",
  name: "Masquerade Ball",
  tier: 2,
  type: environment-type.social,
  description: "A high society gala where masked revelers trade secrets and favors.",
  impulses: "Dance the night away, eat and be merry, make secret deals, trade valuable information",
  difficulty: 14,
  potential-adversaries: "Operatives (Masked Thief, Master Assassin, Spy), Revelers (Courtesan, Merchant Baron, Royal Advisor)",
  features: (
    feature("Costumes Required", kind: feature-kind.passive, questions: "What do the PCs come dressed as? What do their costumes reveal about their true selves?", "Everyone at the ball is expected to arrive in costume. PCs have advantage on Presence Rolls to convince others they are someone—or something—they’re not."),
    feature("“Care to Dance?”", kind: feature-kind.passive, questions: "What’s notable or unique about the dances that are in fashion here? Where did the PCs learn how to perform them?", "While dancing, a PC can make an Agility Roll instead of a Presence Roll to influence others."),
    feature("Mistaken Identity", kind: feature-kind.action, questions: "Who does the VIP mistake them for? What doors does their mistake open? What dangers does it bring?", "A very important person confuses a PC with an even more important person. The target can play into the misunderstanding with a Presence Reaction Roll. On a success, the PC can ask the VIP to perform a favor, relay a key piece of information, or make an introduction. On a failure, the PC marks a Stress as their true identity is discovered, and they are threatened with ejection from the party."),
    feature("Cloak and Dagger", kind: feature-kind.action, questions: "Who does the operative work for? Why did they send them to the masquerade?", "Spend a Fear to have an operative try to steal something valuable or assassinate someone important. A PC can make an Instinct Roll to try to notice them before they achieve their objective. On a success, the PC gains the opportunity to intervene. On a failure with Fear, the PC is erroneously implicated in the crime."),
  ),
  flags: source(170),
)

#let heist = environment(
  id: "heist",
  name: "Heist",
  tier: 2,
  type: environment-type.event,
  description: "The party must gain access to a hidden or well-protected location to acquire the information or items secured within.",
  impulses: "Make the party prepare, split them up, throw up obstacles, trap them inside, use up their resources",
  difficulty: 14,
  potential-adversaries: "Head Guard, Minotaur Wrecker, Secret-Keeper, Spectral Guardian",
  features: (
    feature("Prep Work", kind: feature-kind.passive, questions: "How does the PC gain this advantage? Do they go it alone or ask for help? What unforeseen complications arise during the heist itself?", "Prior to the Heist, each PC has the opportunity to gather a key piece of information, surveil the location, or acquire a helpful tool or resource. Give each player the opportunity to describe one obstacle they expect to encounter and how they set themselves up to overcome it, then have them make an action roll. On a success, they get the information or asset they sought. On a success with Fear, it’s less useful than they expected (for example, they discover the location of a hidden access point but learn that breaching it will likely be difficult and noisy)."),
    feature("Infiltration", kind: feature-kind.passive, questions: "What is the party going after, and where is it located? What unexpected obstacles will they encounter? What happens if the party gets caught?", "Establish the goal of the Heist and start two dynamic countdowns: a Progress Countdown (12) to represent the party’s work toward their goal and a Consequence Countdown (10) to represent the rising risk of discovery and capture. Advance both according to the Dynamic Countdown Advancement table as the PCs make action rolls to complete the Heist. If the Progress Countdown triggers first, spotlight this environment to use the “Exfiltration” feature. If the Consequence Countdown triggers first, gain 1d4 Fear, spotlight this environment, and use the “Sound the Alarm” feature."),
    feature("Saw This Coming", kind: feature-kind.passive, questions: "What did the PC prepare in advance? How did they know they’d need it? What did it cost them to set up, or whom do they owe a favor to?", "Once per session, a PC can spend a Hope to explain how they prepared for the current situation and reveal a key piece of information (such as the location of a hidden passage or the password to a restricted area) or produce a helpful item (such as a cultist’s uniform left unattended or a common consumable hidden in their boot)."),
    feature("Exfiltration", kind: feature-kind.reaction, questions: "What makes getting out even more dangerous than getting in? What unforeseen developments stymie the party’s original escape plan?", "When the Progress Countdown triggers, the party acquires the object of the Heist and must succeed on a group action roll to escape without capture. On a failure, each PC takes 2d12 direct physical damage and must mark a Stress."),
    feature("Sound the Alarm", kind: feature-kind.reaction, questions: "What makes these adversaries uniquely suited to guard this location? What do they know about this place that gives them an edge?", "When the Consequence Countdown triggers, the party is discovered and the location enters High Alert. Summon a number of Tier 2 adversaries equal to the number of PCs in the scene and immediately spotlight one. While this environment is on High Alert, all adversaries gain a +1 bonus to their Difficulty."),
  ),
  flags: source(170),
)

#let mountain-pass = environment(
  id: "mountain-pass",
  name: "Mountain Pass",
  tier: 2,
  type: environment-type.traversal,
  description: "Stony peaks that pierce the clouds, with a twisting path winding its way up and over through many switchbacks.",
  impulses: "Exact a chilling toll in supplies and stamina, reveal magical tampering, slow down travel",
  difficulty: 15,
  potential-adversaries: "Beasts (Bear, Giant Eagle, Glass Snake), Chaos Skull, Minotaur Wrecker, Mortal Hunter",
  features: (
    feature("Engraved Sigils", kind: feature-kind.passive, questions: "Who laid this enchantment? Are they nearby? Why did they want the weather to be more daunting?", "Large markings and engravings have been made in the mountainside. A PC with a relevant background or Experience identifies them as weather magic increasing the power of the icy winds. A PC who succeeds on a Knowledge Roll can recall information about the sigils, potential information about their creators, and the knowledge of how to dispel them. If a PC critically succeeds, they recognize that the sigils are of a style created by ridgeborne enchanters and they gain advantage on a roll to dispel the sigils."),
    feature("Avalanche", kind: feature-kind.action, questions: "How do the PCs try to weather the avalanche? What approach do the characters take to find one another when their companions go hurtling down the mountainside?", "Spend a Fear to carve the mountain with an icy torrent, causing an avalanche. All PCs in its path must succeed on an Agility or Strength Reaction Roll or be bowled over and carried down the mountain. A PC using rope, pitons, or other climbing gear gains advantage on this roll. Targets who fail are knocked down the mountain to Far range, take 2d20 physical damage, and must mark a Stress. Targets who succeed must mark a Stress."),
    feature("Raptor Nest", kind: feature-kind.reaction, questions: "How long has it been since the eagles last found prey? Do they have eggs in their nest, or unfledged young?", "When the PCs enter the raptors’ hunting grounds, two Giant Eagles appear at Very Far range of a chosen PC, identifying the PCs as likely prey."),
    feature("Icy Winds", kind: feature-kind.reaction, questions: "What parts of the PC’s bodies go numb first? How do they try to keep warm as they press forward?", "Countdown (Loop 4). When the PCs enter the mountain pass, activate the countdown. When it triggers, all characters traveling through the pass must succeed on a Strength Reaction Roll or mark a Stress. A PC wearing clothes appropriate for extreme cold gains advantage on these rolls."),
  ),
  flags: source(171),
)

#let ocean-voyage = environment(
  id: "ocean-voyage",
  name: "Ocean Voyage",
  tier: 2,
  type: environment-type.traversal,
  description: "The PCs gain passage to a far-off destination by offering their labor in exchange.",
  impulses: "Reveal what lurks beneath the waves, send them in the wrong direction, sink the ship, use up their resources",
  difficulty: 14,
  potential-adversaries: "Deep Sea Denizens (Electric Eels, Kraken, Shark, Siren), Pirates (Pirate Captain, Pirate Raiders)",
  features: (
    feature("Open Water", kind: feature-kind.passive, questions: "Where is the ship headed? What dangers along the route do the crew speak about in hushed tones?", "Countdown (8). Reaching their destination requires the party to complete the Open Water Countdown. It ticks down when a PC succeeds on an action roll to aid the ship’s journey."),
    feature("Rations Run Low", kind: feature-kind.passive, questions: "What happened to the rations? What drastic measures does the crew take to ensure they don’t all die of hunger and thirst?", "The first time a PC rolls a failure with Fear on this journey, the crew discovers that the food and fresh water in the ship’s hold have been befouled by pests and mold. Until the party reaches its destination, a PC who makes an action roll to advance the Open Water Countdown must succeed on a Strength Reaction Roll or mark a Stress first."),
    feature("“Pirates!”", kind: feature-kind.action, questions: "Does the captain recognize the ship that’s giving chase? What ungentlemanly practices are the pirates in this area famous for?", "Spend a Fear to have a crewmember in the crow’s nest spy black sails on the horizon! Start a Consequence Countdown (4). If it triggers before the party reaches their destination, the pirates catch up to the ship and board it. Gain a Fear, then summon one Pirate Captain and three Hordes of Pirate Raiders within Close range of the party."),
    feature("Foul Weather", kind: feature-kind.reaction, questions: "What makes this weather different from anything the PCs have experienced before? How do they coordinate with the crew to find their way through this hazard?", "When the Open Water Countdown ticks down to an odd number, roll a d6. On a result of 4 or higher, the ship runs into a patch of foul weather, such as a fog bank that makes navigation difficult or a squall that threatens to capsize the ship. Each PC must succeed on a reaction roll using a relevant trait chosen by the GM or mark 1d4 Stress."),
    feature("Here There Be Monsters", kind: feature-kind.reaction, questions: "What attracts these creatures to the ship? Is there any way to drive them off without combat?", "When the Open Water Countdown ticks down to an even number, roll a d6. On a result of 4 or higher, summon 1d4 Deep Sea Denizens."),
  ),
  flags: source(171),
)

#let witchs-hut = environment(
  id: "witchs-hut",
  name: "Witch’s Hut",
  tier: 2,
  type: environment-type.exploration,
  description: "A rustic, windowless hut sitting atop two huge chicken legs.",
  impulses: "Creep them out, delay them until the witch’s return, lock them inside, move to a different location, tempt them with magical oddities",
  difficulty: 14,
  potential-adversaries: "Chicken-Foot Hut, Enchanted Defenses (Gargoyle, Ravenous Mockery, Scarecrow), Valdenhax, The Witch’s Victims (Jack-o’-Lanterns, Redcap Biters)",
  features: (
    feature("Bigger on the Inside", kind: feature-kind.passive, questions: "Is there any pattern to the way the hut rearranges itself? What is the most surprising location the PCs could find here?", "Though the hut’s exterior is a rustic single-room cottage, the interior is an ever-shifting estate of haunting splendor replete with numerous bedrooms, libraries, and indoor gardens, among other mysterious installations."),
    feature("Creepy Doll Collection", kind: feature-kind.passive, questions: "Who were these dolls before? Is there any way to free them from their imprisonment?", "Countdown (5). Throughout the hut, the PCs can see many, many porcelain or wooden dolls with strangely lifelike eyes. When the party first enters a doll’s line of sight, activate the countdown. It ticks down when a PC fails a roll or rolls with Fear. When it triggers, the dolls come to life and attack. Summon a number of living dolls (Redcap Biters) equal to twice the number of PCs."),
    feature("Witches’ Brew", kind: feature-kind.passive, questions: "What sorts of concoctions does the witch who owns this hut specialize in? What would the witch do if they found the PCs using their things?")[
      #"The hut contains a workshop with every tool or component a witch could need, including a large iron cauldron set atop a smoldering fire. A PC who wants to use the workshop can make a Spellcast Roll to craft a magic potion or poison from the Consumables table."

      - #"Any Failure: The experiment blows up in their face—literally. The PC takes 2d10+2 magic damage."
      - #"Any Success: The PC rolls a number of d12s equal to 1 + their tier, adds the results together, and gains the consumable that matches that value on the Consumables table. If they critically succeeded, they can reroll any d12s showing a result of 1."
    ],
    feature("Dislocated", kind: feature-kind.reaction, questions: "Why does the hut move so often? Where does it wish to bring the PCs? Is there any way to aim it at a specific location?", "Time moves differently inside the Witch’s Hut. When the door to the hut is closed, roll a d6. On a result of 4 or higher, the hut moves to a different—often impossibly far–location that’s only revealed to the PCs when they open the hut’s door again."),
  ),
  flags: source(172),
)

#let vast-desert = environment(
  id: "vast-desert",
  name: "Vast Desert",
  tier: 2,
  type: environment-type.traversal,
  description: "A parched expanse of sandy dunes, desolate salt flats, and windblown rock formations.",
  impulses: "Dehydrate, show desolate beauty, threaten danger on the horizon",
  difficulty: 14,
  potential-adversaries: "Acid Burrower, Desert Raiders (Jagged Knife Bandits), Landshark, Sandwyrm",
  features: (
    feature("Endless Sands", kind: feature-kind.passive, questions: "How do the PCs travel through the desert? What beyond the extreme distance and lack of water makes this area difficult to cross?", "Countdown (8). To cross the desert, the party must complete the countdown. It ticks down whenever a PC succeeds on an action roll to navigate the seemingly endless expanse."),
    feature("Water Supply", kind: feature-kind.passive, questions: "What sorts of water-preserving flora or terrain features have the PCs heard might be found in this desert? How do the PCs collect and carry the water they find?", "When the party starts their journey, place a number of tokens on this stat block equal to 1 + the number of PCs in the scene. Remove a token at the end of each long rest or when a PC fails an action roll to navigate the desert. When a token would be removed but there are none left, each PC must mark a HP and a Stress. A PC can add a token to this stat block by using a downtime move and making a successful Knowledge Roll to hunt for water."),
    feature("Shifting Sands", kind: feature-kind.passive, questions: "How do the dunes and landscape shift whenever the heroes rest? What is covered or uncovered by the wind?", "The ever-shifting dunes and the whipping wind make trailing creatures through this environment difficult. Action rolls to track creatures through the desert are made with disadvantage."),
    feature("Thunderstorm", kind: feature-kind.action, questions: "How does the storm look to the heroes as it rolls in from miles away? Is the storm natural or unnatural? How can you tell?")[
      #"Spend a Fear to have a torrential downpour soak the land. Each PC must either seek shelter from the storm or collect rainwater. Each PC who seeks shelter marks a Stress. The PCs who collect rainwater make a group action roll."

      - #"On a success with Hope, add 1d4 tokens to the Water Supply."
      - #"On a success with Fear, add 1 token to the Water Supply."
      - #"On a failure with Hope, each PC who took part in the group action roll marks a Stress."
      - #"On a failure with Fear, each PC who took part in the group action roll marks a Stress, and the PC who rolled the lowest takes 2d8+4 physical damage from the storm."
    ],
    feature("Sandstorm", kind: feature-kind.action, questions: "What do the dwellers of this desert wear to weather the sandstorms? How are the dwelling places the party finds here designed to withstand the winds?", "Spend a Fear to summon a sandstorm that disorients and harries travelers. Each PC takes 2d6+3 physical damage. Until the sandstorm dissipates, a PC who makes an action roll must succeed on an Agility Reaction Roll to avoid the swirl of rocks and debris or take 2d6+3 physical damage."),
  ),
  flags: source(172),
)

/// Every environment in this file, in SRD order.
#let entries = (beach-day, cult-ritual, deadly-dungeon, duel, hallowed-temple, haunted-city, masquerade-ball, heist, mountain-pass, ocean-voyage, witchs-hut, vast-desert,)
