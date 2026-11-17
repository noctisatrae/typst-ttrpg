// Tier 1 environments, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Extracted with scripts/srd (environments.py, emit.py) and cross-checked against
// the SRD text with checkdata.py. Text is verbatim except: line breaks
// joined; the SRD's inline emphasis is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": environment, environment-type, feature-kind, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let abandoned-grove = environment(
  id: "abandoned-grove",
  name: "Abandoned Grove",
  tier: 1,
  type: environment-type.exploration,
  description: "A former druidic grove lying fallow and fully reclaimed by nature.",
  impulses: "Draw in the curious, echo the pastDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Beasts (Bear, Dire Wolf, Glass Snake), Grove Guardians (Minor Treant, Sylvan Soldier, Young Dryad)",
  features: (
    feature("Overgrown Battlefi eld", kind: feature-kind.passive, questions: "Why did these groups come to blows? Why is the grove unused now?")[
      #"There has been a battle here. A PC can make an Instinct Roll to identify evidence of that fi ght. On a success with Hope, learn all three pieces of information below. On a success with Fear, learn two. On a failure, a PC can mark a Stress to learn one and gain advantage on the next action roll to investigate this environment. A PC with an appropriate background or Experience can learn an additional detail and ask a follow-up question about the scene and get a truthful (if not always complete) answer."

      - #"Traces of a battle (broken weapons and branches, gouges in the ground) litter the ground."
      - #"A moss-covered tree trunk is actually the corpse of a treant."
      - #"Still-standing trees are twisted in strange ways, as if by powerful magic."
    ],
    feature("Barbed Vines", kind: feature-kind.action, questions: "How many vines are there? Where do they grab you? Do they pull you down or lift you off the ground?", "Pick a point within the grove. All targets within Very Close range of that point must succeed on an Agility Reaction Roll or take 1d8+3 physical damage and become Restrained by barbed vines. Restrained lasts until they’re freed with a successful Finesse or Strength roll or by dealing at least 6 damage to the vines."),
    feature("You Are Not Welcome Here", kind: feature-kind.action, questions: "What are the grove guardians concealing? What threat to the forest could the PCs confront to appease the Dryad?", "A Young Dryad, two Sylvan Soldiers, and a number of Minor Treants equal to the number of PCs appear to confront the party for their intrusion."),
    feature("Defi ler", kind: feature-kind.action, questions: "What color does the grass turn as the elemental appears? How does the chaos warp insects and small wildlife within the grove?", "Spend a Fear to summon a Minor Chaos Elemental drawn to the echoes of violence and discord. They appear within Far range of a chosen PC and immediately take the spotlight."),
  ),
  flags: source(160),
)

#let abandoned-mine = environment(
  id: "abandoned-mine",
  name: "Abandoned Mine",
  tier: 1,
  type: environment-type.traversal,
  description: "A twisting warren of disused tunnels carved out of the bedrock by a doomed mining outfi t.",
  impulses: "Poison the party with deadly gasses, rumble and collapse, split the party, turn them aroundDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Darkweave Spiders (Darkweave Crawler, Darkweave Spinner, Darkweave Swarmlings), Miner Ghosts (Poltergeist, Will-o’-the-Wisps)",
  features: (
    feature("Pitch Black", kind: feature-kind.passive, questions: "What fuel does the party’s light source use, and how long will it last? What unwanted attention does the light attract?", "There is no light, natural or otherwise, in these underground mining tunnels. Ask the PCs what they use for light or how they otherwise fi nd their way in the dark. PCs without a reliable source of light make action and reaction rolls with disadvantage."),
    feature("Labyrinth", kind: feature-kind.passive, questions: "What did miners previously extract here? Who in the party knows how to navigate below ground? What are the PCs most afraid might happen to them down here?")[
      #"The party must complete a Progress Countdown (4) to fi nd their way through the mines. Each time a PC rolls with Hope while fi nding their way through, they discover one of the curiosities below."

      - #"An unmined vein of precious metals or gemstones"
      - #"Various mining tools, including a broken (but mendable) mine cart made of adamantine"
      - #"Psychic echoes of the miners’ tragic end"
      - #"The desiccated corpses of miners who lost their way in the tunnels"
      - #"Tattered remnants of darkweave spider silk"
    ],
    feature("Into the Spider’s Web", kind: feature-kind.action, questions: "How does the Darkweave Queen use her lair to her advantage? What remnants of her past meals can the party find here?", "Spend a Fear to summon a Darkweave Queen inside her gossamer-strewn lair. She drops from the ceiling within Close range of a PC and immediately takes the spotlight."),
    feature("Impending Collapse", kind: feature-kind.reaction, questions: "What other signs of instability does the mine offer the party? What new dangers does the tunnel system’s new configuration expose the party to?", "Countdown (2). The fi rst time the PCs roll with Fear, describe how the ground subtly vibrates as rocks shift overhead and activate the countdown. It ticks down when a PC rolls with Fear. When it triggers, each PC must succeed on an Agility Reaction Roll or take 1d8+3 physical damage and become temporarily Restrained by the rubble."),
  ),
  flags: source(160),
)

