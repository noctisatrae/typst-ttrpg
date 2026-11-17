// Tier 3 environments, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Extracted with scripts/srd (environments.py, emit.py) and cross-checked against
// the SRD text with checkdata.py. Text is verbatim except: line breaks
// joined; the SRD's inline emphasis is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": environment, environment-type, feature-kind, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let archmages-tower = environment(
  id: "archmages-tower",
  name: "Archmage’s Tower",
  tier: 3,
  type: environment-type.exploration,
  description: "An impossibly tall spire that pierces the heavens and resonates with immense power.",
  impulses: "Collect magical energy, exhaust intruders, reveal the unknown, unleash bursts of magical power",
  difficulty: 16,
  potential-adversaries: "Alchemical Creations (Chimera, Lamia, Manticore), Archmage",
  features: (
    feature("Mystical Defenses", kind: feature-kind.passive, questions: "What do the designs of the archmage’s defenses tell you about their specific area of expertise? What signature style or flourish do the traps and hazards all share?", "Countdown (12). To climb the tower, the PCs must complete the countdown. On a failure or a roll with Fear, they trigger one of the archmage’s many arcane traps and hazards, taking 3d10 magic damage. On a failure with Fear, the damage dealt gains a bonus equal to the PC’s level."),
    feature("Archmage’s Aerie", kind: feature-kind.passive, questions: "What part of the aerie calls to you? What do the archmage’s notes reveal to you?", "The top floor of the tower is a many-chambered laboratory, library, and workshop containing everything needed to study magic in its highest forms. A PC with a Spellcast Trait can make a Knowledge Roll to partake in the archmage’s research. On a success, they gain a +1 bonus to their Spellcast Rolls until their next long rest. On a failure, their investigation goes wrong, and they take 3d8+4 magic damage."),
    feature("Amalgamated Adversaries", kind: feature-kind.reaction, questions: "Which creatures has the archmage chosen to combine? What do they hope to learn in doing so?", "Spend a Fear to summon two adversaries within Close range of a PC. Each adversary can use the other’s features as if they were their own."),
  ),
  flags: source(173),
)

#let astral-realm = environment(
  id: "astral-realm",
  name: "Astral Realm",
  tier: 3,
  type: environment-type.traversal,
  description: "A psychic realm of energy and emotion, where the strong in spirit can reshape the rules of reality.",
  impulses: "Attack their psyches, summon their subconscious fears, warp their perceptions",
  difficulty: 16,
  potential-adversaries: "Demon of Despair, Elemental Spark, Pain Priest, Psychic Vampires (Head Vampire, Night Children)",
  features: (
    feature("Out-of-Body Experience", kind: feature-kind.passive, questions: "How does the projection of your mental self-image differ from your physical appearance? Which one do you consider the “real” you?", "Because the party isn’t physically in this realm, Strength, Agility, and Finesse Rolls automatically fail. Additionally, when a character would mark a HP, they must lose a Hope or mark a Stress instead. If a character can’t mark a Stress, they must make a death move."),
    feature("Mental Manifestations", kind: feature-kind.passive, questions: "Is the construct you manifest a memory from real life or a figment of your own imagination? What key detail do you focus on to make it more stable?", "With a successful Knowledge Roll, PCs can alter the psychic environment, such as by inverting gravity or conjuring a rapidly self-assembling staircase. A PC can use a mental manifestation once per scene to gain advantage on a roll to navigate the Astral Realm."),
    feature("Matter Is Illusion", kind: feature-kind.passive, questions: "Do you think or feel your way through this place? What difference does it make here?", "Countdown (10). Time and distance are relative here, and simply moving through the space requires an act of will. To cross the Astral Realm, the party must complete the countdown using only Knowledge, Instinct, or Presence Rolls. On a failure with Fear, a PC takes 3d8 direct magic damage."),
    feature("Astral Adversaries", kind: feature-kind.passive, questions: "How does an adversary’s astral form differ from their physical form? Why are these psychic projections drawn to the PCs?", "Adversaries in the Astral Realm are immune to physical damage, as they are psychic projections instead of flesh and blood."),
  ),
  flags: source(173),
)

