// Tier 4 environments, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Extracted with scripts/srd (environments.py, emit.py) and cross-checked against
// the SRD text with checkdata.py. Text is verbatim except: line breaks
// joined; the SRD's inline emphasis is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": environment, environment-type, feature-kind, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let chaos-realm = environment(
  id: "chaos-realm",
  name: "Chaos Realm",
  tier: 4,
  type: environment-type.traversal,
  description: "An otherworldly space where the laws of reality are unstable and dangerous.",
  impulses: "Annihilate certainty, consume power, defy logic",
  difficulty: 20,
  potential-adversaries: "Outer Realms Monstrosities (Abomination, Corruptor, Thrall)",
  features: (
    feature("Impossible Architecture", kind: feature-kind.passive, questions: "What does it feel like to move in a space so alien to the Mortal Realm? What landmark or point do you fixate on to maintain your balance? What bizarre landmarks do you traverse on your journey?", "Up is down, down is right, right is starward. Gravity and directionality themselves are in flux, and any attempt to move through this realm is an odyssey unto itself, requiring a Progress Countdown (8). On a failure, a PC must mark a Stress in addition to the roll’s other consequences."),
    feature("Everything You Are This Place Will Take from You", kind: feature-kind.action, questions: "How does this place try to steal from you that which makes you legendary? What does it feel like to have this power taken from you?", "Countdown (Loop 1d4). Activate the countdown. When it triggers, all PCs must succeed on a Presence Reaction Roll or their highest trait is temporarily reduced by 1d4 unless they mark a number of Stress equal to its value. Any lost trait points are regained if the PC critically succeeds or escapes the Chaos Realm."),
    feature("Unmaking", kind: feature-kind.action, questions: "What glimpse of other worlds do you catch while this place tries to unmake you? What core facet of your personality does the unmaking try to erase?", "Spend a Fear to force a PC to make a Strength Reaction Roll. On a failure, they take 4d10 direct magic damage. On a success, they must mark a Stress."),
    feature("Outer Realms Predators", kind: feature-kind.action, questions: "What half-consumed remnants of the shattered world do these monstrosities cast aside in pursuit of living flesh? What jagged reflections of former personhood do you catch between moments of unquestioning malice?", "Spend a Fear to summon an Outer Realms Abomination, an Outer Realms Corruptor, and 2d6 Outer Realms Thralls, who appear at Close range of a chosen PC in defiance of logic and causality. Immediately spotlight one of these adversaries, and you can spend an additional Fear to automatically succeed on that adversary’s standard attack."),
    feature("Disorienting Reality", kind: feature-kind.reaction, questions: "What moment do they see? If it’s a memory, how is it warped by this place? How hard will it be to hold on to the real memory?", "On a result with Fear, you can ask the PC to describe which of their fears the Chaos Realm evokes as a vision of reality unmakes and reconstitutes itself to the PC. The PC loses a Hope. If it is their last Hope, you gain a Fear."),
  ),
  flags: source(178),
)