#let ambushed = environment(
  id: "ambushed",
  name: "Ambushed",
  tier: 1,
  type: environment-type.event,
  description: "An ambush is set to catch an unsuspecting party off -guard.",
  impulses: "Overwhelm, scatter, surroundDiffi culty: Special (see “Relative Strength”)",
  difficulty: "",
  potential-adversaries: "Any",
  features: (
    feature("Relative Strength", kind: feature-kind.passive, questions: "Who cues the ambush? What makes it clear they’re in charge?", "The Diffi culty of this environment equals that of the adversary with the highest Diffi culty."),
    feature("Surprise!", kind: feature-kind.action, questions: "What do the ambushers want from the party? How do their tactics in the ambush reflect that?", "The ambushers reveal themselves to the party, you gain 2 Fear, and the spotlight immediately shifts to one of the ambushing adversaries."),
  ),
  flags: source(161),
)

#let ambushers = environment(
  id: "ambushers",
  name: "Ambushers",
  tier: 1,
  type: environment-type.event,
  description: "An ambush is set by the PCs to catch unsuspecting adversaries off -guard.",
  impulses: "Escape, group up, protect the most vulnerableDiffi culty: Special (see “Relative Strength”)",
  difficulty: "",
  potential-adversaries: "Any",
  features: (
    feature("Relative Strength", kind: feature-kind.passive, questions: "Which adversary is the least prepared? Which one is the most?", "The Diffi culty of this environment equals that of the adversary with the highest Diffi culty."),
    feature("Where Did They Come From?", kind: feature-kind.reaction, questions: "What are the adversaries in the middle of doing when the ambush starts? How does this impact their approach to the fight?", "When a PC starts the ambush on unsuspecting adversaries, you lose 2 Fear and the fi rst attack roll a PC makes has advantage."),
  ),
  flags: source(161),
)

#let alchemists-abandoned-workshop = environment(
  id: "alchemists-abandoned-workshop",
  name: "Alchemist’s Abandoned Workshop",
  tier: 1,
  type: environment-type.exploration,
  description: "A lightning-powered laboratory built by a scientist searching for the secret to immortality.",
  impulses: "Break down the barrier between life and death, draw down lightning from the heavens, overclock the machineryDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Lab Leftovers (Construct, Minor Fire Elemental, Patchwork Zombie Hulk, Swarm of Rats)",
  features: (
    feature("Cabinet of Curiosities", kind: feature-kind.passive, questions: "What was the alchemist studying? What smell overwhelms you as you shuffle through their things?", "The workshop’s shelves, cupboards, and tables are cluttered with macabre bric-a-brac, including body parts in jars of formaldehyde and bloody surgical implements. Once per scene, a PC can make an Instinct Roll to look for something useful in the chaos."),
    feature("Strange Machinery", kind: feature-kind.passive, questions: "What do these machines do? What do these instruments measure?", "The workshop contains numerous pieces of bizarre technology and scientifi c instrumentation. A PC can make a Knowledge Roll to try to fi gure out how it works. On a success, they can get it running. On a failure, they break something and take 1d8+4 direct magic damage as they’re shocked by electricity and doused in caustic chemicals."),
    feature("It’s Alive!", kind: feature-kind.action, questions: "What was the alchemist trying to achieve with this experiment? Where did they get the materials for it?", "Consequence Countdown (6). A thunderstorm gathers overhead, threatening to jolt the lightning rod assembly installed atop the workshop. Activate the countdown and narrate how the storm’s power increases each time it ticks down when a PC makes an action roll. When it triggers, lightning strikes the rod assembly and overloads the workshop machinery, which explodes after resurrecting one of the alchemist’s abandoned projects. Each target within Close range of the machinery must succeed on an Agility Reaction Roll or take 1d10 magic damage. Summon a Failed Experiment at a location within the workshop and gain a Fear for each PC within Very Close range of it."),
  ),
  flags: source(161),
)