#let castle-siege = environment(
  id: "castle-siege",
  name: "Castle Siege",
  tier: 3,
  type: environment-type.event,
  description: "An active siege with an attacking force fighting to gain entry to a fortified castle.",
  impulses: "Bleed out the will to fight, breach the walls, build tension",
  difficulty: 17,
  potential-adversaries: "Mercenaries (Harrier, Sellsword, Spellblade, Weaponmaster), Noble Forces (Archer Squadron, Conscript, Elite Soldier, Knight of the Realm)",
  features: (
    feature("Secret Entrance", kind: feature-kind.passive, questions: "How do they get in without revealing the pathway to the attackers? Are any of the defenders monitoring this path?", "A PC can find or recall a secret way into the castle with a successful Instinct or Knowledge Roll."),
    feature("Siege Weapons (Environment Change)", kind: feature-kind.action, questions: "What siege weapons are being deployed? Are they magical, mundane, or a mixture of both? What defenses must the characters overcome to storm the castle?", "Consequence Countdown (6). The attacking force deploys siege weapons to try to raze the defenders’ fortifications. Activate the countdown when the siege begins (for a protracted siege, make this a long-term countdown instead). When it triggers, the defenders’ fortifications have been breached and the attackers flood inside. You gain 2 Fear, then shift to the Pitched Battle environment and spotlight it."),
    feature("Reinforcements!", kind: feature-kind.action, questions: "Who are they targeting first? What formation do they take?", "Summon a Knight of the Realm, a number of Tier 3 Minions equal to the number of PCs, and two adversaries of your choice within Far range of a chosen PC as reinforcements. The Knight of the Realm immediately takes the spotlight."),
    feature("Collateral Damage", kind: feature-kind.reaction, questions: "What debris is scattered by the attack? What is broken by the strike that can’t be easily mended?")[
      #"When an adversary is defeated, you can spend a Fear to have a stray attack from a siege weapon hit a point on the battlefield. All targets within Very Close range of that point must make an Agility Reaction Roll."

      - #"Targets who fail take 3d8+3 physical or magic damage and must mark a Stress."
      - #"Targets who succeed must mark a Stress."
    ],
  ),
  flags: source(174),
)

#let burning-heart-of-the-woods = environment(
  id: "burning-heart-of-the-woods",
  name: "Burning Heart of the Woods",
  tier: 3,
  type: environment-type.exploration,
  description: "Thick indigo ash fills the air around a towering moss-covered tree that burns eternally with flames a sickly shade of blue.",
  impulses: "Beat out an uncanny rhythm for all to follow, corrupt the woods",
  difficulty: 16,
  potential-adversaries: "Beasts (Bear, Glass Snake), Elementals (Elemental Spark), Verdant Defenders (Dryad, Oak Treant, Stag Knight)",
  features: (
    feature("Chaos Magic Locus", kind: feature-kind.passive, questions: "What does it feel like to work magic in this chaos-touched place? What do you fear will happen if you lose control of the spell?", "When a PC makes a Spellcast Roll, they must roll two Fear Dice and take the higher result."),
    feature("The Indigo Flame", kind: feature-kind.passive, questions: "What Fallen cult corrupted these woods? What have they already done with the cursed wood and sap from this tree?")[
      #"PCs who approach the central tree can make a Knowledge Roll to try to identify the magic that consumed this environment."

      - #"On a success: They learn three of the below details. On a success with Fear, they learn two."
      - #"On a failure: They can mark a Stress to learn one and gain advantage on the next action roll to investigate this environment."
      - #"Details: This is a result of Fallen magic. The corruption is spread through the ashen moss. It can be cleansed only by a ritual of nature magic with a Progress Countdown (8)."
    ],
    feature("Grasping Vines", kind: feature-kind.action, questions: "What painful memories do the vines bring to the surface as they pierce flesh?", "Animate vines bristling with thorns whip out from the underbrush to ensnare the PCs. A target must succeed on an Agility Reaction Roll or become Restrained and Vulnerable until they break free, clearing both conditions, with a successful Finesse or Strength Roll or by dealing 10 damage to the vines. When the target makes a roll to escape, they take 1d8+4 physical damage and lose a Hope."),
    feature("Charcoal Constructs", kind: feature-kind.action, questions: "Are these real animals consumed by the flame or merely constructs of the corrupting magic?", "Warped animals wreathed in indigo flame trample through a point of your choice. All targets within Close range of that point must make an Agility Reaction Roll. Targets who fail take 3d12+3 physical damage. Targets who succeed take half damage instead."),
    feature("Choking Ash", kind: feature-kind.reaction, questions: "What hallucinations does the ash induce? What incongruous taste does it possess?", "Countdown (Loop 6). When the PCs enter the Burning Heart of the Woods, activate the countdown. When it triggers, all characters must make a Strength or Instinct Reaction Roll. Targets who fail take 4d6+5 direct physical damage. Targets who succeed take half damage. Protective masks or clothes give advantage on the reaction roll."),
  ),
  flags: source(174),
)

