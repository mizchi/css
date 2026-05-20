/// Auto-generated from css/selectors/parsing/parse-focus-visible.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-focus-visible.html: valid :focus-visible" {
  wpt_assert_valid("wpt parse-focus-visible.html: valid :focus-visible", ":focus-visible", [":focus-visible"], false)
}

///|
test "wpt parse-focus-visible.html: valid a:focus-visible" {
  wpt_assert_valid("wpt parse-focus-visible.html: valid a:focus-visible", "a:focus-visible", ["a:focus-visible"], false)
}

///|
test "wpt parse-focus-visible.html: valid :focus:not(:focus-visible)" {
  wpt_assert_valid("wpt parse-focus-visible.html: valid :focus:not(:focus-visible)", ":focus:not(:focus-visible)", [":focus:not(:focus-visible)"], false)
}