#let bustling-marketplace = environment(
  id: "bustling-marketplace",
  name: "Bustling Marketplace",
  tier: 1,
  type: environment-type.social,
  description: "The economic heart of the settlement, with local artisans, traveling merchants, and patrons across social classes.",
  impulses: "Buy low, and sell high, tempt and tantalize with wares from near and farDiffi culty: 10",
  difficulty: "",
  potential-adversaries: "Guards (Bladed Guard, Head Guard), Masked Thief, Merchant",
  features: (
    feature("Tip the Scales", kind: feature-kind.passive, questions: "Will any coin be accepted, or only local currency? How overt are the PCs in offering this bribe?", "PCs can gain advantage on a Presence Roll by off ering a handful of gold as part of the interaction."),
    feature("Unexpected Find", kind: feature-kind.action, questions: "What cost beyond gold will the merchant ask for in exchange for this rarity?", "Reveal to the PCs that one of the merchants has something they want or need, such as food from their home, a rare book, magical components, a dubious treasure map, or a magical key."),
    feature("Sticky Fingers", kind: feature-kind.action, questions: "What drove this person to pickpocketing? Where is the thief’s hideout and how has it avoided notice?", "A thief tries to steal something from a PC. The PC must succeed on an Instinct Roll to notice the thief or lose an item of the GM’s choice as the thief escapes to a Close distance. To retrieve the stolen item, the PCs must complete a Progress Countdown (6) to chase down the thief before the thief completes a Consequence Countdown (4) and escapes to their hideout."),
    feature("Crowd Closes In", kind: feature-kind.reaction, questions: "Where does the crowd’s movement carry them? How do they feel about being alone but surrounded?", "When one of the PCs splits from the group, the crowds shift and cut them off from the party."),
  ),
  flags: source(161),
)

#let corrupted-swamp = environment(
  id: "corrupted-swamp",
  name: "Corrupted Swamp",
  tier: 1,
  type: environment-type.traversal,
  description: "A wretched stretch of slimy water, toxic creatures, and decay.",
  impulses: "Corrupt, emphasize putrescence, reveal the twisted and unnatural, sickenDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Any Undead (Skeleton, Zombie, Spectral Guardian), Giant Rat, Green Ooze, Tangle Bramble",
  features: (
    feature("Swamp Sickness", kind: feature-kind.passive, questions: "Is the swamp teeming with life, filled with decay, or both? What force blighted this swamp, and what signs of its origins remain?", "At the end of a long rest, each PC must succeed on a Strength Reaction Roll or gain a d4 Sickened Die, starting with the 1 value facing up. If a PC fails this roll and already has a Sickened Die, they increase the value by 1, to a maximum value of 4. A PC with a Sickened Die gains a penalty to their action rolls equal to its value. When a PC with a Sickened Die would clear a HP, they can decrease the value of their Sickened Die by 1 instead. When the die’s value would fall to 0, remove it."),
    feature("Soggy and Slogging It", kind: feature-kind.passive, questions: "What creatures, living or otherwise, lurk beneath the water’s murky surface? Where or how do the PCs find relief from the stinking water?", "When a PC moves as part of an action, they can only move up to Very Close range. Action rolls made to move farther than Very Close range have disadvantage. Before rolling, a PC can mark a Stress to remove this disadvantage."),
    feature("Rotbloom", kind: feature-kind.action, questions: "How can you tell the plants that emit this pollen are carnivorous? What nightmares or dreamscapes does the pollen’s scent conjure?", "Spend a Fear to dust an area within Far range in noxious pollen. Each target in that area must succeed on a Strength or Instinct Reaction Roll or take 1d6+3 magic damage and become Vulnerable until the end of the scene."),
    feature("Dancing Lights", kind: feature-kind.action, questions: "What does the lost PC see in the lights that draws them into the darkness? What other glimpses of surprising beauty do the PCs encounter here?", "At the start of a rest, you can spend a Fear to have fl oating orbs enthrall the weary and lure a PC deeper into the swamp. A diff erent PC can use a downtime move to make an action roll to search for them. On a success, both PCs return to camp and can choose downtime moves as normal. On a failure—or if no one searches for them—the lost PC returns hours later, covered in mud and worse, and can’t choose downtime moves until their next rest."),
  ),
  flags: source(162),
)