#let crystal-wasteland = environment(
  id: "crystal-wasteland",
  name: "Crystal Wasteland",
  tier: 3,
  type: environment-type.traversal,
  description: "A harsh and alien landscape that shines with towers of glittering crystal.",
  impulses: "Cut them to their core, fracture their psyches, show their true reflection",
  difficulty: 16,
  potential-adversaries: "Adult Flickerfly, Constructs, Elemental Spark, Vault Guardians, Whisper Wraiths",
  features: (
    feature("Harmonic Resonance", kind: feature-kind.passive, questions: "How does attunement to this place alter your sensory experience of it? What sound or song from your childhood does this place conjure?", "The crystals here reverberate with magical energy. A PC can use a downtime move to try to Attune to the environment with a successful Spellcast Roll. While Attuned, the PC has advantage on Spellcast Rolls inside the Crystal Wasteland. The condition is cleared when the PC leaves the Crystal Wasteland."),
    feature("Gravitational Anomalies", kind: feature-kind.action, questions: "What does it feel like as your body and mind fight to reestablish equilibrium? Is there any way to use this to your advantage?", "Strange, localized phenomena dot the landscape, warping distance and direction. Spend a Fear to alter the gravity at a chosen point. Each target within Close range of that point must make a Knowledge Reaction Roll to calculate their new trajectories. Targets who fail take 3d8+4 physical damage as they are thrown up and away. Targets who succeed must mark a Stress or take half damage."),
    feature("Arcane Reflection", kind: feature-kind.action, questions: "Who do the PCs see on the other side of the crystal? How does it make them feel?", "Spend a Fear to have any number of PCs glimpse a reflection in the crystal of who they once were or might become. Each target must make an Instinct Reaction Roll. Targets who succeed see a vision of their better self and can replace one Experience. Targets who fail see a vision of their dark past—or an even darker future—and must mark a Stress. You gain a Fear for each target who failed."),
    feature("Razor-Sharp Terrain", kind: feature-kind.reaction, questions: "What does the crystal look like as it grows? What does it feel like?", "When a PC fails a roll to navigate the wasteland, they must make a Finesse Reaction Roll. On a failure, they cut themselves on the sharp edges of the terrain. Shards of magic crystal become embedded in their wound and slowly grow, Crystallizing them. Activate a Crystal Countdown (1) for that PC. Until they remove the condition with a successful Knowledge Roll, a Crystallizing PC ticks up their Crystal Countdown at the start of each rest and gains a penalty to their Evasion equal to its value. The countdown ends when the condition is cleared."),
    feature("Psychic Shuffle", kind: feature-kind.reaction, questions: "How does it feel being in someone else’s skin? If you could choose to stay like them in one way, what would it be?", "When the PCs take a long rest, you can spend a Fear to swap their psyches. Collect all the players’ character sheets, then shuffle and randomly redistribute them. Each character sheet comes with that PC’s Domain cards and player aids. A PC can regain their psyche with a successful Knowledge Roll, at which point they trade sheets with the player who has their original character sheet."),
  ),
  flags: source(175),
)

