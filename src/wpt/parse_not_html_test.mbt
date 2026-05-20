/// Auto-generated from css/selectors/parsing/parse-not.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-not.html: valid button:not([disabled])" {
  wpt_assert_valid("wpt parse-not.html: valid button:not([disabled])", "button:not([disabled])", ["button:not([disabled])"], false)
}

///|
test "wpt parse-not.html: valid *:not(foo)" {
  wpt_assert_valid("wpt parse-not.html: valid *:not(foo)", "*:not(foo)", ["*:not(foo)", ":not(foo)"], false)
}

///|
test "wpt parse-not.html: valid :not(:link):not(:visited)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(:link):not(:visited)", ":not(:link):not(:visited)", [":not(:link):not(:visited)"], false)
}

///|
test "wpt parse-not.html: valid *|*:not(*)" {
  wpt_assert_valid("wpt parse-not.html: valid *|*:not(*)", "*|*:not(*)", [":not(*)"], true)
}

///|
test "wpt parse-not.html: valid :not(:hover)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(:hover)", ":not(:hover)", [":not(:hover)"], false)
}

///|
test "wpt parse-not.html: valid :not(*|*)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(*|*)", ":not(*|*)", [":not(*)"], true)
}

///|
test "wpt parse-not.html: valid foo:not(bar)" {
  wpt_assert_valid("wpt parse-not.html: valid foo:not(bar)", "foo:not(bar)", ["foo:not(bar)"], false)
}

///|
test "wpt parse-not.html: valid :not(:not(foo))" {
  wpt_assert_valid("wpt parse-not.html: valid :not(:not(foo))", ":not(:not(foo))", [":not(:not(foo))"], false)
}

///|
test "wpt parse-not.html: valid :not(.a .b)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(.a .b)", ":not(.a .b)", [":not(.a .b)"], false)
}

///|
test "wpt parse-not.html: valid :not(.a + .b)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(.a + .b)", ":not(.a + .b)", [":not(.a + .b)"], true)
}

///|
test "wpt parse-not.html: valid :not(.a .b ~ c)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(.a .b ~ c)", ":not(.a .b ~ c)", [":not(.a .b ~ c)"], true)
}

///|
test "wpt parse-not.html: valid :not(span.a, div.b)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(span.a, div.b)", ":not(span.a, div.b)", [":not(span.a, div.b)"], false)
}

///|
test "wpt parse-not.html: valid :not(.a .b ~ c, .d .e)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(.a .b ~ c, .d .e)", ":not(.a .b ~ c, .d .e)", [":not(.a .b ~ c, .d .e)"], true)
}

///|
test "wpt parse-not.html: valid :not(:host)" {
  wpt_assert_valid("wpt parse-not.html: valid :not(:host)", ":not(:host)", [":not(:host)"], false)
}

///|
test "wpt parse-not.html: valid :not(:host(.a))" {
  wpt_assert_valid("wpt parse-not.html: valid :not(:host(.a))", ":not(:host(.a))", [":not(:host(.a))"], true)
}

///|
test "wpt parse-not.html: valid :host(:not(.a))" {
  wpt_assert_valid("wpt parse-not.html: valid :host(:not(.a))", ":host(:not(.a))", [":host(:not(.a))"], true)
}

///|
test "wpt parse-not.html: valid :not(:host(:not(.a)))" {
  wpt_assert_valid("wpt parse-not.html: valid :not(:host(:not(.a)))", ":not(:host(:not(.a)))", [":not(:host(:not(.a)))"], true)
}

///|
test "wpt parse-not.html: valid :not([disabled][selected])" {
  wpt_assert_valid("wpt parse-not.html: valid :not([disabled][selected])", ":not([disabled][selected])", [":not([disabled][selected])"], false)
}

///|
test "wpt parse-not.html: valid :not([disabled],[selected])" {
  wpt_assert_valid("wpt parse-not.html: valid :not([disabled],[selected])", ":not([disabled],[selected])", [":not([disabled], [selected])"], false)
}

///|
test "wpt parse-not.html: invalid :not()" {
  wpt_assert_invalid("wpt parse-not.html: invalid :not()", ":not()", true)
}

///|
test "wpt parse-not.html: invalid :not(:not())" {
  wpt_assert_invalid("wpt parse-not.html: invalid :not(:not())", ":not(:not())", true)
}

///|
test "wpt parse-not.html: invalid :not(::before)" {
  wpt_assert_invalid("wpt parse-not.html: invalid :not(::before)", ":not(::before)", true)
}

///|
test "wpt parse-not.html: invalid :not(:unknownpseudo)" {
  wpt_assert_invalid("wpt parse-not.html: invalid :not(:unknownpseudo)", ":not(:unknownpseudo)", true)
}

///|
test "wpt parse-not.html: invalid :not(.a, :unknownpseudo)" {
  wpt_assert_invalid("wpt parse-not.html: invalid :not(.a, :unknownpseudo)", ":not(.a, :unknownpseudo)", true)
}

///|
test "wpt parse-not.html: invalid :not(:unknownpseudo, .a)" {
  wpt_assert_invalid("wpt parse-not.html: invalid :not(:unknownpseudo, .a)", ":not(:unknownpseudo, .a)", false)
}

///|
test "wpt parse-not.html: invalid :host(:not(.a .b))" {
  wpt_assert_invalid("wpt parse-not.html: invalid :host(:not(.a .b))", ":host(:not(.a .b))", false)
}
