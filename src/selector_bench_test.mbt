///|
/// Benchmarks for selector matching. Selector match runs on every cascaded
/// rule against every styled element, so its throughput directly drives
/// browser style-resolution speed. Run with `moon bench`.

///|
/// Build a deeply nested DOM-like tree of `depth` elements. The leaf node
/// is the bottom of the chain (`.leaf`); intermediate nodes alternate
/// between `<div class="row">` and `<section class="container">`.
fn build_bench_dom_chain(depth : Int) -> Element {
  let mut current = Element::new("html").set_id("root")
  for i in 0..<depth {
    let tag = if i % 2 == 0 {
      "div"
    } else {
      "section"
    }
    let cls = if i % 2 == 0 {
      "row"
    } else {
      "container"
    }
    current = Element::new(tag).add_class(cls).set_parent(current)
  }
  Element::new("a")
    .add_class("leaf")
    .add_class("primary")
    .add_class("active")
    .set_attribute("href", "https://example.com")
    .set_parent(current)
}

///|
/// Build a stylesheet with `n` distinct class rules, plus a few overlap rules.
fn build_bench_rule_set(n : Int) -> @cascade.Stylesheet {
  let sheet = @cascade.Stylesheet::new(@cascade.Author)
  for i in 0..<n {
    let key = i.to_string()
    let sel = parse_selector(".item-" + key).unwrap()
    sheet.add_rule(".item-" + key, sel, [
      @cascade.Declaration::new("color", "red"),
    ])
  }
  // Add some realistic descendant selectors
  let row_sel = parse_selector(".container .row").unwrap()
  sheet.add_rule(".container .row", row_sel, [
    @cascade.Declaration::new("padding", "4px"),
  ])
  let leaf_sel = parse_selector(".container > .row .leaf").unwrap()
  sheet.add_rule(".container > .row .leaf", leaf_sel, [
    @cascade.Declaration::new("color", "blue"),
  ])
  let hover_sel = parse_selector("a.leaf").unwrap()
  sheet.add_rule("a.leaf", hover_sel, [
    @cascade.Declaration::new("font-weight", "bold"),
  ])
  sheet
}

// ---------------------------------------------------------------------------
// Simple-selector benches — measure the per-component fast path.
// ---------------------------------------------------------------------------