#let dragons-lair = environment(
  id: "dragons-lair",
  name: "Dragon’s Lair",
  tier: 3,
  type: environment-type.exploration,
  description: "A collection of gold, jewels, and artifacts in the heart of an active volcano.",
  impulses: "Lure into the levels below, make escape impossible, tempt with treasure, wake the dragon",
  difficulty: 16,
  potential-adversaries: "The Dragon’s Minions (Drake, Wyvern), Young Fire Dragon",
  features: (
    feature("The Dragon Wakes", kind: feature-kind.passive, questions: "Where does this dragon slumber? What does it dream about?", "Consequence Countdown (8). The dragon that amassed this treasure lies sleeping somewhere on, under, or near the hoard. When the PCs enter the lair, activate the countdown. When it triggers, the dragon awakens and each PC must succeed on a Presence Reaction Roll or mark a Stress. You gain a Fear for each Stress marked this way."),
    feature("Treasure Hoard", kind: feature-kind.passive, questions: "How did the party learn of this collection? What do they hope to find here?", "At the heart of the lair sits a mountain of treasure. If the party wishes to locate the treasure, they must complete a Progress Countdown (12). When it triggers, the party can tick down the Consequence Countdown to search through the treasure mound by rolling a number of d12s equal to 1 + their tier on the Item or Consumable table (their choice)."),
    feature("Volcanic Activity", kind: feature-kind.action, questions: "What paths of egress are blocked by the volcano’s shifting configuration? How do the PCs protect themselves from the stifling heat?", "Spend a Fear to trigger a volcanic eruption. Each character must make an Agility Reaction Roll. Targets who fail are burned by gouts of lava and flame as the earth breaks around them and take 3d8+5 physical damage. Targets who succeed take half damage."),
    feature("Watchdogs", kind: feature-kind.reaction, questions: "Why do these creatures serve the slumbering dragon? What signs does the party find that foreshadow their presence?", "When a PC fails a roll to navigate the lair, you can spend a Fear to summon 1d6 Drakes and up to two Wyverns, who appear within Close range of a PC and are immediately spotlighted."),
  ),
  flags: source(175),
)

#let pitched-battle = environment(
  id: "pitched-battle",
  name: "Pitched Battle",
  tier: 3,
  type: environment-type.event,
  description: "A massive combat between two large groups of armed combatants.",
  impulses: "Seize people, land, and wealth, spill blood for greed and glory",
  difficulty: 17,
  potential-adversaries: "Mercenaries (Sellsword, Harrier, Spellblade, Weaponmaster), Noble Forces (Archer Squadron, Conscript, Elite Soldier, Knight of the Realm)",
  features: (
    feature("Adrift on a Sea of Steel", kind: feature-kind.passive, questions: "Do the combatants mistake you for the enemy or consider you interlopers? Can you tell the difference between friend and foe in the fray?", "Traversing a battlefield during an active combat is extremely dangerous. A PC must succeed on an Agility Roll to move at all, and can only go up to Close range on a success. If an adversary is within Melee range of them, they must mark a Stress to make an Agility Roll to move."),
    feature("Raze and Pillage", kind: feature-kind.action, questions: "What is valuable here? Who is most vulnerable?", "The attacking force raises the stakes by lighting a fire, stealing a valuable asset, kidnapping an important person, or killing the populace."),
    feature("War Magic", kind: feature-kind.action, questions: "What form does the attack take—fireball, raining acid, a storm of blades? What tactical objective is this attack meant to accomplish, and what comes next?", "Spend a Fear as a mage from one side uses large-scale destructive magic. Pick a point on the battlefield within Very Far range of the mage. All targets within Close range of that point must make an Agility Reaction Roll. Targets who fail take 3d12+8 magic damage and must mark a Stress."),
    feature("Reinforcements!", kind: feature-kind.action, questions: "Who are they targeting first? What formation do they take?", "Summon a Knight of the Realm, a number of Tier 3 Minions equal to the number of PCs, and two adversaries of your choice within Far range of a chosen PC as reinforcements. The Knight of the Realm immediately takes the spotlight."),
  ),
  flags: source(176),
)

