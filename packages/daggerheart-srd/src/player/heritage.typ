// Ancestries and communities, transcribed from the Daggerheart SRD 2.0
// (DH_SRD_2_2026_08_25.pdf). Public Game Content © Critical Role, LLC,
// used under the Darrington Press Community Gaming License; see NOTICE.md.
// Text is verbatim except joined line breaks.

#import "@local/heartweaver:0.1.0": ancestry, community, feature

#let source(page) = (source: (document: "Daggerheart SRD", version: "2.0", page: page))

#let fungril = ancestry(
  id: "fungril",
  name: "Fungril",
  features: (
    feature("Fungril Network")[Make an Instinct Roll (12) to use your mycelial array to speak with others of your ancestry. On a success, you can communicate across any distance.],
    feature("Death Connection")[While touching a corpse that died recently, you can mark a Stress to extract one memory from the corpse related to a specific emotion or sensation of your choice.],
  ),
  flags: source(35),
)

#let wildborne = community(
  id: "wildborne",
  name: "Wildborne",
  features: (
    feature("Lightfoot")[Your movement is naturally silent. You have advantage on rolls to move without being heard.],
  ),
  flags: source(42),
)
