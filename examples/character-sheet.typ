// Paneolus's sheet in the black-and-white screenplay style. Card text from
// the Daggerheart SRD 2.0, used under the Darrington Press Community
// Gaming License.
#import "@local/heartweaver:0.1.0" as hw
#import "@local/ttrpg-script:0.1.0": setup
#import "characters/paneolus/paneolus.typ": paneolus

#show: setup.with(system: hw.system)

#hw.sheet(paneolus)

#v(1fr)
#text(size: 8pt, hw.attribution())
