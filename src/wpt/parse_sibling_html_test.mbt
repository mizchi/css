/// Auto-generated from css/selectors/parsing/parse-sibling.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-sibling.html: valid math + p" {
  wpt_assert_valid("wpt parse-sibling.html: valid math + p", "math + p", ["math + p"], false)
}

///|
test "wpt parse-sibling.html: valid h1.opener + h2" {
  wpt_assert_valid("wpt parse-sibling.html: valid h1.opener + h2", "h1.opener + h2", ["h1.opener + h2"], false)
}

///|
test "wpt parse-sibling.html: valid h1 ~ pre" {
  wpt_assert_valid("wpt parse-sibling.html: valid h1 ~ pre", "h1 ~ pre", ["h1 ~ pre"], false)
}
