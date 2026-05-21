/// Auto-generated from css/selectors/parsing/parse-state.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt parse-state.html: valid :state(--foo)" {
  wpt_assert_valid(
    "wpt parse-state.html: valid :state(--foo)",
    ":state(--foo)",
    [":state(--foo)"],
    false,
  )
}

///|
test "wpt parse-state.html: valid :state(bar)" {
  wpt_assert_valid(
    "wpt parse-state.html: valid :state(bar)",
    ":state(bar)",
    [":state(bar)"],
    false,
  )
}

///|
test "wpt parse-state.html: valid :state(--)" {
  wpt_assert_valid(
    "wpt parse-state.html: valid :state(--)",
    ":state(--)",
    [":state(--)"],
    false,
  )
}

///|
test "wpt parse-state.html: valid :state(--0)" {
  wpt_assert_valid(
    "wpt parse-state.html: valid :state(--0)",
    ":state(--0)",
    [":state(--0)"],
    false,
  )
}

///|
test "wpt parse-state.html: valid :host(:state(--foo))" {
  wpt_assert_valid(
    "wpt parse-state.html: valid :host(:state(--foo))",
    ":host(:state(--foo))",
    [":host(:state(--foo))"],
    false,
  )
}

///|
test "wpt parse-state.html: valid my-input[type=\"foo\"]:state(checked)" {
  wpt_assert_valid(
    "wpt parse-state.html: valid my-input[type=\"foo\"]:state(checked)",
    "my-input[type=\"foo\"]:state(checked)",
    ["my-input[type=\"foo\"]:state(checked)"],
    false,
  )
}

///|
test "wpt parse-state.html: valid my-input[type=\"foo\"]:state(--0)::before" {
  wpt_assert_valid(
    "wpt parse-state.html: valid my-input[type=\"foo\"]:state(--0)::before",
    "my-input[type=\"foo\"]:state(--0)::before",
    ["my-input[type=\"foo\"]:state(--0)::before"],
    false,
  )
}

///|
test "wpt parse-state.html: valid my-input[type=\"foo\"]:state(--0)::part(inner)" {
  wpt_assert_valid(
    "wpt parse-state.html: valid my-input[type=\"foo\"]:state(--0)::part(inner)",
    "my-input[type=\"foo\"]:state(--0)::part(inner)",
    ["my-input[type=\"foo\"]:state(--0)::part(inner)"],
    false,
  )
}

///|
test "wpt parse-state.html: valid my-input[type=\"foo\"]:state(--0)::part(inner):state(bar)" {
  wpt_assert_valid(
    "wpt parse-state.html: valid my-input[type=\"foo\"]:state(--0)::part(inner):state(bar)",
    "my-input[type=\"foo\"]:state(--0)::part(inner):state(bar)",
    ["my-input[type=\"foo\"]:state(--0)::part(inner):state(bar)"],
    false,
  )
}

///|
test "wpt parse-state.html: valid ::part(inner):state(bar)::before" {
  wpt_assert_valid(
    "wpt parse-state.html: valid ::part(inner):state(bar)::before",
    "::part(inner):state(bar)::before",
    ["::part(inner):state(bar)::before"],
    false,
  )
}

///|
test "wpt parse-state.html: valid ::part(inner):state(bar)::after" {
  wpt_assert_valid(
    "wpt parse-state.html: valid ::part(inner):state(bar)::after",
    "::part(inner):state(bar)::after",
    ["::part(inner):state(bar)::after"],
    false,
  )
}

///|
test "wpt parse-state.html: invalid :state" {
  wpt_assert_invalid("wpt parse-state.html: invalid :state", ":state", false)
}

///|
test "wpt parse-state.html: invalid :state(" {
  wpt_assert_invalid("wpt parse-state.html: invalid :state(", ":state(", false)
}

///|
test "wpt parse-state.html: invalid :state()" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid :state()", ":state()", false,
  )
}

///|
test "wpt parse-state.html: invalid :state(0)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid :state(0)", ":state(0)", false,
  )
}

///|
test "wpt parse-state.html: invalid :state(0rem)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid :state(0rem)", ":state(0rem)", false,
  )
}

///|
test "wpt parse-state.html: invalid :state(url())" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid :state(url())", ":state(url())", false,
  )
}

///|
test "wpt parse-state.html: invalid :state(foo(1))" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid :state(foo(1))", ":state(foo(1))", false,
  )
}

///|
test "wpt parse-state.html: invalid :state(:host)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid :state(:host)", ":state(:host)", false,
  )
}

///|
test "wpt parse-state.html: invalid my-input::after:state(foo)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid my-input::after:state(foo)", "my-input::after:state(foo)",
    false,
  )
}

///|
test "wpt parse-state.html: invalid ::part(inner):state(bar)::before:state(foo)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid ::part(inner):state(bar)::before:state(foo)",
    "::part(inner):state(bar)::before:state(foo)", false,
  )
}

///|
test "wpt parse-state.html: invalid ::part(inner):state(bar)::after:state(foo)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid ::part(inner):state(bar)::after:state(foo)", "::part(inner):state(bar)::after:state(foo)",
    false,
  )
}

///|
test "wpt parse-state.html: invalid my-input::first-letter:state(foo)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid my-input::first-letter:state(foo)", "my-input::first-letter:state(foo)",
    false,
  )
}

///|
test "wpt parse-state.html: invalid ::slotted(foo):state(foo)" {
  wpt_assert_invalid(
    "wpt parse-state.html: invalid ::slotted(foo):state(foo)", "::slotted(foo):state(foo)",
    false,
  )
}
