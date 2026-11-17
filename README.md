# TTRPG Typst Toolkit

Typst packages for tabletop RPG content: stat blocks, SRD data and
screenplay-style campaign notes, written once in Typst and rendered to PDF.

| Package | What it is |
|---|---|
| `ttrpg-core` | System-agnostic building blocks: entities, `extend`, tables, layout. |
| `heartweaver` | Daggerheart Compatible rules, stat blocks and sheets. |
| `daggerheart-srd` | The Daggerheart SRD 2.0 as Typst data, unmodified. |
| `ttrpg-script` | Campaign notes in screenplay format, with stat blocks, music cues and a session sheet. |

## Why "heartweaver" and not "daggerheart"?
"Daggerheart" is a trademark of Darrington Press. Their Community Gaming
License lets fan works say they are *Daggerheart Compatible*, but not use the
name as the title of the work. `heartweaver` is our own creation built for
Daggerheart, so it gets its own name.

`daggerheart-srd` is the exception: it holds only the official SRD content,
transcribed without changes, and is named so people can find it.

This project is unofficial and is not affiliated with, endorsed or sponsored
by Darrington Press or Critical Role.

## Licensing
- Code: [Mozilla Public License 2.0](LICENSE). The packages stay open source.
  What you make with them (your adventures, homebrew, books) is yours and can
  use any license.
- SRD content: © Critical Role, LLC, under the Darrington Press Community
  Gaming License. See [NOTICE.md](NOTICE.md) for the required attribution.

## Development
```sh
./scripts/link-local.sh   # expose packages as @local/<name>:<version>
./scripts/test.sh         # compile every tests/*.typ
```