#let megastorm = environment(
  id: "megastorm",
  name: "Megastorm",
  tier: 3,
  type: environment-type.event,
  description: "An extreme weather event suddenly manifests, forcing the party to balance their own survival against the safety of others.",
  impulses: "Blow hurricane winds, choke with mudslides, crumble structures, flood, throw debris, light up the sky",
  difficulty: 16,
  potential-adversaries: "Greater Water Elemental, Storm Titan",
  features: (
    feature("Stormfront", kind: feature-kind.passive, questions: "Where is the safest place to weather the storm? What are the people here willing to risk their lives for?", "Countdown (8). When the storm arrives, activate the countdown. It ticks down when a PC rolls with Hope. When it triggers, the storm disperses or moves on to a different area."),
    feature("Hazardous Conditions", kind: feature-kind.passive, questions: "Who else lost in the gyre? How can you lead them out?", "The Megastorm’s extreme wind, fog, and cloud cover make navigating the entire area difficult. PCs can’t move as part of an action roll without succeeding on an Agility Reaction Roll."),
    feature("Bomb Cyclone", kind: feature-kind.action, questions: "Is this the worst weather any of the PCs have experienced? What in the immediate area can the PCs use to protect themselves?", "Spend a Fear to summon an extreme weather event, such as a thunderstorm or tornado, at a point of your choice. Each target within Close range of that point must succeed on a reaction roll using a trait you choose to avoid being pummeled by hail, thrown into the air, blasted by lightning, or a similar effect. Targets who fail take 2d10+2 damage of a type you choose."),
    feature("Stormheart", kind: feature-kind.action, questions: "Did this creature conjure the storm for their own purposes, or do they serve an even greater entity? Why did they designate this place for destruction?", "Spend a Fear to reveal the living battery of the Megastorm. Summon a Storm Giant or Greater Water Elemental within Far range of a PC, then immediately spotlight them. Until this adversary is defeated, the “Stormfront” countdown doesn’t tick down. When this adversary is defeated, the Megastorm ends."),
    feature("Panic in the Streets", kind: feature-kind.action, questions: "Who’s taking advantage of the situation? Who’s supposed to be in charge here, and what happened to them?", "The Megastorm is sowing fear and chaos among the locals. Describe how the storm puts an NPC in danger. If the PC who next takes the spotlight doesn’t use their action to rescue the endangered NPC, you gain a Fear."),
  ),
  flags: source(176),
)

#let sunken-citadel = environment(
  id: "sunken-citadel",
  name: "Sunken Citadel",
  tier: 3,
  type: environment-type.exploration,
  description: "The sunken ruins of a long-lost civilization filled with ancient technology and dark magic.",
  impulses: "Draw them deep, drown them, reveal ancient wonders",
  difficulty: 16,
  potential-adversaries: "Cursed Merfolk, Deep Dweller, Plesiosaurus",
  features: (
    feature("Underwater Environment", kind: feature-kind.passive, questions: "Have you ever known anyone who drowned? What do you think about to keep calm and stretch your air supply?", "This environment is underwater (see the “Moving and Fighting Underwater” rules on page 168 of the core rulebook). In addition to those rules, a creature who breathes air tracks their supply with an Air Supply Countdown. Its starting value is equal to 3 + their tier, and it ticks down when they take an action. If a PC fails an action roll or rolls with Fear, you can use a GM move to tick down their countdown an additional time. If the roll is a failure with Fear, you can tick it down twice instead. Once their countdown triggers, a PC must mark a Stress whenever they take an action underwater until they resurface."),
    feature("Air Pockets", kind: feature-kind.passive, questions: "What signs or structures do you look for? What does it feel like to know this might be the last breath you take?", "A PC can reset their their Air Supply Countdown to its starting value by locating a pocket of air with a successful Knowledge or Instinct Roll."),
    feature("Lost Technology", kind: feature-kind.passive, questions: "Who once called this place home? How did their technology work? Why were they ultimately destroyed and cast down into the depths?", "The ruins are carved with strange magical runes and littered with lost technology. A PC can make a Knowledge Roll to learn useful information about this lost civilization from any runes or devices they come across."),
    feature("Deepwater Denizens", kind: feature-kind.action, questions: "Why do these creatures stay here among the ruins? Are they unwilling or unable to resurrect this once-prosperous civilization?", "Spend a Fear to summon up to two Deep Dwellers and 1d6 Cursed Merfolk who try to bind the PCs to their will. These adversaries appear at Close range of a PC, then one immediately takes the spotlight."),
  ),
  flags: source(177),
)

