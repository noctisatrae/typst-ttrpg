// SRD environments and loot rendered with heartweaver's book theme. Content
// from the Daggerheart SRD 2.0, used under the Darrington Press Community
// Gaming License.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": environments, items, consumables

#show: core.setup.with(theme: hw.book-theme)
#set page(paper: "us-letter", margin: (x: 0.6in, top: 0.6in, bottom: 0.7in))

= Tier 1 Environments

#columns(2, gutter: 14pt, {
  for e in environments.tier-1.values() { hw.environment-block(e) }
})

#pagebreak()
= Loot

#columns(2, gutter: 14pt, {
  for id in ("premium-bedroll", "valorstone", "bloodstone", "stride-relic", "caltrops", "titans-girdle") {
    hw.loot-card(items.at(id))
  }
  for id in ("minor-health-potion", "minor-stamina-potion", "grindletooth-venom", "stardrop", "warding-candle", "emberite-shard") {
    hw.loot-card(consumables.at(id))
  }
  v(1em)
  text(size: 7pt, hw.attribution())
})
