/// Auto-generated from css/selectors/parsing/parse-has.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-has.html: valid :has(a)" {
  wpt_assert_valid("wpt parse-has.html: valid :has(a)", ":has(a)", [":has(a)"], false)
}

///|
test "wpt parse-has.html: valid :has(#a)" {
  wpt_assert_valid("wpt parse-has.html: valid :has(#a)", ":has(#a)", [":has(#a)"], false)
}

///|
test "wpt parse-has.html: valid :has(.a)" {
  wpt_assert_valid("wpt parse-has.html: valid :has(.a)", ":has(.a)", [":has(.a)"], false)
}

///|
test "wpt parse-has.html: valid :has([a])" {
  wpt_assert_valid("wpt parse-has.html: valid :has([a])", ":has([a])", [":has([a])"], false)
}

///|
test "wpt parse-has.html: valid :has([a=\"b\"])" {
  wpt_assert_valid("wpt parse-has.html: valid :has([a=\"b\"])", ":has([a=\"b\"])", [":has([a=\"b\"])"], false)
}

///|
test "wpt parse-has.html: valid :has([a|=\"b\"])" {
  wpt_assert_valid("wpt parse-has.html: valid :has([a|=\"b\"])", ":has([a|=\"b\"])", [":has([a|=\"b\"])"], false)
}

///|
test "wpt parse-has.html: valid :has(:hover)" {
  wpt_assert_valid("wpt parse-has.html: valid :has(:hover)", ":has(:hover)", [":has(:hover)"], false)
}

///|
test "wpt parse-has.html: valid *:has(.a)" {
  wpt_assert_valid("wpt parse-has.html: valid *:has(.a)", "*:has(.a)", ["*:has(.a)", ":has(.a)"], false)
}

///|
test "wpt parse-has.html: valid .a:has(.b)" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(.b)", ".a:has(.b)", [".a:has(.b)"], false)
}

///|
test "wpt parse-has.html: valid .a:has(> .b)" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(> .b)", ".a:has(> .b)", [".a:has(> .b)"], false)
}

///|
test "wpt parse-has.html: valid .a:has(~ .b)" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(~ .b)", ".a:has(~ .b)", [".a:has(~ .b)"], false)
}

///|
test "wpt parse-has.html: valid .a:has(+ .b)" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(+ .b)", ".a:has(+ .b)", [".a:has(+ .b)"], false)
}

///|
test "wpt parse-has.html: valid .a:has(.b) .c" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(.b) .c", ".a:has(.b) .c", [".a:has(.b) .c"], false)
}

///|
test "wpt parse-has.html: valid .a .b:has(.c)" {
  wpt_assert_valid("wpt parse-has.html: valid .a .b:has(.c)", ".a .b:has(.c)", [".a .b:has(.c)"], false)
}

///|
test "wpt parse-has.html: valid .a .b:has(.c .d)" {
  wpt_assert_valid("wpt parse-has.html: valid .a .b:has(.c .d)", ".a .b:has(.c .d)", [".a .b:has(.c .d)"], false)
}

///|
test "wpt parse-has.html: valid .a .b:has(.c .d) .e" {
  wpt_assert_valid("wpt parse-has.html: valid .a .b:has(.c .d) .e", ".a .b:has(.c .d) .e", [".a .b:has(.c .d) .e"], false)
}

///|
test "wpt parse-has.html: valid .a:has(.b:is(.c .d))" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(.b:is(.c .d))", ".a:has(.b:is(.c .d))", [".a:has(.b:is(.c .d))"], false)
}

///|
test "wpt parse-has.html: valid .a:is(.b:has(.c) .d)" {
  wpt_assert_valid("wpt parse-has.html: valid .a:is(.b:has(.c) .d)", ".a:is(.b:has(.c) .d)", [".a:is(.b:has(.c) .d)"], false)
}

///|
test "wpt parse-has.html: valid .a:not(:has(.b))" {
  wpt_assert_valid("wpt parse-has.html: valid .a:not(:has(.b))", ".a:not(:has(.b))", [".a:not(:has(.b))"], false)
}

///|
test "wpt parse-has.html: valid .a:has(:not(.b))" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(:not(.b))", ".a:has(:not(.b))", [".a:has(:not(.b))"], false)
}

///|
test "wpt parse-has.html: valid .a:has(.b):has(.c)" {
  wpt_assert_valid("wpt parse-has.html: valid .a:has(.b):has(.c)", ".a:has(.b):has(.c)", [".a:has(.b):has(.c)"], false)
}

///|
test "wpt parse-has.html: valid *|*:has(*)" {
  wpt_assert_valid("wpt parse-has.html: valid *|*:has(*)", "*|*:has(*)", [":has(*)"], true)
}

///|
test "wpt parse-has.html: valid :has(*|*)" {
  wpt_assert_valid("wpt parse-has.html: valid :has(*|*)", ":has(*|*)", [":has(*)"], true)
}

///|
test "wpt parse-has.html: invalid :has" {
  wpt_assert_invalid("wpt parse-has.html: invalid :has", ":has", false)
}

///|
test "wpt parse-has.html: invalid .a:has" {
  wpt_assert_invalid("wpt parse-has.html: invalid .a:has", ".a:has", false)
}

///|
test "wpt parse-has.html: invalid .a:has b" {
  wpt_assert_invalid("wpt parse-has.html: invalid .a:has b", ".a:has b", false)
}

///|
test "wpt parse-has.html: invalid :has()" {
  wpt_assert_invalid("wpt parse-has.html: invalid :has()", ":has()", true)
}

///|
test "wpt parse-has.html: invalid :has(123)" {
  wpt_assert_invalid("wpt parse-has.html: invalid :has(123)", ":has(123)", false)
}

///|
test "wpt parse-has.html: invalid :has(.a, 123)" {
  wpt_assert_invalid("wpt parse-has.html: invalid :has(.a, 123)", ":has(.a, 123)", false)
}
