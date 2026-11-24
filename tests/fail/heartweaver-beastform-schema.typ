// expect: beastform "half": `trait`, `trait-bonus` and `evasion-bonus` go together ("Agility +1 | Evasion +2"), got only `trait`
#import "@local/heartweaver:0.1.0" as hw: feature
#hw.beastform(id: "half", name: "Half", tier: 1, trait: "Agility", features: (feature("X")[x],))
