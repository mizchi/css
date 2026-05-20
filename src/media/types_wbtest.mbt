///|
test "MediaQueryList - new, is_empty, length" {
  let empty = MediaQueryList::new()
  assert_true(empty.is_empty())
  inspect(empty.length(), content="0")
  let list = parse_media_query_list("screen, (min-width: 600px)")
  assert_false(list.is_empty())
  inspect(list.length(), content="2")
}

///|
test "MediaQuery::default" {
  let mq = MediaQuery::default()
  inspect(mq.negated, content="false")
  inspect(mq.only, content="false")
  inspect(mq.conditions.length(), content="0")
}

///|
test "Show MediaType" {
  inspect(MediaType::All, content="All")
  inspect(MediaType::Screen, content="Screen")
  inspect(MediaType::Print, content="Print")
  inspect(MediaType::Speech, content="Speech")
}

///|
test "Show RangeOp" {
  inspect(RangeOp::Eq, content="Eq")
  inspect(RangeOp::Lt, content="Lt")
  inspect(RangeOp::Le, content="Le")
  inspect(RangeOp::Gt, content="Gt")
  inspect(RangeOp::Ge, content="Ge")
}

///|
test "Show MediaValue" {
  inspect(MediaValue::Number(2.5), content="Number(2.5)")
  inspect(
    MediaValue::Dimension(768.0, "px"),
    content="Dimension(768, \"px\")",
  )
  inspect(MediaValue::Ratio(16, 9), content="Ratio(16, 9)")
  inspect(MediaValue::Ident("landscape"), content="Ident(\"landscape\")")
}

///|
test "Show MediaFeature - boolean features" {
  inspect(MediaFeature::Color, content="Color")
  inspect(MediaFeature::ColorGamut, content="ColorGamut")
  inspect(MediaFeature::ColorIndex, content="ColorIndex")
  inspect(MediaFeature::Grid, content="Grid")
  inspect(MediaFeature::Hover, content="Hover")
  inspect(MediaFeature::Monochrome, content="Monochrome")
  inspect(MediaFeature::Pointer, content="Pointer")
  inspect(MediaFeature::Scripting, content="Scripting")
  inspect(MediaFeature::Update, content="Update")
}

///|
test "Show MediaFeature - range features" {
  let v = MediaValue::Dimension(768.0, "px")
  inspect(MediaFeature::MinWidth(v), content="MinWidth(Dimension(768, \"px\"))")
  inspect(MediaFeature::MaxWidth(v), content="MaxWidth(Dimension(768, \"px\"))")
  inspect(MediaFeature::MinHeight(v), content="MinHeight(Dimension(768, \"px\"))")
  inspect(MediaFeature::MaxHeight(v), content="MaxHeight(Dimension(768, \"px\"))")
  let ratio = MediaValue::Ratio(16, 9)
  inspect(MediaFeature::MinAspectRatio(ratio), content="MinAspectRatio(Ratio(16, 9))")
  inspect(MediaFeature::MaxAspectRatio(ratio), content="MaxAspectRatio(Ratio(16, 9))")
  let dppx = MediaValue::Dimension(2.0, "dppx")
  inspect(MediaFeature::MinResolution(dppx), content="MinResolution(Dimension(2, \"dppx\"))")
  inspect(MediaFeature::MaxResolution(dppx), content="MaxResolution(Dimension(2, \"dppx\"))")
}

///|
test "Show MediaFeature - optional value features" {
  let s_width = (MediaFeature::Width(Some(MediaValue::Number(800.0)))).to_string()
  assert_true(s_width.contains("Width("))
  let s_height = (MediaFeature::Height(None)).to_string()
  assert_true(s_height.contains("Height("))
  let s_ar = (MediaFeature::AspectRatio(Some(MediaValue::Ratio(4, 3)))).to_string()
  assert_true(s_ar.contains("AspectRatio("))
  let s_res = (MediaFeature::Resolution(None)).to_string()
  assert_true(s_res.contains("Resolution("))
}

///|
test "Show MediaFeature - range syntax" {
  let v = MediaValue::Dimension(500.0, "px")
  let s = (MediaFeature::WidthRange(RangeOp::Le, v)).to_string()
  assert_true(s.contains("WidthRange("))
  let s2 = (MediaFeature::HeightRange(RangeOp::Ge, v)).to_string()
  assert_true(s2.contains("HeightRange("))
}

///|
test "Show MediaFeature - discrete features" {
  inspect(
    MediaFeature::Orientation("portrait"),
    content="Orientation(\"portrait\")",
  )
  inspect(
    MediaFeature::DisplayMode("standalone"),
    content="DisplayMode(\"standalone\")",
  )
  inspect(
    MediaFeature::PrefersColorScheme("dark"),
    content="PrefersColorScheme(\"dark\")",
  )
  inspect(
    MediaFeature::PrefersReducedMotion("reduce"),
    content="PrefersReducedMotion(\"reduce\")",
  )
}

///|
test "Show MediaFeature - custom" {
  let s = (MediaFeature::Custom("foo", Some(MediaValue::Number(1.0)))).to_string()
  assert_true(s.contains("Custom("))
  assert_true(s.contains("\"foo\""))
  let s2 = (MediaFeature::Custom("bar", None)).to_string()
  assert_true(s2.contains("Custom("))
}

///|
test "Show MediaQuery and MediaQueryList" {
  let mq : MediaQuery = {
    negated: true,
    only: false,
    media_type: Some(MediaType::Screen),
    conditions: [MediaFeature::Color],
  }
  let s = mq.to_string()
  assert_true(s.contains("negated: true"))
  assert_true(s.contains("media_type: Some"))
  assert_true(s.contains("conditions: ["))
  let list : MediaQueryList = { queries: [mq] }
  let s2 = list.to_string()
  assert_true(s2.contains("queries: ["))
}