#let cliffside-ascent = environment(
  id: "cliffside-ascent",
  name: "Cliffside Ascent",
  tier: 1,
  type: environment-type.traversal,
  description: "A steep, rocky cliff side tall enough to make traversal dangerous.",
  impulses: "Cast the unready down to a rocky doom, draw people in with promise of what lies at the topDiffi culty: 12",
  difficulty: "",
  potential-adversaries: "Construct, Deeproot Defender, Giant Scorpion, Glass Snake",
  features: (
    feature("The Climb", kind: feature-kind.passive, questions: "What strange formations are the stones arranged in? What ominous warnings did previous adventurers leave?")[
      #"Climbing up the cliff side uses a Progress Countdown (12). It ticks down according to the following criteria when the PCs make an action roll to climb:"

      - #"Critical Success: Tick down 3"
      - #"Success with Hope: Tick down 2"
      - #"Success with Fear: Tick down 1"
      - #"Failure with Hope: No advancement"
      - #"Failure with Fear: Tick up 1 When the countdown triggers, the party has made it to the top of the cliff ."
    ],
    feature("Pitons Left Behind", kind: feature-kind.passive, questions: "What do the shape and material of these pitons tell you about the previous climbers? How far apart are they from one another?", "Previous climbers left behind large metal rods that climbers can use to aid their ascent. If a PC using the pitons fails an action roll to climb, they can mark a Stress instead of ticking the countdown up."),
    feature("Fall", kind: feature-kind.action, questions: "How can you tell many others have fallen here before? What lives in these walls that might try to scare adventurers into falling for an easy meal?", "Spend a Fear to have a PC’s handhold fail, plummeting them toward the ground. If they aren’t saved on the next action, they hit the ground and tick up the countdown by 2. The PC takes 1d12 physical damage if the countdown is between 8 and 12, 2d12 between 4 and 7, and 3d12 at 3 or lower."),
  ),
  flags: source(162),
)

#let cursed-graveyard = environment(
  id: "cursed-graveyard",
  name: "Cursed Graveyard",
  tier: 1,
  type: environment-type.exploration,
  description: "A sprawling cemetery fi lled with crumbling headstones, twisted trees possessed by the dead, and crypts overgrown with moss and ivy.",
  impulses: "Bury them six feet deep, choke with fog, lure with promises of entombed treasure, unleash the restless deadDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Corrupted Spirits (Deeproot Defender, Phantom), Living Dead (Skeleton Warrior, Zombie Pack, Patchwork Zombie Hulk)",
  features: (
    feature("Room for One More", kind: feature-kind.passive, questions: "What new information or experience does a PC gain from becoming a specter? How can the party reunite the PC’s spirit with their flesh? What happens if their ritual goes wrong?", "If a PC marks their last HP while in the graveyard, they become a Specter instead of making a death move. While a Specter, a PC can communicate with the living but can’t interact with the physical world, and they must stay within Close range of their corpse or cross through the veil of death. This condition is cleared when the PC clears a HP."),
    feature("Hallowed Ground", kind: feature-kind.passive, questions: "Who sanctified this place, and what happened to them? What holy relics can be found here?", "At the center of the graveyard is a seemingly undisturbed chapel. On a successful Instinct Roll, a PC can discover this structure is sanctifi ed against the cemetery’s denizens. While inside the chapel, the PCs have advantage on action rolls to fi ght or drive off spirits and undead."),
    feature("Misty Miasma", kind: feature-kind.action, questions: "What horrors do the PCs see in the fog? What disorienting smell does the miasma emit?", "Spend a Fear to fi ll an area within Far range with a low-lying ectoplasmic fog that seeps up through the soggy earth. When a PC rolls with Fear while in the miasma, they must mark a Stress."),
    feature("The Dead Arise", kind: feature-kind.action, questions: "Who were these people in life? Why were they buried here? Why won’t they stay dead?", "Spend a Fear to have undead hands burst forth from the ground beneath a PC. The target must succeed on an Agility or Presence Reaction Roll or mark a Stress and become temporarily Restrained as hands grasp them."),
    feature("The Dead Don’t Die Easy", kind: feature-kind.reaction, questions: "Who commanded this land to reject death? How do the dead come back different here?", "When an adversary would mark their last HP, roll a d6. On a result of 5 or 6, the adversary doesn’t mark it."),
  ),
  flags: source(163),
)

