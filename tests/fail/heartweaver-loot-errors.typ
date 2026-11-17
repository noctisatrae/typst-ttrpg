// expect: consumable "odd-tonic" has 3 problems
// expect: `roll` must be the printed roll, "1" to "60" (the loot tables, p. 75), got "61"
// expect: field `collection` must be one of "Daggerheart Core Set", "Hope & Fear Expansion Set", got "Homebrew"
// expect: unknown field `descripton` (did you mean `description`?)
#import "@local/heartweaver:0.1.0" as hw
#hw.consumable(id: "odd-tonic", name: "Odd Tonic", collection: "Homebrew", roll: "61",
  descripton: "Tastes odd.")
