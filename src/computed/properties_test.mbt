///|
test "is_inherited - text and font properties" {
  assert_true(@computed.is_inherited("color"))
  assert_true(@computed.is_inherited("font-size"))
  assert_true(@computed.is_inherited("font-family"))
  assert_true(@computed.is_inherited("line-height"))
  assert_true(@computed.is_inherited("text-align"))
  assert_true(@computed.is_inherited("direction"))
  assert_true(@computed.is_inherited("writing-mode"))
  assert_true(@computed.is_inherited("white-space"))
  assert_true(@computed.is_inherited("visibility"))
  assert_true(@computed.is_inherited("caption-side"))
  assert_true(@computed.is_inherited("border-collapse"))
  assert_true(@computed.is_inherited("border-spacing"))
  assert_true(@computed.is_inherited("pointer-events"))
}

///|
test "is_inherited - layout properties are not inherited" {
  assert_false(@computed.is_inherited("display"))
  assert_false(@computed.is_inherited("width"))
  assert_false(@computed.is_inherited("padding"))
  assert_false(@computed.is_inherited("margin"))
  assert_false(@computed.is_inherited("contain"))
  assert_false(@computed.is_inherited("position"))
  assert_false(@computed.is_inherited("flex-direction"))
}

///|
test "initial_value - common properties" {
  inspect(@computed.initial_value("display"), content="block")
  inspect(@computed.initial_value("position"), content="relative")
  inspect(@computed.initial_value("width"), content="auto")
  inspect(@computed.initial_value("max-width"), content="none")
  inspect(@computed.initial_value("overflow"), content="visible")
  inspect(@computed.initial_value("flex-direction"), content="row")
  inspect(@computed.initial_value("flex-wrap"), content="nowrap")
  inspect(@computed.initial_value("justify-content"), content="flex-start")
  inspect(@computed.initial_value("align-items"), content="stretch")
  inspect(@computed.initial_value("flex-grow"), content="0")
  inspect(@computed.initial_value("flex-shrink"), content="1")
  inspect(@computed.initial_value("gap"), content="0")
  inspect(@computed.initial_value("aspect-ratio"), content="auto")
  inspect(@computed.initial_value("text-align"), content="start")
  inspect(@computed.initial_value("white-space"), content="normal")
  inspect(@computed.initial_value("font-weight"), content="400")
  inspect(@computed.initial_value("contain"), content="none")
}

///|
test "initial_value - unknown property defaults to auto" {
  inspect(@computed.initial_value("some-unknown-property"), content="auto")
}

///|
test "parse_dimension - intrinsic and fit-content" {
  inspect(@computed.parse_dimension("min-content"), content="MinContent")
  inspect(@computed.parse_dimension("max-content"), content="MaxContent")
  inspect(@computed.parse_dimension("fit-content(50px)"), content="FitContent(50)")
  inspect(@computed.parse_dimension("none"), content="Auto")
}

///|
test "parse_dimension - invalid input falls back to Auto" {
  inspect(@computed.parse_dimension("not-a-number"), content="Auto")
  inspect(@computed.parse_dimension("xyzpx"), content="Auto")
  inspect(@computed.parse_dimension("xyz%"), content="Auto")
}

///|
test "extract_border_width - direct length" {
  inspect(@computed.extract_border_width("3px"), content="Length(3)")
  inspect(@computed.extract_border_width("0"), content="Length(0)")
  inspect(@computed.extract_border_width("none"), content="Length(0)")
}

///|
test "extract_border_width - keyword widths" {
  inspect(@computed.extract_border_width("thin"), content="Length(1)")
  inspect(@computed.extract_border_width("medium"), content="Length(3)")
  inspect(@computed.extract_border_width("thick"), content="Length(5)")
}

///|
test "extract_border_width - from shorthand value" {
  inspect(@computed.extract_border_width("1px solid red"), content="Length(1)")
  inspect(@computed.extract_border_width("solid 2px"), content="Length(2)")
  // Style-only shorthand defaults to 1.5
  inspect(@computed.extract_border_width("solid"), content="Length(1.5)")
  inspect(@computed.extract_border_width("dashed"), content="Length(1.5)")
}

///|
test "extract_border_width - hidden style stays 0" {
  inspect(@computed.extract_border_width("hidden"), content="Length(0)")
}

///|
test "parse_position covers all values" {
  inspect(@computed.parse_position("static"), content="Static")
  inspect(@computed.parse_position("absolute"), content="Absolute")
  inspect(@computed.parse_position("fixed"), content="Fixed")
  inspect(@computed.parse_position("relative"), content="Relative")
  inspect(@computed.parse_position("sticky"), content="Relative")
  inspect(@computed.parse_position("STATIC"), content="Static")
  inspect(@computed.parse_position("garbage"), content="Static")
}

///|
test "parse_float covers all values" {
  inspect(@computed.parse_float("left"), content="Left")
  inspect(@computed.parse_float("right"), content="Right")
  inspect(@computed.parse_float("none"), content="None")
  inspect(@computed.parse_float("garbage"), content="None")
}

