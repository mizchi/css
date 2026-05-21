/// Auto-generated from css/selectors/parsing/parse-attribute.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-attribute.html: valid [att]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [att]", "[att]", ["[att]"], false)
}

///|
test "wpt parse-attribute.html: valid [att=val]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [att=val]", "[att=val]", ["[att=\"val\"]"], false)
}

///|
test "wpt parse-attribute.html: valid [att~=val]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [att~=val]", "[att~=val]", ["[att~=\"val\"]"], false)
}

///|
test "wpt parse-attribute.html: valid [att|=val]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [att|=val]", "[att|=val]", ["[att|=\"val\"]"], false)
}

///|
test "wpt parse-attribute.html: valid h1[title]" {
  wpt_assert_valid("wpt parse-attribute.html: valid h1[title]", "h1[title]", ["h1[title]"], false)
}

///|
test "wpt parse-attribute.html: valid span[class='example']" {
  wpt_assert_valid("wpt parse-attribute.html: valid span[class='example']", "span[class='example']", ["span[class=\"example\"]"], false)
}

///|
test "wpt parse-attribute.html: valid a[hreflang=fr]" {
  wpt_assert_valid("wpt parse-attribute.html: valid a[hreflang=fr]", "a[hreflang=fr]", ["a[hreflang=\"fr\"]"], false)
}

///|
test "wpt parse-attribute.html: valid a[hreflang|='en']" {
  wpt_assert_valid("wpt parse-attribute.html: valid a[hreflang|='en']", "a[hreflang|='en']", ["a[hreflang|=\"en\"]"], false)
}

///|
test "wpt parse-attribute.html: valid [att^=val]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [att^=val]", "[att^=val]", ["[att^=\"val\"]"], false)
}

///|
test "wpt parse-attribute.html: valid [att$=val]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [att$=val]", "[att$=val]", ["[att$=\"val\"]"], false)
}

///|
test "wpt parse-attribute.html: valid [att*=val]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [att*=val]", "[att*=val]", ["[att*=\"val\"]"], false)
}

///|
test "wpt parse-attribute.html: valid object[type^=\"image/\"]" {
  wpt_assert_valid("wpt parse-attribute.html: valid object[type^=\"image/\"]", "object[type^=\"image/\"]", ["object[type^=\"image/\"]"], false)
}

///|
test "wpt parse-attribute.html: valid a[href$=\".html\"]" {
  wpt_assert_valid("wpt parse-attribute.html: valid a[href$=\".html\"]", "a[href$=\".html\"]", ["a[href$=\".html\"]"], false)
}

///|
test "wpt parse-attribute.html: valid p[title*=\"hello\"]" {
  wpt_assert_valid("wpt parse-attribute.html: valid p[title*=\"hello\"]", "p[title*=\"hello\"]", ["p[title*=\"hello\"]"], false)
}

///|
test "wpt parse-attribute.html: valid [*|att]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [*|att]", "[*|att]", ["[*|att]"], false)
}

///|
test "wpt parse-attribute.html: valid [|att]" {
  wpt_assert_valid("wpt parse-attribute.html: valid [|att]", "[|att]", ["[att]"], false)
}