///|
test "bench matches_selector type matching" (it : @bench.T) {
  let element = Element::new("div")
  let sel = parse_selector("div").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector type non-matching" (it : @bench.T) {
  let element = Element::new("div")
  let sel = parse_selector("span").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector id matching" (it : @bench.T) {
  let element = Element::new("div").set_id("main")
  let sel = parse_selector("#main").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector single class matching" (it : @bench.T) {
  let element = Element::with_classes("div", ["card"])
  let sel = parse_selector(".card").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector single class miss among many" (it : @bench.T) {
  // Element with 10 classes; selector targets a class that doesn't exist.
  let element = Element::with_classes("div", [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
  ])
  let sel = parse_selector(".missing").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector single class hit last in many" (it : @bench.T) {
  // Worst-case linear scan: target class is last
  let element = Element::with_classes("div", [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "target",
  ])
  let sel = parse_selector(".target").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector compound selector deep" (it : @bench.T) {
  let element = Element::with_classes("button", ["btn", "primary", "lg"])
    .set_id("submit")
    .set_attribute("type", "submit")
  let sel = parse_selector("button.btn.primary.lg#submit[type=submit]").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector compound non-matching last component" (
  it : @bench.T,
) {
  let element = Element::with_classes("button", ["btn", "primary"])
    .set_id("submit")
  // Last class mismatch should reject quickly.
  let sel = parse_selector("button.btn.primary.large#submit").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

// ---------------------------------------------------------------------------
// Combinator benches — walking the DOM tree.
// ---------------------------------------------------------------------------

///|
test "bench matches_selector descendant depth 5" (it : @bench.T) {
  let element = build_bench_dom_chain(5)
  let sel = parse_selector("#root .leaf").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector descendant depth 20" (it : @bench.T) {
  let element = build_bench_dom_chain(20)
  let sel = parse_selector("#root .leaf").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector descendant non-matching depth 20" (
  it : @bench.T,
) {
  // Worst case: walk up to root and never find a match
  let element = build_bench_dom_chain(20)
  let sel = parse_selector("#nope .leaf").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector child combinator chain depth 5" (
  it : @bench.T,
) {
  // .container > .row > .container > .row > .container > a.leaf
  let element = build_bench_dom_chain(5)
  let sel = parse_selector(
    ".container > .row > .container > .row > .container > a.leaf",
  ).unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector child combinator early-reject" (
  it : @bench.T,
) {
  // First-step parent class miss
  let element = build_bench_dom_chain(5)
  let sel = parse_selector(".never > a.leaf").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector deeply mixed combinators" (it : @bench.T) {
  let element = build_bench_dom_chain(10)
  // descendant + child mix
  let sel = parse_selector("#root .container > .row a.leaf").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

// ---------------------------------------------------------------------------
// Attribute selector benches.
// ---------------------------------------------------------------------------

///|
test "bench matches_selector attribute exists" (it : @bench.T) {
  let element = Element::new("a").set_attribute("href", "https://example.com")
  let sel = parse_selector("a[href]").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector attribute exact match" (it : @bench.T) {
  let element = Element::new("input").set_attribute("type", "submit")
  let sel = parse_selector("input[type=submit]").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector attribute prefix match" (it : @bench.T) {
  let element = Element::new("a").set_attribute("href", "https://example.com/x")
  let sel = parse_selector("a[href^=\"https\"]").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector attribute substring match" (it : @bench.T) {
  let element = Element::new("a").set_attribute("href", "https://example.com/x")
  let sel = parse_selector("a[href*=example]").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector attribute many attrs" (it : @bench.T) {
  // Element with many attributes — get_attribute is linear
  let element = Element::new("div")
    .set_attribute("a", "1")
    .set_attribute("b", "2")
    .set_attribute("c", "3")
    .set_attribute("d", "4")
    .set_attribute("e", "5")
    .set_attribute("f", "6")
    .set_attribute("g", "7")
    .set_attribute("h", "8")
    .set_attribute("data-target", "yes")
  let sel = parse_selector("[data-target=yes]").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

// ---------------------------------------------------------------------------
// Pseudo-class benches.
// ---------------------------------------------------------------------------

///|
test "bench matches_selector nth-child" (it : @bench.T) {
  let element = Element::new("li").set_sibling_info(3, 10)
  let sel = parse_selector("li:nth-child(2n+1)").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector nth-child large index" (it : @bench.T) {
  let element = Element::new("li").set_sibling_info(999, 1000)
  let sel = parse_selector("li:nth-child(3n)").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector first-child" (it : @bench.T) {
  let element = Element::new("p").set_sibling_info(1, 5)
  let sel = parse_selector(":first-child").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector :not(.class)" (it : @bench.T) {
  let element = Element::with_classes("div", ["card", "primary"])
  let sel = parse_selector(".card:not(.hidden)").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

///|
test "bench matches_selector :is(...) multi" (it : @bench.T) {
  let element = Element::new("h2")
  let sel = parse_selector(":is(h1, h2, h3, h4, h5, h6)").unwrap()
  it.bench(fn() { it.keep(matches_selector(element, sel)) })
}

// ---------------------------------------------------------------------------
// Selector list (e.g. ".a, .b, .c, .d") — short-circuit benchmarks.
// ---------------------------------------------------------------------------

///|
test "bench matches_selector_list hit first" (it : @bench.T) {
  let element = Element::with_classes("div", ["match-a"])
  let list = parse_selector_list(
    ".match-a, .b, .c, .d, .e, .f, .g, .h, .i, .j",
  ).unwrap()
  it.bench(fn() { it.keep(matches_selector_list(element, list)) })
}

///|
test "bench matches_selector_list hit last" (it : @bench.T) {
  let element = Element::with_classes("div", ["match-j"])
  let list = parse_selector_list(
    ".a, .b, .c, .d, .e, .f, .g, .h, .i, .match-j",
  ).unwrap()
  it.bench(fn() { it.keep(matches_selector_list(element, list)) })
}

///|
test "bench matches_selector_list miss all" (it : @bench.T) {
  let element = Element::with_classes("div", ["none"])
  let list = parse_selector_list(
    ".a, .b, .c, .d, .e, .f, .g, .h, .i, .j",
  ).unwrap()
  it.bench(fn() { it.keep(matches_selector_list(element, list)) })
}

// ---------------------------------------------------------------------------
// Realistic stylesheet cascade benches — the most representative metric.
// ---------------------------------------------------------------------------

///|
test "bench cascade_element 50-rule stylesheet" (it : @bench.T) {
  let sheet = build_bench_rule_set(50)
  let element = Element::with_classes("div", ["item-17", "container"])
  it.bench(fn() { it.keep(cascade_element(element, [sheet], [])) })
}

///|
test "bench cascade_element 500-rule stylesheet" (it : @bench.T) {
  let sheet = build_bench_rule_set(500)
  let element = Element::with_classes("div", ["item-237", "container"])
  it.bench(fn() { it.keep(cascade_element(element, [sheet], [])) })
}

///|
test "bench cascade_element_indexed 50-rule stylesheet" (it : @bench.T) {
  let sheet = build_bench_rule_set(50)
  let indexed = IndexedStylesheet::new(sheet)
  let element = Element::with_classes("div", ["item-17", "container"])
  it.bench(fn() { it.keep(cascade_element_indexed(element, [indexed], [], None)) })
}

///|
test "bench cascade_element_indexed 500-rule stylesheet" (it : @bench.T) {
  let sheet = build_bench_rule_set(500)
  let indexed = IndexedStylesheet::new(sheet)
  let element = Element::with_classes("div", ["item-237", "container"])
  it.bench(fn() { it.keep(cascade_element_indexed(element, [indexed], [], None)) })
}

///|
test "bench cascade_element_indexed 500 rules, non-matching element" (
  it : @bench.T,
) {
  // Element doesn't match any rule — measures fast-reject path
  let sheet = build_bench_rule_set(500)
  let indexed = IndexedStylesheet::new(sheet)
  let element = Element::new("span") // no classes, no id
  it.bench(fn() { it.keep(cascade_element_indexed(element, [indexed], [], None)) })
}

// ---------------------------------------------------------------------------
// Micro-benchmarks isolating raw string operations used by the matcher.
// ---------------------------------------------------------------------------

///|
test "bench String::has_prefix raw" (it : @bench.T) {
  let s = "https://example.com/path"
  let needle = "https"
  it.bench(fn() { it.keep(s.has_prefix(needle)) })
}

///|
test "bench String::has_suffix raw" (it : @bench.T) {
  let s = "https://example.com/path.html"
  let needle = ".html"
  it.bench(fn() { it.keep(s.has_suffix(needle)) })
}

///|
test "bench String::contains raw" (it : @bench.T) {
  let s = "https://example.com/path"
  let needle = "example"
  it.bench(fn() { it.keep(s.contains(needle)) })
}

///|
test "bench String equality raw" (it : @bench.T) {
  let a = "submit"
  let b = "submit"
  it.bench(fn() { it.keep(a == b) })
}
