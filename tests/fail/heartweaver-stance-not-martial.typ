// expect: `stances`: only a character with a stance feature (Martial Artist's "Stance Fighter", p. 12) knows martial stances
#import "@local/heartweaver:0.1.0" as hw
#import "@local/daggerheart-srd:0.1.0": stances
#import "../../examples/characters/paneolus/paneolus.typ": paneolus
#hw.character(..paneolus + (stances: (stances.favored, stances.reliable)))