#let grand-feast = environment(
  id: "grand-feast",
  name: "Grand Feast",
  tier: 1,
  type: environment-type.social,
  description: "A community-wide celebration featuring way too much drink, food, and fun.",
  impulses: "Bring everyone together, celebrate a momentous occasion, encourage revelrous abandonDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Apprentice Assassin, Guard, Merchant, Petty Noble, Sellsword, Spy",
  features: (
    feature("Loose Lips & Fast Friends", kind: feature-kind.passive, questions: "What is everyone celebrating? Where’s the party? Who’s footing the bill?", "Everyone is here to have a good time. PCs have advantage on Presence Rolls to socialize with other revelers."),
    feature("The Evening’s Entertainment", kind: feature-kind.action, questions: "What does the host want to see or hear more than anything else? What can they offer the PCs in return?", "The host of the feast kicks off the entertainment portion of the evening. Each PC can make an action roll to initiate a performance, competition, or other lighthearted diversion. A PC who succeeds becomes an Honored Guest. Until the feast ends, an Honored Guest can claim a gift from the host, then clear the condition."),
    feature("“There’s Always That One…”", kind: feature-kind.action, questions: "What makes this dud so unpleasant? What’s something the PC cares about that the dud constantly diminishes or dismisses? What boring or awful thing can the dud not shut up about?", "Spend a Fear to Trap a PC in conversation with the most unpleasant person at the party until the PC succeeds on an action roll to extricate themself from this social black hole. While Trapped, a PC can’t make action rolls except to try to clear this condition. When a Trapped PC fails an action roll, they must mark a Stress."),
    feature("Last Call", kind: feature-kind.reaction, questions: "What crazy stories do the PCs share with one another as they leave the party? Who do the PCs see unexpectedly canoodling afterward?", "After a long night, the partygoers start fi ltering out. When the feast concludes, all PCs who participated in the festivities clear all Stress and gain a Hope. Additionally, each Honored Guest clears all HP and gains an additional Hope, then clears the condition. Each PC who overindulged must succeed on a Strength Reaction Roll or become Hungover until their next rest. While Hungover, a PC gains a −1 penalty to action rolls."),
  ),
  flags: source(163),
)

#let hold-the-line = environment(
  id: "hold-the-line",
  name: "Hold the Line",
  tier: 1,
  type: environment-type.event,
  description: "The party must fend off multiple waves of enemies long enough for an ally to complete an important objective.",
  impulses: "Crash waves of enemies upon the party’s shores, never let them breathe, target their chargeDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Guards, Jagged Knives, Pirates, Skeletons, Zombies",
  features: (
    feature("Bodyguards", kind: feature-kind.passive, questions: "Who are the PCs protecting, and what is the Charge trying to do? Who wants to stop them? What will happen if the Charge isn’t able to complete their task?", "The PCs must protect an NPC (their “Charge”) long enough for the Charge to complete a task, such as fi nishing a magical ritual or repairing a mechanical device. At the start of the scene, activate a Task Countdown with a value equal to the number of PCs in the scene. It ticks down when the PCs defeat a wave of adversaries. When it triggers, the Charge completes their task."),
    feature("“I Must Not Fail!”", kind: feature-kind.passive, questions: "Why is this task so important to the Charge? What has the power to break their resolve?", "When the fi rst wave of adversaries appears, place a Resolve Countdown next to the Charge with a value equal to the number of PCs in the scene. When an adversary makes an attack against the Charge, the attack automatically succeeds and ticks down the Resolve Countdown. When it triggers, the Charge either fl ees, dies, or becomes incapacitated."),
    feature("Swarming Multitudes", kind: feature-kind.passive, questions: "Where does these foes’ newfound power come from? Is there any way to cut them off from it?", "All adversaries gain the “Relentless (2)” feature: They can be spotlighted up to two times per GM turn. Spend Fear as usual to spotlight them."),
    feature("Waves upon Waves", kind: feature-kind.reaction, questions: "Where do these adversaries come from? Who leads them from the shadows?", "When there are no adversaries in the scene, summon a wave of adversaries at Far range from the Charge. Each wave comprises two Tier 1 Minions for each PC in the scene."),
  ),
  flags: source(164),
)

