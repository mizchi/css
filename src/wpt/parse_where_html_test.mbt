/// Auto-generated from css/selectors/parsing/parse-where.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-where.html: valid :where(ul,ol,.list) > [hidden]" {
  wpt_assert_valid("wpt parse-where.html: valid :where(ul,ol,.list) > [hidden]", ":where(ul,ol,.list) > [hidden]", [":where(ul, ol, .list) > [hidden]"], false)
}

///|
test "wpt parse-where.html: valid :where(:hover,:focus)" {
  wpt_assert_valid("wpt parse-where.html: valid :where(:hover,:focus)", ":where(:hover,:focus)", [":where(:hover, :focus)"], false)
}

///|
test "wpt parse-where.html: valid a:where(:not(:hover))" {
  wpt_assert_valid("wpt parse-where.html: valid a:where(:not(:hover))", "a:where(:not(:hover))", ["a:where(:not(:hover))"], false)
}

///|
test "wpt parse-where.html: valid :where(#a)" {
  wpt_assert_valid("wpt parse-where.html: valid :where(#a)", ":where(#a)", [":where(#a)"], false)
}

///|
test "wpt parse-where.html: valid .a.b ~ :where(.c.d ~ .e.f)" {
  wpt_assert_valid("wpt parse-where.html: valid .a.b ~ :where(.c.d ~ .e.f)", ".a.b ~ :where(.c.d ~ .e.f)", [".a.b ~ :where(.c.d ~ .e.f)"], false)
}

///|
test "wpt parse-where.html: valid .a.b ~ .c.d:where(span.e + .f, .g.h > .i.j .k)" {
  wpt_assert_valid("wpt parse-where.html: valid .a.b ~ .c.d:where(span.e + .f, .g.h > .i.j .k)", ".a.b ~ .c.d:where(span.e + .f, .g.h > .i.j .k)", [".a.b ~ .c.d:where(span.e + .f, .g.h > .i.j .k)"], false)
}
