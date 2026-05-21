/// Auto-generated from css/selectors/parsing/parse-child.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-child.html: valid body > p" {
  wpt_assert_valid(
    "wpt parse-child.html: valid body > p",
    "body > p",
    ["body > p"],
    false,
  )
}

///|
test "wpt parse-child.html: valid div ol>li p" {
  wpt_assert_valid(
    "wpt parse-child.html: valid div ol>li p",
    "div ol>li p",
    ["div ol > li p"],
    false,
  )
}
