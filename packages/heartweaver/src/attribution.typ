// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at https://mozilla.org/MPL/2.0/.

// Attribution required by the Darrington Press Community Gaming License 2.0
// (§4.1 a-e) for any document that shares SRD content. The quoted text is
// the license's own combined form for Daggerheart, copied verbatim
// (see NOTICE.md).

#let attribution-text = "This product includes materials from the Daggerheart System Reference Document 2.0, © Critical Role, LLC. under the terms of the Darrington Press Community Gaming (DPCGL) License. More information can be found at https://www.daggerheart.com. There are no previous modifications by others."

/// The attribution block. `modifications` is your own §4.1(e) statement,
/// e.g. "Adversaries marked * are modified from the SRD."
#let attribution(modifications: none) = block(width: 100%, text(size: 0.85em, {
  [*Copyright/Attribution.* ]
  attribution-text
  [ SRD: #link("https://www.daggerheart.com/srd/"). License: #link("https://darringtonpress.com/license/").]
  if modifications != none [ #modifications]
  [ This is an unofficial work, not affiliated with, endorsed or sponsored by Darrington Press or Critical Role.]
}))
