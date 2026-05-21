/// Auto-generated from css/selectors/parsing/parse-universal.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-universal.html: valid *" {
  wpt_assert_valid("wpt parse-universal.html: valid *", "*", ["*"], false)
}

///|
test "wpt parse-universal.html: valid div :first-child" {
  wpt_assert_valid(
    "wpt parse-universal.html: valid div :first-child",
    "div :first-child",
    ["div *:first-child", "div :first-child"],
    false,
  )
}

///|
test "wpt parse-universal.html: valid div *:first-child" {
  wpt_assert_valid(
    "wpt parse-universal.html: valid div *:first-child",
    "div *:first-child",
    ["div *:first-child", "div :first-child"],
    false,
  )
}
