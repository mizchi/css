///|
/// Microbenchmarks isolating the tokenizer cost per token kind. Each input is
/// built to roughly the same length so the numbers are comparable. Run with:
/// `moon bench --target native`.

///|
fn repeat_unit(unit : String, times : Int) -> String {
  let buf = StringBuilder::new()
  for _i in 0..<times {
    buf.write_string(unit)
  }
  buf.to_string()
}

///|
test "bench tokenize whitespace" (it : @bench.T) {
  let css = repeat_unit(" ", 2000)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize idents" (it : @bench.T) {
  // ~250 idents
  let css = repeat_unit("display ", 250)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize numbers" (it : @bench.T) {
  let css = repeat_unit("123 ", 250)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize dimensions" (it : @bench.T) {
  let css = repeat_unit("12px ", 250)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize hash colors" (it : @bench.T) {
  let css = repeat_unit("#aabbcc ", 250)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize punctuation" (it : @bench.T) {
  let css = repeat_unit("{};:,()", 250)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize comments" (it : @bench.T) {
  let css = repeat_unit("/* x */", 250)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize strings" (it : @bench.T) {
  let css = repeat_unit("\"abcd\" ", 250)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize functions" (it : @bench.T) {
  let css = repeat_unit("rgba(0,0,0,0.5) ", 150)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}

///|
test "bench tokenize declaration-like" (it : @bench.T) {
  let css = repeat_unit("color: #3498db; padding: 8px 16px; ", 60)
  it.bench(fn() { it.keep(@token.tokenize(css)) })
}
