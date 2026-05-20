/// Auto-generated from css/selectors/parsing/parse-slotted.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-slotted.html: valid ::slotted(bar)" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(bar)", "::slotted(bar)", ["::slotted(bar)"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted([attr=\"foo\"])" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted([attr=\"foo\"])", "::slotted([attr=\"foo\"])", ["::slotted([attr=\"foo\"])"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted(*)" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(*)", "::slotted(*)", ["::slotted(*)"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted(.class)" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(.class)", "::slotted(.class)", ["::slotted(.class)"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted(:not(foo))" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(:not(foo))", "::slotted(:not(foo))", ["::slotted(:not(foo))"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted(:not(:nth-last-of-type(2)):not([slot=\"foo\"]))" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(:not(:nth-last-of-type(2)):not([slot=\"foo\"]))", "::slotted(:not(:nth-last-of-type(2)):not([slot=\"foo\"]))", ["::slotted(:not(:nth-last-of-type(2)):not([slot=\"foo\"]))"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted(:first-child)" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(:first-child)", "::slotted(:first-child)", ["::slotted(:first-child)"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted(:hover)" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(:hover)", "::slotted(:hover)", ["::slotted(:hover)"], false)
}

///|
test "wpt parse-slotted.html: valid ::slotted(:has(:first-child:last-child))" {
  wpt_assert_valid("wpt parse-slotted.html: valid ::slotted(:has(:first-child:last-child))", "::slotted(:has(:first-child:last-child))", ["::slotted(:has(:first-child:last-child))"], false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted", "::slotted", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted()" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted()", "::slotted()", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted(0)" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted(0)", "::slotted(0)", false)
}

///|
test "wpt parse-slotted.html: invalid :slotted(foo)" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid :slotted(foo)", ":slotted(foo)", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted(foo):first-child" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted(foo):first-child", "::slotted(foo):first-child", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted(foo):hover" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted(foo):hover", "::slotted(foo):hover", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted(foo):focus" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted(foo):focus", "::slotted(foo):focus", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted(foo):lang(en)" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted(foo):lang(en)", "::slotted(foo):lang(en)", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted(foo):dir(ltr)" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted(foo):dir(ltr)", "::slotted(foo):dir(ltr)", false)
}

///|
test "wpt parse-slotted.html: invalid ::slotted(foo) + ::slotted(bar)" {
  wpt_assert_invalid("wpt parse-slotted.html: invalid ::slotted(foo) + ::slotted(bar)", "::slotted(foo) + ::slotted(bar)", false)
}