#let convergence-the-city-of-portals = environment(
  id: "convergence-the-city-of-portals",
  name: "Convergence, the City of Portals",
  tier: 4,
  type: environment-type.social,
  description: "A sprawling metropolis at the nexus of creation, where influential figures from across the realms gather.",
  impulses: "Confront them with alien customs, dazzle them with infinite variety, tempt them with the impossible",
  difficulty: 20,
  potential-adversaries: "Power Players (Arch-Necromancer, Demon Lord Berzug, Fire Titan Warlord, High Seraph, Monarch, Oracle of Doom, Vampire Lord), Travelers and Residents (Any)",
  features: (
    feature("Impossibilities Abound", kind: feature-kind.passive, questions: "What manner of being currently holds sway in the city? What strange customs do they practice? Which PC is most confused or offended by them, and which PC adopts these customs as their own?", "Convergence is a nexus of gods, monsters, aliens, and all manner of dimension-hoppers. Because mortal life is generally beneath these beings’ concern, PCs have disadvantage on action rolls to influence them unless they have leverage against them or know what the NPC cares about."),
    feature("Into the Multiverse", kind: feature-kind.passive, questions: "Where (or when) does the party want to go? Where is that portal located, and who controls that area?", "The city of Convergence has a portal or door to every realm of existence."),
    feature("Infinite Inventory", kind: feature-kind.passive, questions: "Who has the item the party needs? What do they want in return?")[
      #"This city has the solution to any problem, if you can find it. A PC seeking a particular item with wondrous properties can make an Instinct or Presence Roll to find it in the city’s pandimensional marketplace."

      - #"Critical Success: The PC finds the perfect item, and the merchant who has it only wants something the PC considers inconsequential in exchange."
      - #"Success with Hope: The PC finds the perfect item and can exchange something of equal value for it."
      - #"Success with Fear: The PC finds the perfect item, but the merchant who has it will only exchange it for something the party can’t give them... yet."
      - #"Any Failure: The PC must mark a Stress as they go on a wild goose chase but come up empty-handed. The PC can mark an additional Stress to change this result into a success with Fear."
    ],
    feature("Don’t Make Waves", kind: feature-kind.passive, questions: "What has the party done (or what do they plan to do) that draws the attention and ire of the city officials? How can they fix the problem they caused?", "Countdown (6). Because anything is possible in Convergence, the city maintains a labyrinthine bureaucracy that issues and enforces ordinances regarding all exchanges and interactions between the realms. When the party arrives in Convergence, activate the countdown. It ticks down when a PC does something that upsets the city’s delicate political equilibrium. When it triggers, the PCs become Wanted until they clear their names with the authorities. When a Wanted PC rolls with Fear, you can summon 1d4 Temporal Enforcers who appear within Very Close range, immediately take the spotlight, and try to apprehend the party."),
    feature("An Offer You Can’t Refuse", kind: feature-kind.action, questions: "Which faction offers the party their support? Who do they want the party to act against?", "Convergence is home to a tenuous network of rival factions. Spend a Fear to have one of them present the party with an easy solution to a difficult problem in exchange for their allegiance. If the party refuses, each PC must mark a Stress, and they can’t turn to that faction for help in the future."),
  ),
  flags: source(179),
)

#let divine-usurpation = environment(
  id: "divine-usurpation",
  name: "Divine Usurpation",
  tier: 4,
  type: environment-type.event,
  description: "A massive ritual designed to breach the gates of the Hallows Above and unseat the New Gods themselves.",
  impulses: "Collect power, overawe, silence dissent",
  difficulty: 20,
  potential-adversaries: "Arch-Necromancer, Fallen Shock Troops, Mortal Hunter, Oracle of Doom, Perfected Zombie",
  features: (
    feature("Final Preparations", kind: feature-kind.passive, questions: "What does the Usurper still require: The heart of a High Seraph? The lodestone of an ancient waygate? The loyalty of two archenemies? The heartbroken tears of a pure soul?", "When the environment first takes the spotlight, designate one adversary as the Usurper seeking to overthrow the gods. Activate a Long-Term Countdown (8) as the Usurper assembles what they need to conduct the ritual. When it triggers, spotlight this environment to use the “Beginning of the End” feature. While this environment remains in play, you can hold up to 15 Fear."),
    feature("Divine Blessing", kind: feature-kind.passive, questions: "What god favors you as you fight against this usurpation? How does your renewed power reflect their influence?", "When a PC critically succeeds, they can spend 2 Hope to refresh an ability normally limited by uses (such as once per rest, once per session)."),
    feature("Defilers Abound", kind: feature-kind.action, questions: "Which High Fallen do these troops serve? Which god’s flesh do they wish to feast upon?", "Spend 2 Fear to summon 1d4+2 Fallen Shock Troops that appear within Close range of the Usurper to assist their divine siege. Immediately spotlight the Shock Troops to use a “Group Attack” action."),
    feature("Godslayer", kind: feature-kind.action, questions: "Which god meets their end? What are their last words? How does the Usurper’s new stolen power manifest?", "If the Divine Siege Countdown (see “Beginning of the End”) has triggered, you can spend 3 Fear to describe the Usurper slaying one of the gods of the Hallows Above, feasting upon their power and growing stronger. The Usurper clears 2 HP. Increase their Difficulty, damage, attack modifier, or give them a new feature from the slain god."),
    feature("Beginning of the End", kind: feature-kind.reaction, questions: "How does the Mortal Realm writhe as the natural order is violated? What mortals witness this blasphemy from afar?", "When the “Final Preparations” long-term countdown triggers, the Usurper begins hammering on the gates of the Hallows themselves. Activate a Divine Siege Countdown (10). Spotlight the Usurper to describe the Usurper’s assault and tick down this countdown by 1. If the Usurper takes Major or greater damage, tick up the countdown by 1. When it triggers, the Usurper shatters the barrier between the Mortal Realm and the Hallows Above to slay the gods and take their place. You gain a Fear for each unmarked HP the Usurper has. You can immediately use the “Godslayer” feature without spending Fear to make an additional GM move."),
    feature("Ritual Nexus", kind: feature-kind.reaction, questions: "What visions of failures past torment you as your efforts fall short? How are these memories twisted by the Usurper?", "On any failure with Fear against the Usurper, the PC must mark 1d4 Stress from the backlash of magical power."),
  ),
  flags: source(179),
)

