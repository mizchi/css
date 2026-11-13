///|
/// Cascade-to-computed semantics found by a differential check against an
/// independent CSS verifier (isle `packages/css-verifier/oracle`).

///|
fn styles_for(css : String, depth : Int32) -> Array[@style.Style] {
  // html > main.a > div.b > div.b ... ; returns computed styles root first.
  let sheet = @parser.parse_stylesheet(css)
  let out : Array[@style.Style] = []
  let mut parent : @selector.Element? = None
  let mut parent_style : @style.Style? = None
  let mut vars : Map[String, String] = Map([])
  for i in 0..<depth {
    let (tag, classes) = if i == 0 {
      ("html", [])
    } else if i == 1 {
      ("main", ["a"])
    } else {
      ("div", ["b"])
    }
    let element : @selector.Element = {
      tag_name: tag,
      id: None,
      classes,
      attributes: [],
      custom_states: [],
      parent,
      prev_sibling: None,
      next_sibling: None,
      children: [],
      sibling_index: 1,
      sibling_count: 1,
    }
    let cascaded = @cascade.cascade_element(element, [sheet], [])
    let ctx = match parent_style {
      Some(p) => @computed.ComputeContext::with_parent_and_vars(p, vars.copy())
      None => @computed.ComputeContext::new()
    }
    let (style, next) = @computed.compute_with_vars(cascaded, ctx)
    out.push(style)
    parent = Some(element)
    parent_style = Some(style)
    vars = next
  }
  out
}

///|
fn leaf(css : String) -> @style.Style {
  styles_for(css, 3)[2]
}

///|
test "a higher-specificity shorthand beats a later longhand" {
  let s = leaf(".b.b { padding: 2px } div { padding-left: 9px }")
  inspect(s.padding.left, content="Length(2)")
}

///|
test "a higher-specificity longhand beats a later shorthand" {
  let s = leaf("div.b { padding-left: 9px } .b { padding: 2px }")
  inspect(s.padding.left, content="Length(9)")
  inspect(s.padding.right, content="Length(2)")
}

///|
test "an important longhand beats a later normal shorthand" {
  let s = leaf(".b { padding-left: 3px !important } .b { padding: 1px }")
  inspect(s.padding.left, content="Length(3)")
  inspect(s.padding.top, content="Length(1)")
}

///|
test "equal-precedence shorthand and longhand still follow source order" {
  let s = leaf(".b { padding-left: 3px } .b { padding: 1px }")
  inspect(s.padding.left, content="Length(1)")
  let t = leaf(".b { padding: 1px } .b { padding-left: 3px }")
  inspect(t.padding.left, content="Length(3)")
}

///|
test "visible and clip compute to auto and hidden when the other axis scrolls" {
  let s = leaf(".b { overflow: visible auto }")
  inspect(s.overflow_x, content="Auto")
  inspect(s.overflow_y, content="Auto")
  let t = leaf(".b { overflow-x: clip; overflow-y: scroll }")
  inspect(t.overflow_x, content="Hidden")
  let u = leaf(".b { overflow: visible clip }")
  inspect(u.overflow_x, content="Visible")
  inspect(u.overflow_y, content="Clip")
}

///|
test "initial and unset use the CSS initial values" {
  let s = leaf(
    ".b { padding-left: 4px; column-gap: 4px; row-gap: 4px; display: grid } .b { padding-left: initial; column-gap: unset; row-gap: initial; display: initial }",
  )
  inspect(s.padding.left, content="Length(0)")
  inspect(s.column_gap_is_normal, content="true")
  inspect(s.row_gap, content="Length(0)")
  inspect(s.display, content="Inline")
}

///|
test "explicit column-gap normal is normal" {
  let s = leaf(".b { column-gap: normal }")
  inspect(s.column_gap_is_normal, content="true")
  inspect(s.column_gap, content="Length(0)")
}

///|
test "inherit takes the parent value of non-inherited properties" {
  let s = styles_for(
    ".a { padding-left: 6px; min-width: 4px; box-sizing: border-box; column-gap: 5px } .b { padding-left: inherit; min-width: inherit; box-sizing: inherit; column-gap: inherit }",
    3,
  )
  inspect(s[2].padding.left, content="Length(6)")
  inspect(s[2].min_width, content="Length(4)")
  inspect(s[2].box_sizing, content="BorderBox")
  inspect(s[2].column_gap, content="Length(5)")
}

///|
test "var fallback inside the gap shorthand" {
  let s = leaf(".b { gap: var(--none, 4px) }")
  inspect(s.column_gap, content="Length(4)")
  inspect(s.row_gap, content="Length(4)")
}

///|
test "custom properties inherit their computed value" {
  // CSS Variables 1 section 3: var() in a custom property is substituted on
  // the element that declares it; children inherit the result.
  let s = styles_for(
    ":root { --g: 1px; --h: var(--g) } .a { --g: 7px } .b { padding-left: var(--h) }",
    3,
  )
  inspect(s[2].padding.left, content="Length(1)")
}

///|
test "an invalid custom property reference is not re-resolved by a child" {
  let s = styles_for(
    ".a { --h: var(--missing) } .b { --missing: 9px; padding-left: var(--h, 2px) }",
    3,
  )
  inspect(s[2].padding.left, content="Length(2)")
}

///|
test "flex shorthand accepts the basis before the flex factors" {
  // css-flexbox-1 §7.2: [ <'flex-grow'> <'flex-shrink'>? ] || <'flex-basis'>
  let s = leaf(".b { flex: 0% 1 }")
  inspect(s.flex_grow, content="1")
  inspect(s.flex_shrink, content="1")
  inspect(s.flex_basis, content="Percent(0)")
  let t = leaf(".b { flex: 30px 2 0 }")
  inspect(t.flex_grow, content="2")
  inspect(t.flex_shrink, content="0")
  inspect(t.flex_basis, content="Length(30)")
}

///|
test "flex shorthand rejects factors split by the basis" {
  let s = leaf(".b { flex: 3 4 5px } .b { flex: 1 0% 1 }")
  inspect(s.flex_grow, content="3")
  inspect(s.flex_basis, content="Length(5)")
}

///|
test "a unitless zero after two factors is the basis" {
  let s = leaf(".b { flex: 2 3 0 }")
  inspect(s.flex_grow, content="2")
  inspect(s.flex_shrink, content="3")
  inspect(s.flex_basis, content="Length(0)")
}

///|
test "flex-basis content is the content size, not auto" {
  inspect(leaf(".b { flex-basis: content }").flex_basis, content="MaxContent")
  inspect(leaf(".b { flex: content 2 }").flex_basis, content="MaxContent")
  inspect(leaf(".b { flex-basis: auto }").flex_basis, content="Auto")
}
