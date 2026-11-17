// Scaffold check: imports all four packages through @local.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as dh
#import "@local/daggerheart-srd:0.1.0" as srd
#import "@local/ttrpg-script:0.1.0" as script

= TTRPG Typst Toolkit

#for info in (core, dh, srd, script).map(m => m.package-info) [
  - #info.name #info.version
]

Content transcribed from the #srd.srd.name v#srd.srd.version.