#let local-festival = environment(
  id: "local-festival",
  name: "Local Festival",
  tier: 1,
  type: environment-type.social,
  description: "Commoners and nobles alike gather from the surrounding area for a weeklong celebration.",
  impulses: "Express local culture and history, forge new relationships, reinforce communityDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Festival Security (Bladed Guard, Head Guard), Local Luminaries (Commoner, Merchant, Petty Noble), Sundry Ne’er-Do-Wells (Jagged Knife Bandit, Lackey)",
  features: (
    feature("Remember, Remember", kind: feature-kind.passive, questions: "What are the locals celebrating? What is the festival famous for? How did the PCs first hear about it?")[
      #"This time of year marks an important anniversary or astronomical event, such as the founding of the town or the summer solstice. On a successful Knowledge Roll, a PC can answer one of the questions below (or two, if they critically succeed). On a failure, they answer one question, but you decide which part of their answer is inaccurate and gain a Fear."

      - #"The festival celebrates a crop or export that is critical to the economy here. What is it?"
      - #"Why didn’t the festival happen last year?"
      - #"This festival is similar to another one held in a neighboring region. What makes them diff erent?"
    ],
    feature("Political Machinations", kind: feature-kind.passive, questions: "What new crisis is on everyone’s lips? Why can’t this community solve the problem on its own? What reward can they offer the PCs in exchange for their aid?", "While everyone is gathered in one place, the locals take the opportunity to quash feuds, drum up new business, and navigate local politics. A PC can stick their nose in the goings-on by making a Presence Roll. On a success, they make a connection to a local luminary who can give them a job, share important information, or make useful introductions. On a failure, they must mark a Stress."),
    feature("“Let the Games Begin!”", kind: feature-kind.action, questions: "What skills or abilities does this competition test? What does the victor win? Why is failure not an option for the PCs or their rivals?", "One of the festival’s signature events is a sporting competition or series of games. If one or more PCs throw their hat into the ring, introduce rival competitors for them to face off against. To claim victory, the PCs must complete a Progress Countdown (5) to win events or score points before their rivals complete a Consequence Countdown (5)."),
    feature("Legendary Local", kind: feature-kind.action, questions: "Is this a singular entity or a mantle passed from person to person? What distinctive form do they possess? What is the source of their power to grant boons and banes?", "The festival culminates in the arrival of a fi gure from local folklore who performs special duties for the local community, such as giving treats to children, heckling the gentry, or blessing next year’s crops. If the PCs show this fi gure the proper deference and respect, they gain an appropriate blessing, such as a cryptic prophecy or a magical trinket, and gain 1d4 Hope to distribute among the party. If they insult the fi gure, they take 1d6+2 magic damage as the fi gure curses them, and you gain a Fear."),
  ),
  flags: source(164),
)

