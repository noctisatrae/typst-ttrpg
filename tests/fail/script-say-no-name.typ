// expect: say: entity "nameless" has no field `name`
#import "@local/ttrpg-script:0.1.0": *
#say((id: "nameless"))[Hi.]
