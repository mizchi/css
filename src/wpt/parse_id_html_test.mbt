/// Auto-generated from css/selectors/parsing/parse-id.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-id.html: valid h1#chapter1" {
  wpt_assert_valid("wpt parse-id.html: valid h1#chapter1", "h1#chapter1", ["h1#chapter1"], false)
}

///|
test "wpt parse-id.html: valid #chapter1" {
  wpt_assert_valid("wpt parse-id.html: valid #chapter1", "#chapter1", ["#chapter1"], false)
}

///|
test "wpt parse-id.html: valid *#z98y" {
  wpt_assert_valid("wpt parse-id.html: valid *#z98y", "*#z98y", ["*#z98y", "#z98y"], false)
}