///|
test "parse_float_with_direction - inline-start respects direction" {
  inspect(
    @computed.parse_float_with_direction("inline-start", @style.Direction::Ltr),
    content="Left",
  )
  inspect(
    @computed.parse_float_with_direction("inline-start", @style.Direction::Rtl),
    content="Right",
  )
  inspect(
    @computed.parse_float_with_direction("inline-end", @style.Direction::Ltr),
    content="Right",
  )
  inspect(
    @computed.parse_float_with_direction("inline-end", @style.Direction::Rtl),
    content="Left",
  )
  inspect(
    @computed.parse_float_with_direction("left", @style.Direction::Rtl),
    content="Left",
  )
}

///|
test "parse_clear covers all values" {
  inspect(@computed.parse_clear("left"), content="Left")
  inspect(@computed.parse_clear("right"), content="Right")
  inspect(@computed.parse_clear("both"), content="Both")
  inspect(@computed.parse_clear("none"), content="None")
  inspect(@computed.parse_clear("garbage"), content="None")
}

///|
test "parse_display - table and ruby types" {
  inspect(@computed.parse_display("table"), content="Table")
  inspect(@computed.parse_display("inline-table"), content="InlineTable")
  inspect(@computed.parse_display("table-row"), content="TableRow")
  inspect(@computed.parse_display("table-cell"), content="TableCell")
  inspect(@computed.parse_display("table-caption"), content="TableCaption")
  inspect(@computed.parse_display("table-row-group"), content="TableRowGroup")
  inspect(@computed.parse_display("table-header-group"), content="TableHeaderGroup")
  inspect(@computed.parse_display("table-footer-group"), content="TableFooterGroup")
  inspect(@computed.parse_display("table-column"), content="TableColumn")
  inspect(@computed.parse_display("table-column-group"), content="TableColumnGroup")
  inspect(@computed.parse_display("ruby"), content="Inline")
  inspect(@computed.parse_display("ruby-text"), content="Inline")
  inspect(@computed.parse_display("contents"), content="Contents")
}

///|
test "parse_flex_direction" {
  inspect(@computed.parse_flex_direction("row"), content="Row")
  inspect(@computed.parse_flex_direction("row-reverse"), content="RowReverse")
  inspect(@computed.parse_flex_direction("column"), content="Column")
  inspect(@computed.parse_flex_direction("column-reverse"), content="ColumnReverse")
  inspect(@computed.parse_flex_direction("ROW"), content="Row")
  inspect(@computed.parse_flex_direction("garbage"), content="Row")
}

///|
test "parse_alignment_with_overflow strips safe/unsafe prefix" {
  let (value, is_unsafe) = @computed.parse_alignment_with_overflow(
    "unsafe center",
  )
  inspect(value, content="Center")
  inspect(is_unsafe, content="true")
  // "safe" rewrites Center/End to Start to keep content visible
  let (value2, is_unsafe2) = @computed.parse_alignment_with_overflow(
    "safe center",
  )
  inspect(value2, content="Start")
  inspect(is_unsafe2, content="false")
  let (value3, is_unsafe3) = @computed.parse_alignment_with_overflow("center")
  inspect(value3, content="Center")
  inspect(is_unsafe3, content="false")
}

///|
test "parse_aspect_ratio" {
  debug_inspect(@computed.parse_aspect_ratio("auto"), content="None")
  debug_inspect(@computed.parse_aspect_ratio("2"), content="Some(2)")
  debug_inspect(@computed.parse_aspect_ratio("16 / 9"), content="Some(1.7777777777777777)")
  debug_inspect(@computed.parse_aspect_ratio("16/9"), content="Some(1.7777777777777777)")
}

///|
test "parse_direction" {
  inspect(@computed.parse_direction("ltr"), content="Ltr")
  inspect(@computed.parse_direction("rtl"), content="Rtl")
  inspect(@computed.parse_direction("invalid"), content="Ltr")
}

///|
test "default_color and default_background_color" {
  let c = @computed.default_color()
  inspect(c.r, content="0")
  inspect(c.g, content="0")
  inspect(c.b, content="0")
  let bg = @computed.default_background_color()
  inspect(bg.a, content="0")
}

///|
test "is_grid_area_name" {
  assert_true(@computed.is_grid_area_name("header"))
  assert_true(@computed.is_grid_area_name("main-content"))
  assert_false(@computed.is_grid_area_name("auto"))
  assert_false(@computed.is_grid_area_name("span 2"))
  assert_false(@computed.is_grid_area_name("1"))
}

///|
test "parse_clip" {
  inspect(@computed.parse_clip("auto"), content="auto")
  let r = @computed.parse_clip("rect(1px, 2px, 3px, 4px)")
  inspect(r, content="rect(1, 2, 3, 4)")
}

///|
test "parse_clip_path - none" {
  let cp = @computed.parse_clip_path("none")
  let is_none = match cp {
    None => true
    _ => false
  }
  assert_true(is_none)
}
