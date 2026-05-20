/// Auto-generated from css/selectors/parsing/parse-is.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-is.html: valid :is(ul,ol,.list) > [hidden]" {
  wpt_assert_valid("wpt parse-is.html: valid :is(ul,ol,.list) > [hidden]", ":is(ul,ol,.list) > [hidden]", [":is(ul, ol, .list) > [hidden]"], false)
}

///|
test "wpt parse-is.html: valid :is(:hover,:focus)" {
  wpt_assert_valid("wpt parse-is.html: valid :is(:hover,:focus)", ":is(:hover,:focus)", [":is(:hover, :focus)"], false)
}

///|
test "wpt parse-is.html: valid a:is(:not(:hover))" {
  wpt_assert_valid("wpt parse-is.html: valid a:is(:not(:hover))", "a:is(:not(:hover))", ["a:is(:not(:hover))"], false)
}

///|
test "wpt parse-is.html: valid :is(#a)" {
  wpt_assert_valid("wpt parse-is.html: valid :is(#a)", ":is(#a)", [":is(#a)"], false)
}

///|
test "wpt parse-is.html: valid .a.b ~ :is(.c.d ~ .e.f)" {
  wpt_assert_valid("wpt parse-is.html: valid .a.b ~ :is(.c.d ~ .e.f)", ".a.b ~ :is(.c.d ~ .e.f)", [".a.b ~ :is(.c.d ~ .e.f)"], false)
}

///|
test "wpt parse-is.html: valid .a.b ~ .c.d:is(span.e + .f, .g.h > .i.j .k)" {
  wpt_assert_valid("wpt parse-is.html: valid .a.b ~ .c.d:is(span.e + .f, .g.h > .i.j .k)", ".a.b ~ .c.d:is(span.e + .f, .g.h > .i.j .k)", [".a.b ~ .c.d:is(span.e + .f, .g.h > .i.j .k)"], false)
}
