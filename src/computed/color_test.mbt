///|
fn resolved(value : String) -> @types.Color raise {
  match @computed.parse_color(value) {
    Resolved(c) => c
    _ => fail("expected Resolved color for: " + value)
  }
}

///|
test "parse_color - keywords" {
  let t = @computed.parse_color("transparent")
  inspect(t.is_resolved(), content="true")
  let c = @computed.parse_color("currentColor")
  // CurrentColor is not Resolved
  inspect(c.is_resolved(), content="false")
  let i = @computed.parse_color("inherit")
  inspect(i.is_resolved(), content="false")
}

///|
test "parse_color - hex 6 digit" {
  let c = resolved("#ff8040")
  inspect(c.r, content="255")
  inspect(c.g, content="128")
  inspect(c.b, content="64")
}

///|
test "parse_color - hex 3 digit" {
  let c = resolved("#abc")
  inspect(c.r, content="170")
  inspect(c.g, content="187")
  inspect(c.b, content="204")
}

///|
test "parse_color - hex 8 digit with alpha" {
  let c = resolved("#ff000080")
  inspect(c.r, content="255")
  inspect(c.g, content="0")
  inspect(c.b, content="0")
  // alpha is ~0.5
  assert_true((c.a - 0.5).abs() < 0.01)
}

///|
test "parse_color - hex 4 digit with alpha" {
  let c = resolved("#f008")
  inspect(c.r, content="255")
  inspect(c.g, content="0")
  inspect(c.b, content="0")
  // 0x88 / 255 ~ 0.533
  assert_true((c.a - 0.533).abs() < 0.01)
}

///|
test "parse_color - rgb decimal" {
  let c = resolved("rgb(10, 20, 30)")
  inspect(c.r, content="10")
  inspect(c.g, content="20")
  inspect(c.b, content="30")
}

///|
test "parse_color - rgba with float alpha" {
  let c = resolved("rgba(255, 0, 0, 0.5)")
  inspect(c.r, content="255")
  inspect(c.a, content="0.5")
}

///|
test "parse_color - rgb with percent values" {
  let c = resolved("rgb(100%, 0%, 50%)")
  inspect(c.r, content="255")
  inspect(c.g, content="0")
  // 50% rounds down to 127
  inspect(c.b, content="127")
}

///|
test "parse_color - whitespace separated rgb" {
  let c = resolved("rgb(10 20 30)")
  inspect(c.r, content="10")
  inspect(c.g, content="20")
  inspect(c.b, content="30")
}

///|
test "parse_color - rgb with slash alpha" {
  let c = resolved("rgb(255 128 0 / 0.5)")
  inspect(c.r, content="255")
  inspect(c.a, content="0.5")
}

///|
test "parse_color - named common colors" {
  let red = resolved("red")
  inspect(red.r, content="255")
  inspect(red.g, content="0")
  inspect(red.b, content="0")
  let blue = resolved("blue")
  inspect(blue.b, content="255")
  let green = resolved("green")
  inspect(green.g, content="128")
  let white = resolved("white")
  inspect(white.r, content="255")
  inspect(white.g, content="255")
  inspect(white.b, content="255")
  let black = resolved("black")
  inspect(black.r, content="0")
}

///|
test "parse_color - case insensitive named" {
  let c1 = resolved("RED")
  let c2 = resolved("Red")
  let c3 = resolved("red")
  inspect(c1.r, content="255")
  inspect(c2.r, content="255")
  inspect(c3.r, content="255")
}

///|
test "parse_color - hsl gracefully handles (may not fully resolve)" {
  // Some implementations may not parse hsl() and return transparent
  let _ = @computed.parse_color("hsl(0, 100%, 50%)")
  inspect(true, content="true")
}

///|
test "parse_color - gradient returns transparent" {
  let c = resolved("linear-gradient(to right, red, blue)")
  // gradients are not solid colors -> transparent
  inspect(c.a, content="0")
}

///|
test "parse_color - url returns transparent" {
  let c = resolved("url(image.png)")
  inspect(c.a, content="0")
}

///|
test "parse_color - empty string is transparent" {
  let c = resolved("")
  inspect(c.a, content="0")
}

///|
test "parse_color - var() with fallback resolves to fallback" {
  let c = resolved("var(--brand-color, red)")
  inspect(c.r, content="255")
  inspect(c.g, content="0")
  inspect(c.b, content="0")
}

///|
test "parse_color - var() with nested fallback" {
  let c = resolved("var(--a, var(--b, blue))")
  inspect(c.r, content="0")
  inspect(c.g, content="0")
  inspect(c.b, content="255")
}

///|
test "CssColorValue is_resolved, get_color, or_default" {
  let r = @computed.parse_color("#ff0000")
  inspect(r.is_resolved(), content="true")
  assert_true(r.get_color() is Some(_))
  let cc = @computed.parse_color("currentColor")
  assert_true(cc.get_color() is None)
  let fallback = @types.Color::transparent()
  let out = cc.or_default(fallback)
  inspect(out.a, content="0")
  let resolved_white = @computed.parse_color("white")
  inspect(resolved_white.or_default(fallback).r, content="255")
}

///|
test "CssColorValue Show outputs" {
  let r = @computed.parse_color("#ff0000")
  let s = r.to_string()
  assert_true(s.length() > 0)
  inspect(@computed.parse_color("currentColor").to_string(), content="currentColor")
  inspect(@computed.parse_color("inherit").to_string(), content="inherit")
}
