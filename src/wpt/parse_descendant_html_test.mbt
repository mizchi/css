/// Auto-generated from css/selectors/parsing/parse-descendant.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-descendant.html: valid h1 em" {
  wpt_assert_valid(
    "wpt parse-descendant.html: valid h1 em",
    "h1 em",
    ["h1 em"],
    false,
  )
}

///|
test "wpt parse-descendant.html: valid div * p" {
  wpt_assert_valid(
    "wpt parse-descendant.html: valid div * p",
    "div * p",
    ["div * p"],
    false,
  )
}

///|
test "wpt parse-descendant.html: valid div p *[href]" {
  wpt_assert_valid(
    "wpt parse-descendant.html: valid div p *[href]",
    "div p *[href]",
    ["div p *[href]", "div p [href]"],
    false,
  )
}
