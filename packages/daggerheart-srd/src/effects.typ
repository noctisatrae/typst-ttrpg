// Structured effects for SRD features, hand-curated. The generated data
// (player/*.typ) asks `fx(kind, id, feature)` for each feature and spreads
// the answer into it, so this file is the ONLY place effects are written.
//
// Only PERMANENT, UNCONDITIONAL effects that the SRD wording states belong
// here (heartweaver applies them to the sheet). Situational effects stay
// text for the player. Every entry names its SRD page.
//
// Keys: "<id>/<Feature>" for one entity's feature, or "<kind>:<Feature>"
// for every feature of that name in a kind (build.py warns if those
// features don't all say the same thing). Values: `modifiers:` (numbers,
// or `c => number` of the partly derived character) and `grants:`.
// scripts/srd/build.py lists unapplied SUGGESTIONS and stale entries.

// Mage Robes' "bonus to your damage thresholds equal to your Spellcast
// trait" (p. 72).
#let spellcast-bonus(c) = if c.spellcast-trait == none { 0 } else { c.traits.at(lower(c.spellcast-trait)) }

#let all-traits(n) = (agility: n, strength: n, finesse: n, instinct: n, presence: n, knowledge: n)

#let effects = (
  // Weapon features, while equipped (pp. 56-71).
  "weapon:Reliable": (modifiers: (attack: 1)),               // "+1 to attack rolls"
  "weapon:Heavy": (modifiers: (evasion: -1)),                // "−1 to Evasion"
  "weapon:Massive": (modifiers: (evasion: -1)),              // "−1 to Evasion; on a successful attack, ..."
  "weapon:Cumbersome": (modifiers: (finesse: -1)),           // "−1 to Finesse"
  "weapon:Destructive": (modifiers: (agility: -1)),          // "−1 to Agility; on a successful attack, ..." pp. 63-64
  "weapon:Incendiary": (modifiers: (agility: -1)),           // "−1 to Agility; on a successful attack, ..." p. 64
  "bravesword/Brave": (modifiers: (evasion: -1, severe: 3)), // "−1 to Evasion; +3 to Severe damage threshold" p. 61
  "tinkers-hammer/Trusty": (modifiers: (primary-attack: 1)), // "+1 to attack rolls made with your primary weapon" p. 68
  // Shields and cloaks: the amount grows with the tier (pp. 59-69).
  "enchanted-shillelagh/Protective": (modifiers: (armor-score: 1)), // "+1 to your Armor Score" p. 59
  "labrys-axe/Protective": (modifiers: (armor-score: 1)),           // p. 61
  "round-shield/Protective": (modifiers: (armor-score: 1)),         // p. 66
  "rune-shield/Protective": (modifiers: (armor-score: 1)),          // p. 66
  "improved-round-shield/Protective": (modifiers: (armor-score: 2)), // p. 67
  "improved-rune-shield/Protective": (modifiers: (armor-score: 2)),  // p. 67
  "advanced-round-shield/Protective": (modifiers: (armor-score: 3)), // p. 68
  "advanced-rune-shield/Protective": (modifiers: (armor-score: 3)),  // p. 68
  "legendary-round-shield/Protective": (modifiers: (armor-score: 4)), // p. 69
  "legendary-rune-shield/Protective": (modifiers: (armor-score: 4)),  // p. 69
  "tower-shield/Barrier": (modifiers: (armor-score: 2, evasion: -1)),           // "+2 to Armor Score; −1 to Evasion" p. 66
  "improved-tower-shield/Barrier": (modifiers: (armor-score: 3, evasion: -1)),  // p. 67
  "advanced-tower-shield/Barrier": (modifiers: (armor-score: 4, evasion: -1)),  // p. 68
  "legendary-tower-shield/Barrier": (modifiers: (armor-score: 5, evasion: -1)), // p. 69
  "fighting-cloak/Padded": (modifiers: (thresholds: 2)),           // "+2 to damage thresholds" p. 66
  "improved-fighting-cloak/Padded": (modifiers: (thresholds: 3)),  // p. 67
  "advanced-fighting-cloak/Padded": (modifiers: (thresholds: 4)),  // p. 68
  "legendary-fighting-cloak/Padded": (modifiers: (thresholds: 5)), // p. 69
  // "+1 to Armor Score; +1 to primary weapon damage within Melee range":
  // only the Armor Score part is unconditional (p. 67).
  "spiked-shield/Double Duty": (modifiers: (armor-score: 1)),
  "segmented-staff/Double Duty": (modifiers: (armor-score: 1)),

  // Armor features, while equipped (pp. 72-74).
  "armor:Flexible": (modifiers: (evasion: 1)),               // "+1 to Evasion"
  "armor:Heavy": (modifiers: (evasion: -1)),                 // "−1 to Evasion"
  "armor:Very Heavy": (modifiers: (evasion: -2, agility: -1)), // "−2 to Evasion; −1 to Agility"
  "armor:Cumbersome": (modifiers: (finesse: -1)),            // "−1 to Finesse"
  "armor:Bulky": (modifiers: (evasion: -1)),                 // "−1 to Evasion; when you take Severe damage, ..."
  "armor:Difficult": (modifiers: all-traits(-1) + (evasion: -1)), // "−1 to all character traits and Evasion"
  "armor:Enchanted": (modifiers: (thresholds: spellcast-bonus)),  // Mage Robes, p. 72
  "bellamoi-fine-armor/Gilded": (modifiers: (presence: 1)),      // "+1 to Presence" p. 73
  "skywardens-lamellar/Vigilant": (modifiers: (evasion: 2)),      // "+2 to Evasion" p. 73

  "spidersilk-tunic/Wall-Crawling": (modifiers: (evasion: 1)),   // "+1 Evasion; you can walk on walls ..." p. 72
  "granminsters-finery/Magnificent": (modifiers: (armor-score: c => c.traits.presence)), // "bonus to your Armor Score equal to your Presence" p. 73
  // "The maximum number of domain cards in your loadout is reduced by one,
  // but you gain a bonus to your damage thresholds equal to your tier."
  // (p. 74); the loadout part is not modelled yet.
  "rune-forged-exosuit/Attuned": (modifiers: (thresholds: c => c.tier)),

  // Heritage (pp. 32-42): "at character creation" slots are permanent.
  "giant/Endurance": (modifiers: (hp: 1)),          // "Gain an additional Hit Point slot at character creation." p. 36
  "human/High Stamina": (modifiers: (stress: 1)),   // "Gain an additional Stress slot at character creation." p. 36
  "simiah/Nimble": (modifiers: (evasion: 1)),       // "Gain a permanent +1 bonus to your Evasion at character creation." p. 38
  "earthkin/Stoneskin": (modifiers: (armor-score: 1, thresholds: 1)), // "permanent +1 bonus to your Armor Score and damage thresholds" p. 33
  "galapa/Shell": (modifiers: (thresholds: c => c.proficiency)),       // "bonus to your damage thresholds equal to your Proficiency" p. 35

  // Domain cards in the loadout (pp. 206-224). Text-only cards use their
  // own name as the feature name. "Round up unless otherwise specified"
  // (p. 53).
  "untouchable/Untouchable": (modifiers: (evasion: c => calc.ceil(c.traits.agility / 2))), // "bonus to your Evasion equal to half your Agility" p. 209
  "armorer/Armorer": (modifiers: (armor-score: c => if c.armored { 1 } else { 0 })),          // "While you’re wearing armor, gain a +1 bonus to your Armor Score." p. 223
  "fortified-armor/Fortified Armor": (modifiers: (thresholds: c => if c.armored { 2 } else { 0 })), // "While you are wearing armor, gain a +2 bonus to your damage thresholds." p. 208

  // Subclasses (pp. 9-31).
  "school-of-knowledge/Prepared": (grants: (domain-cards: 1)),     // p. 31
  "school-of-knowledge/Accomplished": (grants: (domain-cards: 1)), // p. 31
  "school-of-knowledge/Brilliant": (grants: (domain-cards: 1)),    // p. 31
  "school-of-war/Battlemage": (modifiers: (hp: 1)),                // p. 31 "Gain an additional Hit Point slot."
  "vengeance/At Ease": (modifiers: (stress: 1)),                   // p. 19 "Gain an additional Stress slot."
  "stalwart/Unwavering": (modifiers: (thresholds: 1)),             // p. 19 "Gain a permanent +1 bonus to your damage thresholds."
  "stalwart/Unrelenting": (modifiers: (thresholds: 2)),            // p. 19 "... +2 ..."
  "stalwart/Undaunted": (modifiers: (thresholds: 3)),              // p. 19 "... +3 ..."
  "juggernaut/Rugged": (modifiers: (severe: 3)),                   // p. 12 "Gain a permanent +3 bonus to your Severe damage threshold."
  "nightwalker/Fleeting Shadow": (modifiers: (evasion: 1)),        // p. 23 "Gain a permanent +1 bonus to your Evasion. ..."
  "winged-sentinel/Ascendant": (modifiers: (severe: 4)),           // p. 24 "Gain a permanent +4 bonus to your Severe damage threshold."
)

/// The effects of `kind` entity `id`'s feature `name`, as named arguments
/// for `feature`, or none.
#let fx(kind, id, name) = effects.at(id + "/" + name, default: effects.at(kind + ":" + name, default: (:)))
