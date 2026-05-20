/// Auto-generated from css/selectors/parsing/parse-heading.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-heading.html: valid :heading" {
  wpt_assert_valid("wpt parse-heading.html: valid :heading", ":heading", [":heading"], false)
}

///|
test "wpt parse-heading.html: valid :heading(2)" {
  wpt_assert_valid("wpt parse-heading.html: valid :heading(2)", ":heading(2)", [":heading(2)"], false)
}

///|
test "wpt parse-heading.html: valid :heading(99999)" {
  wpt_assert_valid("wpt parse-heading.html: valid :heading(99999)", ":heading(99999)", [":heading(99999)"], false)
}

///|
test "wpt parse-heading.html: valid :heading(0)" {
  wpt_assert_valid("wpt parse-heading.html: valid :heading(0)", ":heading(0)", [":heading(0)"], false)
}

///|
test "wpt parse-heading.html: valid :heading(0, 1, 2)" {
  wpt_assert_valid("wpt parse-heading.html: valid :heading(0, 1, 2)", ":heading(0, 1, 2)", [":heading(0, 1, 2)"], false)
}

///|
test "wpt parse-heading.html: valid :heading(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)" {
  wpt_assert_valid("wpt parse-heading.html: valid :heading(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)", ":heading(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)", [":heading(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)"], false)
}

///|
test "wpt parse-heading.html: valid :heading(-1)" {
  wpt_assert_valid("wpt parse-heading.html: valid :heading(-1)", ":heading(-1)", [":heading(-1)"], false)
}

///|
test "wpt parse-heading.html: valid h1:heading" {
  wpt_assert_valid("wpt parse-heading.html: valid h1:heading", "h1:heading", ["h1:heading"], false)
}

///|
test "wpt parse-heading.html: valid h1:heading(1)" {
  wpt_assert_valid("wpt parse-heading.html: valid h1:heading(1)", "h1:heading(1)", ["h1:heading(1)"], false)
}

///|
test "wpt parse-heading.html: valid h1:heading(2)" {
  wpt_assert_valid("wpt parse-heading.html: valid h1:heading(2)", "h1:heading(2)", ["h1:heading(2)"], false)
}

///|
test "wpt parse-heading.html: invalid :heading()" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading()", ":heading()", false)
}

///|
test "wpt parse-heading.html: invalid :heading(1.0)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(1.0)", ":heading(1.0)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(1.4)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(1.4)", ":heading(1.4)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(n)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(n)", ":heading(n)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(odd)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(odd)", ":heading(odd)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(even)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(even)", ":heading(even)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(2n)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(2n)", ":heading(2n)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(2n+1)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(2n+1)", ":heading(2n+1)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(2n+2)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(2n+2)", ":heading(2n+2)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(-n+3)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(-n+3)", ":heading(-n+3)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(2n, 3n)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(2n, 3n)", ":heading(2n, 3n)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(2, 3n)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(2, 3n)", ":heading(2, 3n)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(2 of .foo)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(2 of .foo)", ":heading(2 of .foo)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(2n of .foo)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(2n of .foo)", ":heading(2n of .foo)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(calc(1))" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(calc(1))", ":heading(calc(1))", false)
}

///|
test "wpt parse-heading.html: invalid :heading(max(1, 2))" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(max(1, 2))", ":heading(max(1, 2))", false)
}

///|
test "wpt parse-heading.html: invalid :heading(min(1, 2)" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(min(1, 2)", ":heading(min(1, 2)", false)
}

///|
test "wpt parse-heading.html: invalid :heading(var(--level))" {
  wpt_assert_invalid("wpt parse-heading.html: invalid :heading(var(--level))", ":heading(var(--level))", false)
}
