// Screenplay-style session notes. The narration is PLACEHOLDER text; the
// adversaries, environment and consumable are from the Daggerheart SRD 2.0
// (via daggerheart-srd), used under the Darrington Press Community Gaming
// License.
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": adversaries, environments, consumables
#import "@local/ttrpg-script:0.1.0": *

#let lieutenant = adversaries.tier-1.jagged-knife-lieutenant
#let lackey = adversaries.tier-1.jagged-knife-lackey
#let ambushed = environments.tier-1.ambushed
#let potion = consumables.minor-health-potion

#show: setup.with(system: hw.system)

#session-sheet()
#pagebreak()

#scene("INT.", "Ruined Chapel", "Night")

#music[rain, low uneasy strings]

Rain hammers the broken roof. A #intro(lieutenant) paces on the altar,
kicking at a pile of stolen candlesticks. In the pews crouches a
#intro(lackey), twitchy and fingering a knife. The bandits were expecting
company: #mention(ambushed).

Under the last pew lies a forgotten #mention(potion).

#music(
  track: "The End of the World",
  by: "Joe Hisaishi",
  url: "https://www.youtube.com/watch?v=gGSVRCat4w8",
)[the Lieutenant takes the spotlight]

#say(lieutenant, paren: "too loud")[Who let them in?! Nobody comes in my chapel!]

#say(lackey)[They came through the crypt, boss.]

The Lieutenant hurls a candlestick at the door.

#open-play[
  Fight or talk. The Lieutenant summons more Lackeys if the fight turns.
  If a Lackey reaches the bell rope, go to The Bell Tower.
]

#say("Old Priest", paren: "from the crypt, faintly")[Is someone up there?]

#leads-to("The Bell Tower", "Goblin Camp")

#scene("EXT.", "The Bell Tower", "Night")

#music[wind, a lone bell, rising tension]

Wind howls around the tower. The rope of the great bell is frayed. If the
bell rings, every bandit in the valley hears it.

#say(lackey, paren: "grinning, hand on the rope")[One pull and the whole gang comes running.]

#stats(lackey)

#open-play[]

#leads-to("Ruined Chapel")

#appendix()

#v(1fr)
#text(size: 8pt, hw.attribution())
