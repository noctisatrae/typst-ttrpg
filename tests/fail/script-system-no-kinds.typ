// expect: setup: `system` must be a dictionary with `kinds`
#import "@local/ttrpg-script:0.1.0": *
#show: setup.with(system: (adversary: (section: "Cast")))
Text.
