// Weapons and armor, transcribed from the Daggerheart SRD 2.0 tables
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
// Only some Tier 1 entries so far; the full tables come with the SRD
// extraction milestone. `modifiers` encode only permanent, unconditional
// effects of the feature text.

#import "@local/heartweaver:0.1.0": weapon, armor, feature, trait, weapon-category, burden, attack-range, damage-type

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let greatstaff = weapon(
  id: "greatstaff", name: "Greatstaff", tier: 1, category: weapon-category.primary,
  trait: trait.knowledge, range: attack-range.very-far, damage: "d6", damage-type: damage-type.magic,
  burden: burden.two-handed,
  features: (feature("Powerful")[On a successful attack, roll an additional damage die and discard the lowest result.],),
  flags: source(57),
)

#let mage-robes = armor(
  id: "mage-robes", name: "Mage Robes", tier: 1, thresholds: (major: 4, severe: 10), score: 2,
  features: (feature("Enchanted", modifiers: (thresholds: c => if c.spellcast-trait == none { 0 } else { c.traits.at(lower(c.spellcast-trait)) }))[Gain a bonus to your damage thresholds equal to your Spellcast trait.],),
  flags: source(72),
)

#let gambeson-armor = armor(
  id: "gambeson-armor", name: "Gambeson Armor", tier: 1, thresholds: (major: 5, severe: 11), score: 3,
  features: (feature("Flexible", modifiers: (evasion: 1))[+1 to Evasion],),
  flags: source(72),
)

#let leather-armor = armor(
  id: "leather-armor", name: "Leather Armor", tier: 1, thresholds: (major: 6, severe: 13), score: 3,
  flags: source(72),
)
