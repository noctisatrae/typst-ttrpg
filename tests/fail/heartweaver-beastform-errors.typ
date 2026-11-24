// expect: character "paneolus" has 1 problem
// expect: `beastforms`: only a character with a Beastform feature (Druid, p. 14) takes Beastform options
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": beastforms
#import "../../examples/characters/paneolus/paneolus.typ": paneolus
#hw.character(..paneolus + (beastforms: beastforms))
