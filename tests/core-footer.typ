// The footer renders on mirrored pages, picks up the running title, and can
// be turned off.
#import "@local/ttrpg-core:0.1.0" as core
#show: core.setup

= First Chapter
Text.
#pagebreak()
= Second Chapter
Text.
#pagebreak()
#set page(footer: none)
No footer here.