#let local-tavern = environment(
  id: "local-tavern",
  name: "Local Tavern",
  tier: 1,
  type: environment-type.social,
  description: "A lively tavern that serves as the social hub for its town.",
  impulses: "Provide opportunities for adventurers, nurture communityDiffi culty: 10",
  difficulty: "",
  potential-adversaries: "Guards (Bladed Guard, Head Guard), Mercenaries (Harrier, Sellsword, Spellblade, Weaponmaster), Merchant",
  features: (
    feature("What’s the Talk of the Town?", kind: feature-kind.passive, questions: "Who has what kind of information? What gossip do the locals start spreading about the PCs?")[
      #"A PC can ask the bartender, staff , or patrons about local events, rumors, and potential work with a Presence Roll. On a success, they can pick two of the below details to learn—or three if they critically succeed. On a failure, they can pick one and mark a Stress as the local carries on about something irrelevant."

      - #"A fascinating rumor with a connection to a PC’s background"
      - #"A promising job for the party involving a nearby threat or situation"
      - #"Local folklore that relates to something they’ve seen"
      - #"Town gossip that hints at a community problem"
    ],
    feature("Sing For Your Supper", kind: feature-kind.passive, questions: "What piece do you perform? What does that piece mean to you? When’s the last time you performed it for a crowd?", "A PC can perform one time for the guests by making a Presence Roll. On a success, they earn 1d4 handfuls of gold (2d4 if they critically succeed). On a failure, they mark a Stress."),
    feature("Mysterious Stranger", kind: feature-kind.action, questions: "What do they want? What’s their impression of the PCs? What mannerisms or accessories do they have?", "Reveal a stranger concealing their identity, lurking in a shaded booth."),
    feature("Someone Comes to Town", kind: feature-kind.action, questions: "Did they know the PCs were here? What do they want in this town?", "Introduce a signifi cant NPC who wants to hire the party for something or who relates to a PC’s background."),
    feature("Bar Fight!", kind: feature-kind.action, questions: "Who started the fight? What will it take to stop it?", "Spend a Fear to have a bar fi ght erupt in the tavern. When a PC tries to move through the tavern while the fi ght persists, they must succeed on an Agility or Presence Roll or take 1d6+2 physical damage from a wild swing or thrown object. A PC can try to activate this feature by succeeding on an action roll that would provoke tavern patrons."),
  ),
  flags: source(165),
)

#let outpost-town = environment(
  id: "outpost-town",
  name: "Outpost Town",
  tier: 1,
  type: environment-type.social,
  description: "A small town on the outskirts of a nation or region, close to a dungeon, tombs, or other adventuring destinations.",
  impulses: "Drive the desperate to certain doom, profi t off of ragged hopeDiffi culty: 12",
  difficulty: "",
  potential-adversaries: "Jagged Knife Bandits (Hexer, Kneebreaker, Lackey, Lieutenant, Shadow, Sniper), Masked Thief, Merchant",
  features: (
    feature("Rumors Abound", kind: feature-kind.passive, questions: "What news do the PCs have that they could pass along to curious travelers? What do the locals think about these events?")[
      #"Gossip is the fastest-traveling currency in the realm. A PC can inquire about major events by making a Presence Roll. What they learn depends on the outcome of their roll, based on the following criteria:"

      - #"Critical Success: Learn about two major events. The PC can ask one follow-up question about one of the rumors and get a truthful (if not always complete) answer."
      - #"Success with Hope: Learn about two events, at least one of which is relevant to the character’s background."
      - #"Success with Fear: Learn an alarming rumor related to the character’s background."
      - #"Any Failure: The locals respond poorly to their inquiries. The PC must mark a Stress to learn one relevant rumor."
    ],
    feature("Society of the Broken Compass", kind: feature-kind.passive, questions: "What boasts do the adventurers here make, and which do you think are true?", "An adventuring society maintains a chapterhouse here, where heroes trade boasts and rumors, drink to their imagined successes, and scheme to undermine their rivals."),
    feature("Rival Party", kind: feature-kind.passive, questions: "Which PC has a connection to one of the rival party members? Do they approach the PC first or do they wait for the PC to move?", "Another adventuring party is here, seeking the same treasure or leads as the PCs."),
    feature("It’d Be a Shame If Something Happened to Your Store", kind: feature-kind.action, questions: "What trouble does it cause if the PCs intervene?", "The PCs witness as agents of a local crime boss shake down a general goods store."),
    feature("Wrong Place, Wrong Time", kind: feature-kind.reaction, questions: "What details show the party that these people are desperate former adventurers?", "At night, or when the party is alone in a back alley, you can spend a Fear to introduce a group of thieves who try to rob them. The thieves appear at Close range of a chosen PC and include a Jagged Knife Kneebreaker, as many Lackeys as there are PCs, and a Lieutenant. For a larger party, add a Hexer or Sniper."),
  ),
  flags: source(165),
)

