// Classes and subclasses, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
// Text is verbatim except joined line breaks. `modifiers`/`grants` encode
// only permanent, unconditional effects of the text next to them.

#import "@local/heartweaver:0.1.0": class, subclass, feature, trait

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let wizard = class(
  id: "wizard",
  name: "Wizard",
  domains: ("Codex", "Splendor"),
  evasion: 11,
  hp: 5,
  items: "A book you’re trying to translate or a tiny, harmless elemental pet",
  hope-feature: feature("Not This Time")[Spend 3 Hope to force an adversary within Far range to reroll an attack or damage roll.],
  features: (
    feature("Prestidigitation")[You can perform harmless, subtle magical effects at will. For example, you can change an object’s color, create a smell, light a candle, cause a tiny object to float, illuminate a room, or repair a small object.],
    feature("Strange Patterns")[Choose a number between 1 and 12. When you roll that number on a Duality Die, gain a Hope or clear a Stress. You can change this number when you take a long rest.],
  ),
  flags: source(30),
)

#let school-of-knowledge = subclass(
  id: "school-of-knowledge",
  name: "School of Knowledge",
  class: "wizard",
  spellcast-trait: trait.knowledge,
  foundation: (
    feature("Prepared", grants: (domain-cards: 1))[Take an additional domain card of your level or lower from a domain you have access to.],
    feature("Adept")[When you Utilize an Experience, you can mark a Stress instead of spending a Hope. If you do, double your Experience modifier for that roll.],
  ),
  specialization: (
    feature("Accomplished", grants: (domain-cards: 1))[Take an additional domain card of your level or lower from a domain you have access to.],
    feature("Perfect Recall")[Once per rest, when you recall a domain card in your vault, you can reduce its Recall Cost by 1.],
  ),
  mastery: (
    feature("Brilliant", grants: (domain-cards: 1))[Take an additional domain card of your level or lower from a domain you have access to.],
    feature("Honed Expertise")[When you use an Experience, roll a d6. On a result of 5 or higher, you can use it without spending Hope.],
  ),
  flags: source(31),
)

#let school-of-war = subclass(
  id: "school-of-war",
  name: "School of War",
  class: "wizard",
  spellcast-trait: trait.knowledge,
  foundation: (
    feature("Battlemage", modifiers: (hp: 1))[You’ve focused your studies on becoming an unconquerable force on the battlefield. Gain an additional Hit Point slot.],
    feature("Face Your Fear")[When you succeed with Fear on an attack roll, you deal an extra 1d10 magic damage.],
  ),
  specialization: (
    feature("Conjure Shield")[You can maintain a protective barrier of magic. While you have at least 2 Hope, you add your Proficiency to your Evasion.],
    feature("Fueled by Fear")[The extra magic damage from your “Face Your Fear” feature increases to 2d10.],
  ),
  mastery: (
    feature("Thrive in Chaos")[When you succeed on an attack, you can mark a Stress after rolling damage to force the target to mark an additional Hit Point.],
    feature("Have No Fear")[The extra magic damage from your “Face Your Fear” feature increases to 3d10.],
  ),
  flags: source(31),
)
