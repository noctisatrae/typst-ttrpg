// The layout primitives compile, alone and inside setup, with a custom theme.
#import "@local/ttrpg-core:0.1.0" as core
#import core: statblock, stat-line, labeled, entry

#let sample = statblock(
  title: "Test Block", subtitle: "Subtitle", description: "Flavor.",
  header: (labeled("Label", "value"),),
  bands: ((stat-line(("A", "12"), ("B", "6/11")),), (stat-line(("C", "+2")),)),
  sections: ((title: "Features", entries: (entry("Name", tag: "Tag")[Roll 2d10+6.],)),),
)

#sample
#show: core.setup.with(theme: (colors: (accent: blue)))
#sample
#context assert.eq(core.current-theme().colors.accent, blue)
#context assert.eq(core.current-theme().fonts.mono.first(), "Geist Mono", message: "unchanged keys survive a partial theme")