#let moon-kingdom = environment(
  id: "moon-kingdom",
  name: "Moon Kingdom",
  tier: 4,
  type: environment-type.exploration,
  description: "The mysterious, luminous, and isolated ruins of a long-lost lunar kingdom that echoes with forgotten magic and ancient technology.",
  impulses: "Blur the line between dream and reality, let consciousness ebb and flow like the tide, whisper echoes of ancient opulence",
  difficulty: 20,
  potential-adversaries: "Local Fauna (Cryptimoths, Yufos), Moon Queen’s Spirit (Arch-Necromancer), Reawakened Relics (Constructs, Vault Guardians)",
  features: (
    feature("Dreamlike Atmosphere", kind: feature-kind.passive, questions: "What ethereal scents or sensations do the PCs experience? How does the atmosphere affect the interactions between them?", "Everything in the Moon Kingdom feels dreamlike and floaty. A leap carries you far, and the sound is muted. The air is full of an iridescent crystalline dust that shifts in response to thoughts or emotions and might record memories of the past or visions of the future. Once per scene, a PC can make an Instinct Roll to read the psychic impressions left by past events."),
    feature("Silent Ruins", kind: feature-kind.passive, questions: "What earth flora do these moon plants look like? What do they taste like, and how do they affect the eater physically?", "The towering silver and blue architecture of the capital is undamaged but overgrown with bioluminescent flora that pulses in time with the lunar tides. A PC who succceeds on a Finesse Roll can harvest a moon plant without killing it. A PC who eats one or more living moon plants gains a +1 bonus to Spellcast Rolls until their next long rest."),
    feature("Lunar Astrologium", kind: feature-kind.passive, questions: "What does this machinery look like, and how does it work? What do the PCs learn about the Moon Kingdom’s history?")[
      #"Atop the highest tower in the capital city sits a crystal dream machine that can replay history. A PC who succeeds on a Knowledge Roll can repair the machine. Once the machine is repaired, a PC who succeeds on a Presence Roll can operate it to learn the history of the Moon Kingdom’s rise and fall."

      - #"Critical Success: The PC receives clear information about key events and figures in the Moon Kingdom’s history and gains 1d4 Hope, which they can distribute among PCs they share their visions with."
      - #"Success with Hope: The PC receives clear information about key events and figures in the Moon Kingdom’s history."
      - #"Any roll with Fear: The PC receives brief flashes and sensations related to the kingdom’s cataclysmic end. If the roll was a failure, the PC takes 4d10+5 magic damage as the visions assault their psyche."
    ],
    feature("The Moon Queen’s Tomb", kind: feature-kind.reaction, questions: "Who buried her here, and why? Can she be resurrected, or is destroying her spirit the only path forward?", "The Moon Kingdom’s final ruler has been preserved in a selenite coffin deep within the citadel. On a roll with Fear to investigate her chamber, her baleful shade awakens and attacks the party. Summon the Moon Queen’s Spirit (Arch-Necromancer) next to her coffin and immediately spotlight her."),
  ),
  flags: source(180),
)

