/// Auto-generated from css/selectors/parsing/parse-class.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-class.html: valid *.pastoral" {
  wpt_assert_valid("wpt parse-class.html: valid *.pastoral", "*.pastoral", ["*.pastoral", ".pastoral"], false)
}

///|
test "wpt parse-class.html: valid .pastoral" {
  wpt_assert_valid("wpt parse-class.html: valid .pastoral", ".pastoral", ["*.pastoral", ".pastoral"], false)
}

///|
test "wpt parse-class.html: valid h1.pastoral" {
  wpt_assert_valid("wpt parse-class.html: valid h1.pastoral", "h1.pastoral", ["h1.pastoral"], false)
}

///|
test "wpt parse-class.html: valid p.pastoral.marine" {
  wpt_assert_valid("wpt parse-class.html: valid p.pastoral.marine", "p.pastoral.marine", ["p.pastoral.marine"], false)
}
