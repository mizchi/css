///|
/// Benchmarks for the public CSS pipeline (parser → cascade → computed).
/// Run with: `moon bench`.

///|
let bench_small_css : String =
  #|.card { display: flex; padding: 8px 16px; margin: 0 auto; }
  #|.card.primary { background-color: #3498db; color: white; }
  #|#main { width: 960px; min-height: 100vh; }
  #|h1, h2, h3 { font-weight: bold; line-height: 1.2; }
  #|.btn:hover { opacity: 0.8; cursor: pointer; }

///|
fn build_bench_medium_css() -> String {
  let buf = StringBuilder::new()
  for i in 0..<40 {
    buf.write_string(".item-")
    buf.write_string(i.to_string())
    buf.write_string(
      " { display: flex; padding: 4px; margin: 2px; color: #333; }\n",
    )
    buf.write_string("#section-")
    buf.write_string(i.to_string())
    buf.write_string(
      " > .row { width: 100%; background-color: #f0f0f0; border: 1px solid #ccc; }\n",
    )
  }
  let media =
    #|@media (min-width: 768px) {
    #|  .responsive { display: grid; grid-template-columns: 1fr 2fr; gap: 16px; }
    #|}
  buf.write_string(media)
  buf.to_string()
}

///|
test "bench parse_stylesheet small" (it : @bench.T) {
  let css = bench_small_css
  it.bench(fn() { it.keep(parse_stylesheet(css)) })
}

///|
test "bench parse_stylesheet medium" (it : @bench.T) {
  let css = build_bench_medium_css()
  it.bench(fn() { it.keep(parse_stylesheet(css)) })
}

///|
test "bench parse_inline_style" (it : @bench.T) {
  let css = "display: flex; padding: 8px 16px; color: #3498db; background-color: rgba(0,0,0,0.5); font-size: 14px;"
  it.bench(fn() { it.keep(parse_inline_style(css)) })
}

///|
test "bench parse_selector_list" (it : @bench.T) {
  let s = "div.card, .row > .col, #main p:hover, ul li:nth-child(2n+1)"
  it.bench(fn() { it.keep(parse_selector_list(s)) })
}

///|
test "bench matches_selector simple" (it : @bench.T) {
  let element = Element::with_classes("div", ["card", "primary"]).set_id("main")
  let sel = parse_selector("div.card.primary#main").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench cascade_element small stylesheet" (it : @bench.T) {
  let element = Element::with_classes("div", ["card", "primary"]).set_id("main")
  let sheet = parse_stylesheet(bench_small_css)
  it.bench(fn() { it.keep(cascade_element(element, [sheet], [])) })
}

///|
test "bench cascade_element medium stylesheet" (it : @bench.T) {
  let element = Element::with_classes("div", ["item-17", "row"]).set_id(
    "section-17",
  )
  let sheet = parse_stylesheet(build_bench_medium_css())
  it.bench(fn() { it.keep(cascade_element(element, [sheet], [])) })
}

///|
test "bench compute_style small" (it : @bench.T) {
  let element = Element::with_classes("div", ["card", "primary"])
  let sheet = parse_stylesheet(bench_small_css)
  let cascaded = cascade_element(element, [sheet], [])
  let ctx = ComputeContext::new()
  it.bench(fn() { it.keep(compute_style(cascaded, ctx)) })
}

///|
test "bench full pipeline small" (it : @bench.T) {
  let css = bench_small_css
  let element = Element::with_classes("div", ["card", "primary"]).set_id("main")
  let ctx = ComputeContext::new()
  it.bench(fn() {
    let sheet = parse_stylesheet(css)
    let cascaded = cascade_element(element, [sheet], [])
    it.keep(compute_style(cascaded, ctx))
  })
}

///|
test "bench compute_inline_style" (it : @bench.T) {
  let css = "display: flex; padding: 8px 16px; color: #3498db; background-color: rgba(0,0,0,0.5); font-size: 14px; flex-grow: 1;"
  let ctx = ComputeContext::new()
  it.bench(fn() { it.keep(compute_inline_style(css, ctx)) })
}

// ---------------------------------------------------------------------------
// Profiling the parse pipeline. `parse_stylesheet medium` is the slowest
// public bench, so isolate tokenizer cost from rule-parsing cost.
// ---------------------------------------------------------------------------

///|
test "bench tokenize medium" (it : @bench.T) {
  let css = build_bench_medium_css()
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize small" (it : @bench.T) {
  let css = bench_small_css
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize inline" (it : @bench.T) {
  let css = "display: flex; padding: 8px 16px; color: #3498db; background-color: rgba(0,0,0,0.5); font-size: 14px;"
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench parse_selector_text simple" (it : @bench.T) {
  it.bench(fn() { it.keep(parse_selector("div.foo")) })
}

///|
test "bench parse_selector_text compound" (it : @bench.T) {
  it.bench(fn() {
    it.keep(parse_selector("button.btn.primary.lg#submit[type=submit]"))
  })
}

///|
test "bench parse_selector_text descendant chain" (it : @bench.T) {
  it.bench(fn() { it.keep(parse_selector("nav > ul li a:hover")) })
}
