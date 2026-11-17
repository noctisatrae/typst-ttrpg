// Style sample for the stat block. PLACEHOLDER content written for layout
// testing; these are not SRD adversaries and the numbers mean nothing.
#import "@local/ttrpg-core:0.1.0" as core
#import core: statblock, stat-line, labeled, entry
#import "@local/heartweaver:0.1.0" as hw

#show: core.setup.with(theme: hw.book-theme)
#set page(paper: "us-letter", margin: (x: 0.6in, top: 0.6in, bottom: 0.7in))

= Tier 1 Adversaries (Placeholder)

#let block-a = statblock(
  title: "Goblin Boss",
  subtitle: "Tier 1 Leader",
  description: "A loud little tyrant in a stolen helmet.",
  header: (labeled("Motives & Tactics", "Bully, hoard, shout orders, flee when outnumbered"),),
  bands: (
    (
      stat-line(("Difficulty", "12"), ("Thresholds", "6/11"), ("HP", "6"), ("Stress", "4")),
      stat-line(("ATK", "+2"), ("Rusty Cleaver", "Melee | 1d10+2 phy")),
    ),
    (stat-line(("Experience", "Intimidation +2, Scavenging +2")),),
  ),
  sections: ((title: "Features", entries: (
    entry("Get Them!", tag: "Action")[*Mark a Stress* to spotlight *1d4* allies. Their next attack deals an extra 1d6 damage.],
    entry("Cowardly Retreat", tag: "Reaction")[When the Boss marks their last HP, they can *mark a Stress* to move to Far range instead, leaving their helmet behind.],
    entry("Shiny Things", tag: "Passive")[The Boss is _Distracted_ while a PC holds a gem in plain sight.],
  )),),
)

#let block-b = statblock(
  title: "Goblin Sneak",
  subtitle: "Tier 1 Minion",
  description: "Quick, quiet, and easily bribed.",
  header: (labeled("Motives & Tactics", "Ambush, steal, scatter"),),
  bands: ((
    stat-line(("Difficulty", "10"), ("Thresholds", "None"), ("HP", "1"), ("Stress", "1")),
    stat-line(("ATK", "+0"), ("Shiv", "Melee | 3 phy")),
  ),),
  sections: ((title: "Features", entries: (
    entry("Minion (4)", tag: "Passive")[The Sneak is defeated when they take any damage. For every 4 damage a PC deals, defeat an additional Minion within range.],
    entry("Pack Attack", tag: "Action")[*Spend a Fear* to have every Sneak within Close range make one shared attack roll of 2d8+1.],
  )),),
)

#columns(2, gutter: 14pt)[
  #block-a
  #block-b
  #colbreak()
  #block-b
]

#pagebreak()
= Tier 2 Adversaries (Placeholder)

#columns(2, gutter: 14pt)[
  #block-a
  #colbreak()
  #block-b
]
