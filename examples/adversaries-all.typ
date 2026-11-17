// Every SRD adversary, by tier, rendered with heartweaver's book theme.
// Content from the Daggerheart SRD 2.0, used under the Darrington Press
// Community Gaming License.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": adversaries

#show: core.setup.with(theme: hw.book-theme)
#set page(paper: "us-letter", margin: (x: 0.6in, top: 0.6in, bottom: 0.7in))

#let levels = ("tier-1": "Level 1", "tier-2": "Levels 2–4", "tier-3": "Levels 5–7", "tier-4": "Levels 8–10")

#for (tier, entries) in adversaries {
  pagebreak(weak: true)
  heading(level: 1)[Tier #tier.slice(-1) Adversaries (#levels.at(tier))]
  columns(2, gutter: 14pt, entries.values().map(hw.statblock).join())
}

#v(1fr)
#text(size: 7pt, hw.attribution())