#let imperial-court = environment(
  id: "imperial-court",
  name: "Imperial Court",
  tier: 4,
  type: environment-type.social,
  description: "The majestic domain of a powerful empire, lavishly appointed with stolen treasures.",
  impulses: "Justify and perpetuate imperial rule, seduce rivals with promises of power and comfort",
  difficulty: 20,
  potential-adversaries: "Bladed Guard, Courtesan, Knight of the Realm, Monarch, Spy",
  features: (
    feature("All Roads Lead Here", kind: feature-kind.passive, questions: "How does the way language is used make even discussing alternative ways of living difficult? What obvious benefits for loyalty create friction when you try to discuss alternatives?", "While in the Imperial Court, a PC has disadvantage on Presence Rolls made to take actions that don’t fit the imperial way of life or support the empire’s dominance."),
    feature("Rival Vassals", kind: feature-kind.passive, questions: "How do they benefit from vassalage, and what has it cost them? What exploitation drives them to consider opposing the unstoppable?", "The PCs can find imperial subjects, vassals, and supplicants in the court, each vying for favor, seeking proximity to power, exchanging favors for loyalty, and elevating their status above others’. Some might be desperate to undermine their rivals, while others might even be open to discussions that verge on sedition."),
    feature("The Gravity of Empire", kind: feature-kind.action, questions: "What do the PCs want so desperately they might consider throwing in with this ruthless power? How did imperial agents learn the PC’s greatest desires?", "Spend a Fear to present a PC with a golden opportunity or offer to satisfy a major goal in exchange for obeying or supporting the empire. The target must make a Presence Reaction Roll. On a failure, they must mark all their Stress or accept the offer. If they have already marked all their Stress, they must accept the offer or exile themselves from the empire. On a success, they must mark 1d4 Stress as they’re taxed by temptation."),
    feature("Imperial Decree", kind: feature-kind.action, questions: "What display of power or transfer of wealth was needed to expedite this plan? Whose lives were disrupted or upended to make this happen?", "Spend a Fear to tick down a long-term countdown related to the empire’s agenda by 1d4. If this triggers the countdown, a proclamation related to the agenda is announced at court as the plan is executed."),
    feature("Eyes Everywhere", kind: feature-kind.reaction, questions: "How has the empire compromised this witness? Why is their first impulse to protect the empire, even if doesn’t treat them well?", "On a result with Fear, you can spend a Fear to have someone loyal to the empire overhear seditious talk within the court. A PC must succeed on an Instinct Reaction Roll to notice that the group has been overheard so they can try to intercept the witness before the PCs are exposed."),
  ),
  flags: source(180),
)

#let necromancers-ossuary = environment(
  id: "necromancers-ossuary",
  name: "Necromancer’s Ossuary",
  tier: 4,
  type: environment-type.exploration,
  description: "A dusty crypt with a library, twisting corridors, and abundant sarcophagi, spattered with the blood of ill-fated invaders.",
  impulses: "Confound intruders, delve into secrets best left buried, manifest unlife, unleash a tide of undead",
  difficulty: 19,
  potential-adversaries: "Arch-Necromancer’s Host (Perfected Zombie, Zombie Legion)",
  features: (
    feature("No Place for the Living", kind: feature-kind.passive, questions: "What does it feel like to try to heal in a place so antithetical to life?", "A feature or action that clears HP requires spending a Hope to use. If it already costs Hope, a PC must spend an additional Hope."),
    feature("Centuries of Knowledge", kind: feature-kind.passive, questions: "What are the names of the tomes? What project is the necromancer working on and what does it communicate about their plans?", "A PC can investigate the library and laboratory and make a Knowledge Roll to learn information related to arcana, local history, and the Necromancer’s plans."),
    feature("Skeletal Burst", kind: feature-kind.action, questions: "What ancient skeletal architecture is destroyed? What bones stick in your armor?", "All targets within Close range of a point you choose in this environment must succeed on an Agility Reaction Roll or take 4d8+8 physical damage from skeletal shrapnel as part of the ossuary detonates around them."),
    feature("Aura of Death", kind: feature-kind.action, questions: "How does their renewed vigor manifest? Do they look more lifelike or, paradoxically, are they more decayed but vigorous?", "Once per scene, roll a d4. Each undead within Far range of the Necromancer can clear HP and Stress equal to the result rolled. The undead can choose how that number is divided between HP and Stress."),
    feature("They Just Keep Coming!", kind: feature-kind.action, questions: "Who were these people before they became the necromancer’s pawns? What vestiges of those lives remain for the heroes to see?", "Spend a Fear to summon 1d6 Rotted Zombies, two Perfected Zombies, or a Zombie Legion, who appear at Close range of a chosen PC."),
  ),
  flags: source(181),
)

