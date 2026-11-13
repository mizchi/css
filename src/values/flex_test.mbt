///|
fn flex(value : String) -> String {
  match @values.parse_flex_shorthand(value) {
    Some(f) => "\{f.grow} \{f.shrink} \{f.basis}"
    None => "invalid"
  }
}

///|
test "parse_flex_shorthand follows css-flexbox-1 7.2" {
  inspect(flex("none"), content="0 0 auto")
  inspect(flex("auto"), content="1 1 auto")
  inspect(flex("1"), content="1 1 0%")
  inspect(flex(".5"), content="0.5 1 0%")
  inspect(flex("0"), content="0 1 0%")
  inspect(flex("2 3"), content="2 3 0%")
  inspect(flex("2 3 0"), content="2 3 0")
  inspect(flex("0 0 40px"), content="0 0 40px")
  inspect(flex("40px"), content="1 1 40px")
  inspect(flex("0% 1"), content="1 1 0%")
  inspect(flex("30px 2 0"), content="2 0 30px")
  inspect(flex("content 2"), content="2 1 content")
  inspect(flex("1 calc(10% + 4px)"), content="1 1 calc(10% + 4px)")
}

///|
test "parse_flex_shorthand rejects invalid values" {
  inspect(flex("1 0% 1"), content="invalid")
  inspect(flex("1 2 3"), content="invalid")
  inspect(flex("10px 20px"), content="invalid")
  inspect(flex("-1"), content="invalid")
  inspect(flex("px"), content="invalid")
  inspect(flex(""), content="invalid")
}