#let upscale-casino = environment(
  id: "upscale-casino",
  name: "Upscale Casino",
  tier: 3,
  type: environment-type.social,
  description: "A glittering gambling hall where well-heeled merchants and nobles come to fritter away their fortunes.",
  impulses: "Dangle the jackpot just out of reach, dazzle them with spectacle, prey on their vices",
  difficulty: 16,
  potential-adversaries: "Automated Security (Vault Guardians), Gamblers (Courtesan, Merchant Baron, Petty Noble, Spy)",
  features: (
    feature("Glitz & Glamor", kind: feature-kind.passive, questions: "What’s so wondrous about the casino’s trappings? Are they truly magical in nature or merely mundane wonders taken to an impossible extreme?", "The overwhelming spectacle of this place can entrance even the most jaded patron. While here, all PCs have disadvantage on reaction rolls caused by a staff member or regular patron of the casino."),
    feature("Fortune Favors the Bold", kind: feature-kind.passive, questions: "What game does the PC choose to play? What house rules does this casino have? Is there anything besides gold the PCs are willing to risk?", "Once per long rest, a PC can gamble any amount of gold by stating how much they want to wager and rolling their Hope Die. On a result of 7 or higher, the PC wins an equal amount, doubling their money. On a result of 6 or lower, they lose it all."),
    feature("The House Always Wins", kind: feature-kind.reaction, questions: "Is this place blessed with impossible fortune, or does something curse anyone who steps through its doors?", "When an adversary fails a roll, you can spend a Fear to make it a success instead."),
    feature("Automated Security", kind: feature-kind.reaction, questions: "Who built these machines? Why are they preferable to living beings?", "When a PC attempts to cheat at a game in the casino and fails, they must mark a Stress as they activate the casino’s mechanical security detail. Gain a Fear and summon one Vault Guardian Gaoler and Turret for each PC, plus a Vault Guardian Sentinel. All adversaries appear within Far range of the PCs, and the Vault Guardian Sentinel immediately takes the spotlight."),
    feature("The Devil’s Playground", kind: feature-kind.reaction, questions: "How did the demon mask their influence until now? How does the casino itself change to reveal its true nature?", "If the PCs defeat the casino’s automated security or try to leave with stolen winnings, you can spend an amount of Fear equal to the number of PCs to summon the casino’s true owner, a Demon of Avarice, within Close range of a PC. The Demon is immediately spotlighted and bars the party’s exit at all costs."),
  ),
  flags: source(177),
)

#let volcanic-eruption = environment(
  id: "volcanic-eruption",
  name: "Volcanic Eruption",
  tier: 3,
  type: environment-type.event,
  description: "An explosion of heat and molten rock that leaves behind only charred desolation.",
  impulses: "Create panic all around, cut off the exits, isolate, make them scramble for safety, split the party",
  difficulty: 16,
  potential-adversaries: "Elemental Spark, Lava Elemental (Greater Earth Elemental), Volcanic Dragon",
  features: (
    feature("Unstable Ground", kind: feature-kind.passive, questions: "What strange shapes and colors do the PCs see in the cooled lava? How do the people who live nearby keep their footing on the slick, shiny surface?", "The ground here is uneven, prone to collapse, and constantly shifting. PCs who fail an Agility Roll to move must mark a HP and are temporarily Restrained."),
    feature("Violent Eruption", kind: feature-kind.action, questions: "What makes the lava seem alive? How can the PCs predict its behavior?", "Spend a Fear to have the ground erupt at a point of your choice, spewing lava into the air and spreading it along the ground. All targets within Very Close range of that point lose a Hope and take 3d8+3 physical damage. The area within Very Close range of the eruption point becomes lava until the end of the scene. A creature who moves into or through the lava takes 3d8+3 physical damage. Until the end of the scene, you can spend a Fear to expand the lava area by one step (such as Very Close to Close or Close to Far)."),
    feature("Vent Toxic Gas", kind: feature-kind.action, questions: "What signs do you see to indicate the presence of toxic gas? What taste lingers in the mouths of the PCs who inhale the gas?", "Spend a Fear to open a fissure that belches out toxic gas at a point of your choice, creating a cloud that blankets everything within Far range. While inside the cloud, a PC must track their air supply with an Air Supply Countdown. Its starting value is equal to 3 + their tier, and it ticks down when they take an action. If a PC fails an action roll or rolls with Fear, you can use a GM move to tick down their countdown an additional time. If the roll is a failure with Fear, you can tick it down twice instead. Once the countdown ends, a PC must mark a Stress whenever they take an action within the gas until they escape the cloud."),
  ),
  flags: source(178),
)

/// Every environment in this file, in SRD order.
#let entries = (archmages-tower, astral-realm, castle-siege, burning-heart-of-the-woods, crystal-wasteland, dragons-lair, pitched-battle, megastorm, sunken-citadel, upscale-casino, volcanic-eruption,)
