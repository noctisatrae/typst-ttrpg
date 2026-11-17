// SRD adversaries rendered with heartweaver. Content from the Daggerheart
// SRD 2.0, used under the Darrington Press Community Gaming License.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": adversaries

#show: core.setup.with(theme: hw.book-theme)
#set page(paper: "us-letter", margin: (x: 0.6in, top: 0.6in, bottom: 0.7in))

= Tier 1 Adversaries

#let t1 = adversaries.tier-1
#columns(2, gutter: 14pt)[
  #hw.statblock(t1.jagged-knife-lieutenant)
  #hw.statblock(t1.jagged-knife-bandit)
  #hw.statblock(t1.jagged-knife-lackey)
  #hw.statblock(t1.giant-mosquitoes)
  #hw.statblock(t1.octopus)
]

#v(1fr)
#hw.attribution()
