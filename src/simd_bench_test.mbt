///|
test "bench tokenize long string" (it : @bench.T) {
  let css = "\"" + String::make(4096, 'a') + "\""
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench parse stylesheet long string" (it : @bench.T) {
  let css = ".card { content: \"" +
    String::make(4096, 'a') +
    "\"; color: red; }"
  it.bench(fn() { it.keep(@css.parse_stylesheet(css)) })
}

///|
test "bench tokenize long comment" (it : @bench.T) {
  let css = "/*" + String::make(4096, 'a') + "*/.card"
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize long identifier" (it : @bench.T) {
  let css = "--" + String::make(4096, 'a') + ": 1px;"
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize mixed whitespace" (it : @bench.T) {
  let css = repeat_unit(" \t\n\r", 1024) + ".card"
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench attribute long substring" (it : @bench.T) {
  let element = @css.Element::new("a").set_attribute(
    "href",
    String::make(1024, 'a') + "target",
  )
  let selector = @css.parse_selector("[href*=target]").unwrap()
  it.bench(fn() { it.keep(@css.matches_selector(element, selector)) })
}

///|
test "bench attribute long prefix" (it : @bench.T) {
  let prefix = String::make(128, 'a')
  let element = @css.Element::new("a").set_attribute("href", prefix + "rest")
  let selector = @css.parse_selector("[href^=\"" + prefix + "\"]").unwrap()
  it.bench(fn() { it.keep(@css.matches_selector(element, selector)) })
}

///|
test "bench attribute long suffix" (it : @bench.T) {
  let suffix = String::make(128, 'a')
  let element = @css.Element::new("a").set_attribute("href", "rest" + suffix)
  let selector = @css.parse_selector("[href$=\"" + suffix + "\"]").unwrap()
  it.bench(fn() { it.keep(@css.matches_selector(element, selector)) })
}

///|
test "bench attribute short prefix" (it : @bench.T) {
  let element = @css.Element::new("a").set_attribute(
    "href", "https://example.com",
  )
  let selector = @css.parse_selector("[href^=https]").unwrap()
  it.bench(fn() { it.keep(@css.matches_selector(element, selector)) })
}

///|
test "bench attribute short substring" (it : @bench.T) {
  let element = @css.Element::new("a").set_attribute(
    "href", "https://example.com",
  )
  let selector = @css.parse_selector("[href*=example]").unwrap()
  it.bench(fn() { it.keep(@css.matches_selector(element, selector)) })
}
