# ttrpg-script

Game-master notes in screenplay format: scenes, dialogue, music cues,
hand-offs to open play, inline stat blocks, a session sheet and a cast
appendix. Built on [ttrpg-core](https://typst.app/universe/package/ttrpg-core)
entities; a game system describes how its kinds of entities are listed and
rendered.

```typ
#import "@preview/ttrpg-script:0.1.0": *

#show: setup  // or setup.with(system: ...) for a game system's stat blocks

#session-sheet()
#pagebreak()

#scene("INT.", "Ruined Chapel", "Night")
#music[rain, low uneasy strings]

Rain hammers the broken roof.

#say("Old Priest", paren: "from the crypt, faintly")[Is someone up there?]

#open-play[Fight or talk. If someone rings the bell, go to The Bell Tower.]
#leads-to("The Bell Tower")
```

- `scene` (time optional), `intro` / `mention` for entities, `say`,
  `stats`, `open-play`, `leads-to`, `music` (a mood, or `track:`/`by:`/`url:`
  for key moments), `transition`.
- `session-sheet()`: per scene, its page, the entities grouped by kind,
  music and where it leads.
- `appendix()`: one section per kind, full stat blocks; `intro` names link
  to it and show its page for print.
- Fonts: Courier Prime for the script, Geist Mono for stat blocks
  (`setup(font:, stats-font:)`; both are free, install them locally).

Code under MPL-2.0. Source and a full example:
https://github.com/noctisatrae/typst-ttrpg
