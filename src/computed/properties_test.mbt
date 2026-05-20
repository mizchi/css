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

///|
test "parse_overflow" {
  inspect(@computed.parse_overflow("visible"), content="Visible")
  inspect(@computed.parse_overflow("hidden"), content="Hidden")
  inspect(@computed.parse_overflow("clip"), content="Clip")
  inspect(@computed.parse_overflow("scroll"), content="Scroll")
  inspect(@computed.parse_overflow("auto"), content="Auto")
  inspect(@computed.parse_overflow("invalid"), content="Visible")
}

///|
test "parse_text_align" {
  inspect(@computed.parse_text_align("start"), content="Start")
  inspect(@computed.parse_text_align("end"), content="End")
  inspect(@computed.parse_text_align("left"), content="Left")
  inspect(@computed.parse_text_align("right"), content="Right")
  inspect(@computed.parse_text_align("center"), content="Center")
  inspect(@computed.parse_text_align("justify"), content="Justify")
  inspect(@computed.parse_text_align("invalid"), content="Start")
}

///|
test "parse_white_space" {
  inspect(@computed.parse_white_space("normal"), content="Normal")
  inspect(@computed.parse_white_space("nowrap"), content="Nowrap")
  inspect(@computed.parse_white_space("pre"), content="Pre")
  inspect(@computed.parse_white_space("pre-wrap"), content="PreWrap")
  inspect(@computed.parse_white_space("pre-line"), content="PreLine")
  inspect(@computed.parse_white_space("invalid"), content="Normal")
}

///|
test "parse_writing_mode" {
  inspect(@computed.parse_writing_mode("horizontal-tb"), content="HorizontalTb")
  inspect(@computed.parse_writing_mode("vertical-rl"), content="VerticalRl")
  inspect(@computed.parse_writing_mode("vertical-lr"), content="VerticalLr")
  inspect(@computed.parse_writing_mode("invalid"), content="HorizontalTb")
}

///|
test "parse_flex_wrap" {
  inspect(@computed.parse_flex_wrap("nowrap"), content="NoWrap")
  inspect(@computed.parse_flex_wrap("wrap"), content="Wrap")
  inspect(@computed.parse_flex_wrap("wrap-reverse"), content="WrapReverse")
  inspect(@computed.parse_flex_wrap("invalid"), content="NoWrap")
}

///|
test "parse_align_self" {
  inspect(@computed.parse_align_self("auto"), content="Auto")
  inspect(@computed.parse_align_self("start"), content="Start")
  inspect(@computed.parse_align_self("flex-start"), content="Start")
  inspect(@computed.parse_align_self("end"), content="End")
  inspect(@computed.parse_align_self("flex-end"), content="End")
  inspect(@computed.parse_align_self("center"), content="Center")
  inspect(@computed.parse_align_self("stretch"), content="Stretch")
  inspect(@computed.parse_align_self("baseline"), content="Baseline")
  inspect(@computed.parse_align_self("invalid"), content="Auto")
}

///|
test "parse_alignment" {
  inspect(@computed.parse_alignment("flex-start"), content="FlexStart")
  inspect(@computed.parse_alignment("flex-end"), content="FlexEnd")
  inspect(@computed.parse_alignment("center"), content="Center")
  inspect(@computed.parse_alignment("space-between"), content="SpaceBetween")
  inspect(@computed.parse_alignment("space-around"), content="SpaceAround")
  inspect(@computed.parse_alignment("space-evenly"), content="SpaceEvenly")
  inspect(@computed.parse_alignment("stretch"), content="Stretch")
  inspect(@computed.parse_alignment("baseline"), content="Baseline")
}

///|
test "parse_clear_with_direction - inline-start/end" {
  inspect(
    @computed.parse_clear_with_direction("inline-start", @style.Direction::Ltr),
    content="Left",
  )
  inspect(
    @computed.parse_clear_with_direction("inline-start", @style.Direction::Rtl),
    content="Right",
  )
  inspect(
    @computed.parse_clear_with_direction("inline-end", @style.Direction::Ltr),
    content="Right",
  )
  inspect(
    @computed.parse_clear_with_direction("inline-end", @style.Direction::Rtl),
    content="Left",
  )
  inspect(
    @computed.parse_clear_with_direction("both", @style.Direction::Ltr),
    content="Both",
  )
}

///|
test "parse_grid_placement - auto, integer, span" {
  inspect(@computed.parse_grid_placement("auto"), content="Auto")
  inspect(@computed.parse_grid_placement("3"), content="Line(3)")
  inspect(@computed.parse_grid_placement("-2"), content="Line(-2)")
  inspect(@computed.parse_grid_placement("span 2"), content="Span(2)")
}

///|
test "parse_grid_line_shorthand" {
  let (s, e) = @computed.parse_grid_line_shorthand("1 / 3")
  inspect(s, content="Line(1)")
  inspect(e, content="Line(3)")
  let (s2, e2) = @computed.parse_grid_line_shorthand("span 2")
  inspect(s2, content="Span(2)")
  inspect(e2, content="Auto")
}

///|
test "parse_grid_area_shorthand" {
  let (s1, s2, s3, s4) = @computed.parse_grid_area_shorthand(
    "1 / 2 / 3 / 4",
  )
  inspect(s1, content="Line(1)")
  inspect(s2, content="Line(2)")
  inspect(s3, content="Line(3)")
  inspect(s4, content="Line(4)")
}

///|
test "parse_grid_template_areas_value" {
  let areas = @computed.parse_grid_template_areas_value(
    "\"header header\" \"sidebar main\"",
  )
  inspect(areas.length(), content="2")
  inspect(areas[0], content="header header")
  inspect(areas[1], content="sidebar main")
}

///|
test "parse_grid_template_tracks" {
  let tracks = @computed.parse_grid_template_tracks("100px 1fr auto")
  inspect(tracks.length(), content="3")
}

///|
test "parse_grid_auto_flow" {
  inspect(@computed.parse_grid_auto_flow("row"), content="Row")
  inspect(@computed.parse_grid_auto_flow("column"), content="Column")
  inspect(@computed.parse_grid_auto_flow("row dense"), content="RowDense")
  inspect(@computed.parse_grid_auto_flow("column dense"), content="ColumnDense")
}

///|
test "parse_place_content" {
  let result = @computed.parse_place_content("center start")
  assert_true(result is Some(_))
  let result2 = @computed.parse_place_content("center")
  assert_true(result2 is Some(_))
}

///|
test "parse_scroll_snap_type and align" {
  let snap = @computed.parse_scroll_snap_type("x mandatory")
  assert_true(snap.is_mandatory())
  assert_true(snap.snaps_x())
  let none_snap = @computed.parse_scroll_snap_type("none")
  assert_false(none_snap.is_mandatory())
  // Result is (inline, block); first token is block axis, second is inline.
  let (sx, sy) = @computed.parse_scroll_snap_align("start end")
  inspect(sx, content="End")
  inspect(sy, content="Start")
  let (single_x, single_y) = @computed.parse_scroll_snap_align("center")
  inspect(single_x, content="Center")
  inspect(single_y, content="Center")
  let (none_x, none_y) = @computed.parse_scroll_snap_align("")
  inspect(none_x, content="None")
  inspect(none_y, content="None")
}

///|
test "parse_number and parse_integer" {
  inspect(@computed.parse_number("3.14"), content="3.14")
  inspect(@computed.parse_number("garbage"), content="0")
  inspect(@computed.parse_integer("42"), content="42")
  inspect(@computed.parse_integer("garbage"), content="0")
}