#let realm-of-the-dead = environment(
  id: "realm-of-the-dead",
  name: "Realm of the Dead",
  tier: 4,
  type: environment-type.traversal,
  description: "A seemingly infinite expanse of still water without color or laughter.",
  impulses: "Drown in despair, leech life, tempt into endless slumber",
  difficulty: 20,
  potential-adversaries: "Any (see “Death-Touched Denizens”)",
  features: (
    feature("Sea of Gloom", kind: feature-kind.passive, questions: "What dangers lie below the surface? How does one find the edge of a world without end, and what lies beyond it?", "This realm is a boundless silver ocean blanketed in a gray gloom with no visible stars or horizon. The subtle current pulls inexorably at the PCs’ legs, but it’s too gentle to disturb the flat, mirrored surface of the water. Action rolls to navigate this realm have disadvantage."),
    feature("The Burden of Wakefulness", kind: feature-kind.passive, questions: "What thoughts keep the PCs awake here? How can they support one another without succumbing to hopelessness themselves?", "It’s impossible to sleep here. When the party rests, each PC can choose only one downtime move."),
    feature("Death-Touched Denizens", kind: feature-kind.passive, questions: "Why do these creatures refuse to move on? Is there any pattern to the forms the gloom fades them into?", "All mortal creatures eventually pass through this place on their journey to the other side, but those who linger or wander become warped and mutated by the gloom. Any adversaries the party encounters here are Faded. Describe how their time here has warped them into something worse than dead. When a PC takes damage from a Faded adversary’s attack, they must also mark a Stress. If a PC is defeated here, they become a Faded adversary controlled by the GM instead of making a death move."),
    feature("The Chill of Death", kind: feature-kind.action, questions: "What does it feel like to have the will to live forcibly drained from you? How do you focus through the despair?", "Spend a Fear to force a PC to make a Presence Reaction Roll as the Sea of Gloom leeches the warmth from their blood and bones. On a failure, they take 4d10 direct magic damage. On a success, they must mark a Stress."),
    feature("Abandon All Hope", kind: feature-kind.reaction, questions: "What regrets gnaw at the edge of your consciousness while you’re here? What memories still tether you to the Mortal Realm?", "When a PC spends Hope in the Realm of the Dead, they must roll a d6. On an odd result, they must spend an additional Hope or lose the benefit of the Hope they already spent."),
  ),
  flags: source(181),
)

#let time-court = environment(
  id: "time-court",
  name: "Time Court",
  tier: 4,
  type: environment-type.event,
  description: "One or more PCs are forcibly plucked from the timeline and put on trial for crimes against continuity.",
  impulses: "Find the truth, mete out justice, nullify their powers",
  difficulty: 20,
  potential-adversaries: "Judge (Monarch), Jury (Hallowed Choir), Executioners (Temporal Enforcers)",
  features: (
    feature("Out of Time", kind: feature-kind.passive, questions: "What besides the courtroom resides in this pocket dimension? What powers maintain the universal barrier protecting this place?", "The trial takes place in a pocket dimension that exists beyond the influence of the other realms. While here, PCs can’t use their features and abilities. Each player must put their Domain cards in their vault."),
    feature("Trial by Jury", kind: feature-kind.passive, questions: "Which PCs are put on trial? What are they accused of? What potential penalties would a guilty verdict bring?", "At the end of the proceedings, a jury votes whether to acquit or convict the party. When the court is called to order, have the prosecution present its case against the PCs and start a Countdown (9). It ticks down when a PC makes an action roll. When it triggers, the PCs and GM roll their Judgment Dice. If the party’s total result meets or exceeds the GM’s, the jury acquits them."),
    feature("Counsel for the Defense", kind: feature-kind.passive, questions: "What is the weakest part of the prosecution’s case? What is the strongest part of the party’s defense?", "A PC can make an action roll to argue for their innocence (such as a Knowledge Roll to interpret the letter of the law, a Presence Roll to play on the jury’s emotions, or an Instinct Roll to point out holes in the prosecution’s case). On a success, the party gains a d6 Judgment Die. On a critical success, they gain two. On a failure, the prosecution rebuts the PC’s argument, and you gain a d6 Judgment Die."),
    feature("Counsel for the Prosecution", kind: feature-kind.action, questions: "Who leads the prosecution, and what is their relationship to the Time Council? What magic or technology does this court rely on to present and record evidence?", "The prosecution introduces a damning piece of evidence (such as an eyewitness testimony, test results, or a physical exhibit taken from the scene of the crime), and you gain a d6 Judgment Die. A PC can mark a Stress to attempt a rebuttal of the evidence with a Knowledge, Instinct, or Presence Reaction Roll. On a success, the party gains the Judgment Die instead of you. On a failure, you gain an additional d6 Judgment Die."),
    feature("“Order in the Court!”", kind: feature-kind.reaction, questions: "Is this court’s authority worthy of respect? What besides the might of the Time Council and its enforcers justifies their control over the timeline?", "When the PCs attempt to escape or end the trial through force, summon a number of Temporal Enforcers equal to the number of PCs in the scene within Close range and immediately spotlight one."),
  ),
  flags: source(182),
)

/// Every environment in this file, in SRD order.
#let entries = (chaos-realm, convergence-the-city-of-portals, divine-usurpation, moon-kingdom, imperial-court, necromancers-ossuary, realm-of-the-dead, time-court,)
