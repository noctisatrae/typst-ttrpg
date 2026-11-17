// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Companion level-up options (SRD p. 22), one per character level-up plus
// those from "Expert Training" and "Advanced Training". Exported as the
// module `train`: `level(3, ..., companion: (train.aware(),))`.

/// +1 to one of the companion's Experiences, by name.
#let intelligent(experience) = (training: "intelligent", experience: experience)
/// An additional Hope slot for the character.
#let light-in-the-dark() = (training: "light-in-the-dark")
/// Once per rest, love and attention: gain a Hope or both clear a Stress.
#let creature-comfort() = (training: "creature-comfort")
/// Mark one of your Armor Slots instead of one of their Stress.
#let armored() = (training: "armored")
/// One step up: `"damage"` (d6 to d8 ...) or `"range"` (Melee to Very Close ...).
#let vicious(step) = {
  if step not in ("damage", "range") { panic("train.vicious: step must be \"damage\" or \"range\", got " + repr(step)) }
  (training: "vicious", step: step)
}
/// An additional Stress slot for the companion.
#let resilient() = (training: "resilient")
/// When you mark your last Hit Point, your companion may help you up.
#let bonded() = (training: "bonded")
/// +2 to the companion's Evasion.
#let aware() = (training: "aware")
