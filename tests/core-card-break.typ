// A card taller than the page breaks instead of overflowing; a short card
// stays in one piece.
#import "@local/ttrpg-core:0.1.0" as core
#set page(height: 12cm, width: 10cm, margin: 1cm)

#core.card[#metadata("short") <start> Short. #metadata("short") <end>]
#core.card[#metadata("tall") <start> #lorem(400) #metadata("tall") <end>]

#context {
  let page-of(label, id) = query(label).filter(m => m.value == id).first().location().page()
  assert.eq(page-of(<start>, "short"), page-of(<end>, "short"))
  assert(page-of(<end>, "tall") > page-of(<start>, "tall"), message: "a too-tall card continues on the next page")
}
