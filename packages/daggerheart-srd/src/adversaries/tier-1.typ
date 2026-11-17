// Tier 1 adversaries, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
//
// Text is verbatim except: line breaks joined; the SRD's inline emphasis
// (bold/italic inside feature text) is not reproduced. ids are the
// kebab-case of the name. `flags.source.page` is the SRD page.

#import "@local/heartweaver:0.1.0": adversary, adversary-type, feature-kind, attack-range, damage-type, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let jagged-knife-bandit = adversary(
  id: "jagged-knife-bandit",
  name: "Jagged Knife Bandit",
  tier: 1,
  type: adversary-type.standard,
  description: "A cunning criminal in a cloak bearing one of the gang’s iconic knives.",
  motives: "Escape, profit, steal, throw smoke",
  difficulty: 12,
  thresholds: (major: 8, severe: 14),
  hp: 5,
  stress: 3,
  attack: (modifier: 1, name: "Daggers", range: attack-range.melee, damage: "1d8+1", damage-type: damage-type.physical),
  experiences: ((name: "Thief", bonus: 2),),
  features: (
    feature("Climber", kind: feature-kind.passive)[The Bandit climbs just as easily as they run.],
    feature("From Above", kind: feature-kind.passive)[When the Bandit succeeds on a standard attack from above a target, they deal 1d10+1 physical damage instead of their standard damage.],
  ),
  flags: source(102),
)

#let jagged-knife-lackey = adversary(
  id: "jagged-knife-lackey",
  name: "Jagged Knife Lackey",
  tier: 1,
  type: adversary-type.minion,
  description: "A thief with simple clothes and small daggers, eager to prove themselves.",
  motives: "Escape, profit, throw smoke",
  difficulty: 9,
  thresholds: (major: none, severe: none),
  hp: 1,
  stress: 1,
  attack: (modifier: -2, name: "Daggers", range: attack-range.melee, damage: "2", damage-type: damage-type.physical),
  experiences: ((name: "Thief", bonus: 2),),
  features: (
    feature("Minion (3)", kind: feature-kind.passive)[The Lackey is defeated when they take any damage. For every 3 damage a PC deals to the Lackey, defeat an additional Minion within range the attack would succeed against.],
    feature("Group Attack", kind: feature-kind.action)[Spend a Fear to choose a target and spotlight all Jagged Knife Lackeys within Close range of them. Those Minions move into Melee range of the target and make one shared attack roll. On a success, they deal 2 physical damage each. Combine this damage.],
  ),
  flags: source(102),
)

#let jagged-knife-lieutenant = adversary(
  id: "jagged-knife-lieutenant",
  name: "Jagged Knife Lieutenant",
  tier: 1,
  type: adversary-type.leader,
  description: "A seasoned bandit in quality leathers with a strong voice and cunning eyes.",
  motives: "Bully, command, profit, reinforce",
  difficulty: 13,
  thresholds: (major: 7, severe: 14),
  hp: 6,
  stress: 3,
  attack: (modifier: 2, name: "Javelin", range: attack-range.close, damage: "1d8+3", damage-type: damage-type.physical),
  experiences: ((name: "Local Knowledge", bonus: 2),),
  features: (
    feature("Tactician", kind: feature-kind.action)[When you spotlight the Lieutenant, mark a Stress to also spotlight two allies within Close range.],
    feature("More Where That Came From", kind: feature-kind.action)[Summon three Jagged Knife Lackeys, who appear at Far range.],
    feature("Coup de Grace", kind: feature-kind.action)[Spend a Fear to make an attack against a Vulnerable target within Close range. On a success, deal 2d6+12 physical damage and the target must mark a Stress.],
    feature("Momentum", kind: feature-kind.reaction)[When the Lieutenant makes a successful attack against a PC, you gain a Fear.],
  ),
  flags: source(103),
)

#let giant-mosquitoes = adversary(
  id: "giant-mosquitoes",
  name: "Giant Mosquitoes",
  tier: 1,
  type: adversary-type.horde,
  creatures-per-hp: 5,
  description: "Dozens of fist-sized mosquitoes, flying together for protection.",
  motives: "Fly away, harass, steal blood",
  difficulty: 10,
  thresholds: (major: 5, severe: 9),
  hp: 6,
  stress: 3,
  attack: (modifier: -2, name: "Proboscis", range: attack-range.melee, damage: "1d8+3", damage-type: damage-type.physical),
  experiences: ((name: "Camouflage", bonus: 2),),
  features: (
    feature("Horde (1d4+1)", kind: feature-kind.passive)[When the Mosquitoes have marked half or more of their HP, their standard attack deals 1d4+1 physical damage instead.],
    feature("Flying", kind: feature-kind.passive)[While flying, the Mosquitoes have a +2 bonus to their Difficulty.],
    feature("Bloodsucker", kind: feature-kind.reaction)[When the Mosquitoes’ attack causes a target to mark HP, you can mark a Stress to force the target to mark an additional HP.],
  ),
  flags: source(100),
)

#let octopus = adversary(
  id: "octopus",
  name: "Octopus",
  tier: 1,
  type: adversary-type.skulk,
  description: "An aquatic, soft-bodied mollusk that has eight sucker-bearing arms and a hard, beaklike jaw.",
  motives: "Crawl along the ocean floor, eat fish, squirt ink to escape",
  difficulty: 12,
  thresholds: (major: 3, severe: none),
  hp: 2,
  stress: 3,
  attack: (modifier: -1, name: "Beak", range: attack-range.melee, damage: "1d6", damage-type: damage-type.physical),
  experiences: ((name: "Dexterity", bonus: 3), (name: "Water", bonus: 3)),
  features: (
    feature("Grapple", kind: feature-kind.action)[Make an attack roll against a target within Close range. On a success, the target becomes Restrained and Vulnerable until they escape with a successful Strength Roll.],
    feature("Squirt Ink", kind: feature-kind.action)[Mark a Stress to have the Octopus squirt ink. On land, the ink covers the ground within Very Close range. Each creature who moves through that area must succeed on an Agility Reaction Roll or slip and fall, becoming Vulnerable until they exit the area. If this feature is used while the Octopus is underwater, it instead creates a cloud of darkness that fills an area within Very Close range and blocks line of sight.],
  ),
  flags: source(105),
)

/// Every adversary in this file, in SRD order.
#let entries = (giant-mosquitoes, jagged-knife-bandit, jagged-knife-lackey, jagged-knife-lieutenant, octopus)