#let raiding-party = environment(
  id: "raiding-party",
  name: "Raiding Party",
  tier: 1,
  type: environment-type.event,
  description: "A pirate ship disgorges its crew into a port town or shoreline village to loot and plunder.",
  impulses: "Light it on fi re, overwhelm with speed and numbers, take everything that isn’t nailed downDiffi culty: 11",
  difficulty: "",
  potential-adversaries: "Ship’s Crew (Pirate Captain, Pirate Raiders, Pirate Tough)",
  features: (
    feature("Rally the Locals", kind: feature-kind.passive, questions: "How do the pirates threaten or endanger the town besides attacking its inhabitants? What defenses can the PCs take advantage of?", "Progress Countdown (5). When the pirates fi rst appear, activate the countdown. It ticks down when a PC succeeds on an action roll to stem the chaos and destruction of the pirate raid. When it triggers, the locals become inspired by the party’s actions and join the fi ght against the pirates. Each PC gains a d6 Morale Die, which they can spend to add to an action, reaction, or damage roll."),
    feature("Parley", kind: feature-kind.passive, questions: "Why do these pirates respect this captain enough to follow them? What do they care about more than ill-gotten booty?", "On a successful Knowledge Roll, a PC knows enough pirate law to demand a parley with the Pirate Captain. Once the parley is issued, the captain pauses the combat to allow a PC to sue for peace or negotiate the terms of surrender with a Presence Roll."),
    feature("“Fire the Cannons!”", kind: feature-kind.action, questions: "What collateral damage do these cannonballs cause? Whose lives do they wantonly endanger?", "Spend up to 3 Fear to have the pirate ship fi re its cannons into the combat. For each Fear spent, choose a point anywhere on the battlefi eld. Each PC within Close range of one or more of those points must make an Agility Reaction Roll. Targets who fail take 1d8+3 physical damage. Targets who succeed must mark a Stress or take half damage."),
    feature("Take Captives", kind: feature-kind.reaction, questions: "Who do the pirates deem the best captives, and why? What do they want in exchange for the captives’ return?", "When a number of pirates equal to the number of PCs in the scene are defeated, roll a d6. On a result of 5 or 6, the pirates change tactics, capturing locals and retreating to the ship so they can ransom the captives later. Activate a Consequence Countdown (4). It ticks down when a PC makes an action roll. When it triggers, the pirates sail away with their victims."),
  ),
  flags: source(166),
)

#let raging-river = environment(
  id: "raging-river",
  name: "Raging River",
  tier: 1,
  type: environment-type.traversal,
  description: "A swift-moving river without a bridge crossing, deep enough to sweep away most people.",
  impulses: "Bar crossing, carry away the unready, divide the landDiffi culty: 10",
  difficulty: "",
  potential-adversaries: "Beasts (Bear, Glass Snake), Jagged Knife Bandits (Hexer, Kneebreaker, Lackey, Lieutenant, Shadow, Sniper)",
  features: (
    feature("Dangerous Crossing", kind: feature-kind.passive, questions: "Have any of the PCs forded rivers like this before? Are any of them afraid of drowning?", "Crossing the river requires the party to complete a Progress Countdown (4). A PC who rolls a failure with Fear is immediately targeted by the “Undertow” action without requiring a Fear to be spent on the feature."),
    feature("Undertow", kind: feature-kind.action, questions: "What trinkets and baubles lie along the bottom of the riverbed? Do predators swim these rivers?", "Spend a Fear to catch a PC in the undertow. They must make an Agility Reaction Roll. On a failure, they take 1d6+1 physical damage and are moved a Close distance down the river, becoming Vulnerable until they get out of the river. On a success, they must mark a Stress."),
    feature("Patient Hunter", kind: feature-kind.action, questions: "What treasures does the beast have in their burrow? What travelers have already fallen victim to this predator?", "Spend a Fear to summon a Glass Snake within Close range of a chosen PC. The Snake appears in or near the river and immediately takes the spotlight to use their “Spinning Serpent” action."),
  ),
  flags: source(166),
)

/// Every environment in this file, in SRD order.
#let entries = (abandoned-grove, abandoned-mine, ambushed, ambushers, alchemists-abandoned-workshop, bustling-marketplace, corrupted-swamp, cliffside-ascent, cursed-graveyard, grand-feast, hold-the-line, local-festival, local-tavern, outpost-town, raiding-party, raging-river,)
