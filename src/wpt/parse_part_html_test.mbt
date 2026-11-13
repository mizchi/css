/// Auto-generated from css/selectors/parsing/parse-part.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-part.html: valid ::part(--foo)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(--foo)",
    "::part(--foo)",
    ["::part(--foo)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(bar)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(bar)",
    "::part(bar)",
    ["::part(bar)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(--)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(--)",
    "::part(--)",
    ["::part(--)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(--0)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(--0)",
    "::part(--0)",
    ["::part(--0)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo bar)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo bar)",
    "::part(foo bar)",
    ["::part(foo bar)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(-foo bar)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(-foo bar)",
    "::part(-foo bar)",
    ["::part(-foo bar)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):focus" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):focus",
    "::part(foo):focus",
    ["::part(foo):focus"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):hover" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):hover",
    "::part(foo):hover",
    ["::part(foo):hover"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):focus-within" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):focus-within",
    "::part(foo):focus-within",
    ["::part(foo):focus-within"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo)::before" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo)::before",
    "::part(foo)::before",
    ["::part(foo)::before"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo)::after" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo)::after",
    "::part(foo)::after",
    ["::part(foo)::after"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo)::placeholder" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo)::placeholder",
    "::part(foo)::placeholder",
    ["::part(foo)::placeholder"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo)::first-line" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo)::first-line",
    "::part(foo)::first-line",
    ["::part(foo)::first-line"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo)::first-letter" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo)::first-letter",
    "::part(foo)::first-letter",
    ["::part(foo)::first-letter"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo)::file-selector-button" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo)::file-selector-button",
    "::part(foo)::file-selector-button",
    ["::part(foo)::file-selector-button"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):is(:focus)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):is(:focus)",
    "::part(foo):is(:focus)",
    ["::part(foo):is(:focus)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid :lang(en)::part(foo)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid :lang(en)::part(foo)",
    ":lang(en)::part(foo)",
    [":lang(en)::part(foo)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid :dir(ltr)::part(foo)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid :dir(ltr)::part(foo)",
    ":dir(ltr)::part(foo)",
    [":dir(ltr)::part(foo)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):lang(en)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):lang(en)",
    "::part(foo):lang(en)",
    ["::part(foo):lang(en)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):dir(ltr)" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):dir(ltr)",
    "::part(foo):dir(ltr)",
    ["::part(foo):dir(ltr)"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):disabled" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):disabled",
    "::part(foo):disabled",
    ["::part(foo):disabled"],
    false,
  )
}

///|
test "wpt parse-part.html: valid ::part(foo):checked" {
  @wpt.wpt_assert_valid(
    "wpt parse-part.html: valid ::part(foo):checked",
    "::part(foo):checked",
    ["::part(foo):checked"],
    false,
  )
}

///|
test "wpt parse-part.html: invalid :part()" {
  @wpt.wpt_assert_invalid(
    "wpt parse-part.html: invalid :part()", ":part()", false,
  )
}

///|
test "wpt parse-part.html: invalid :part(0)" {
  @wpt.wpt_assert_invalid(
    "wpt parse-part.html: invalid :part(0)", ":part(0)", false,
  )
}

///|
test "wpt parse-part.html: invalid :part('foo')" {
  @wpt.wpt_assert_invalid(
    "wpt parse-part.html: invalid :part('foo')", ":part('foo')", false,
  )
}

///|
test "wpt parse-part.html: invalid :part([foo])" {
  @wpt.wpt_assert_invalid(
    "wpt parse-part.html: invalid :part([foo])", ":part([foo])", false,
  )
}

///|
test "wpt parse-part.html: invalid ::part(foo) + ::part(bar)" {
  @wpt.wpt_assert_invalid(
    "wpt parse-part.html: invalid ::part(foo) + ::part(bar)", "::part(foo) + ::part(bar)",
    false,
  )
}

///|
test "wpt parse-part.html: invalid ::part(foo):has(li)" {
  @wpt.wpt_assert_invalid(
    "wpt parse-part.html: invalid ::part(foo):has(li)", "::part(foo):has(li)", false,
  )
}
