// Every package imports and reports the expected version.
#import "@local/ttrpg-core:0.1.0" as core
#import "@local/heartweaver:0.1.0" as dh
#import "@local/daggerheart-srd:0.1.0" as srd
#import "@local/ttrpg-script:0.1.0" as script

#for m in (core, dh, srd, script) {
  assert.eq(m.package-info.version, version(0, 1, 0))
}
#assert.eq(dh.package-info.core, core.package-info.version)
#assert.eq(srd.srd.version, "2.0")
