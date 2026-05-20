///|
test "DiagnosticsCollector - empty summary" {
  let collector = DiagnosticsCollector::new()
  let summary = collector.get_summary()
  inspect(summary.total_properties, content="0")
  inspect(summary.supported, content="0")
  inspect(summary.unknown, content="0")
}

///|
test "DiagnosticsCollector - tally by support level" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("display", "flex", ".card")
  collector.add_property("color", "red", ".card")
  collector.add_property("box-shadow", "0 0 4px red", ".card")
  collector.add_property("contain", "strict", ".card")
  collector.add_property("clip", "rect(0,0,0,0)", ".card")
  collector.add_property("mystery-prop", "1", ".card")
  let summary = collector.get_summary()
  inspect(summary.supported, content="1")
  inspect(summary.partial, content="1")
  inspect(summary.unsupported_visual, content="1")
  inspect(summary.unsupported_layout, content="1")
  inspect(summary.deprecated, content="1")
  inspect(summary.unknown, content="1")
  inspect(summary.total_properties, content="6")
}

///|
test "DiagnosticsCollector - deduplicates by property:value" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("mystery-prop", "1", ".a")
  collector.add_property("mystery-prop", "1", ".b")
  collector.add_property("mystery-prop", "2", ".a")
  let diags = collector.get_diagnostics()
  inspect(diags.length(), content="2")
  // Counts still reflect every encounter
  let summary = collector.get_summary()
  inspect(summary.unknown, content="3")
}

///|
test "DiagnosticsCollector - supported props are not stored" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("display", "flex", ".card")
  collector.add_property("position", "absolute", ".card")
  inspect(collector.get_diagnostics().length(), content="0")
}

///|
test "DiagnosticsCollector - get_by_severity filters" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("contain", "strict", ".a")
  collector.add_property("box-shadow", "none", ".a")
  collector.add_property("mystery-prop", "1", ".a")
  inspect(collector.get_by_severity(Error).length(), content="1")
  inspect(collector.get_by_severity(Warning).length(), content="1")
  inspect(collector.get_by_severity(Info).length(), content="1")
}

///|
test "DiagnosticsCollector - get_layout_affecting includes unknown" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("contain", "strict", ".a")
  collector.add_property("box-shadow", "none", ".a")
  collector.add_property("mystery-prop", "1", ".a")
  let layout = collector.get_layout_affecting()
  inspect(layout.length(), content="2")
}

///|
test "DiagnosticsCollector - format_compact" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("display", "flex", ".a")
  collector.add_property("font-size", "14px", ".a")
  collector.add_property("box-shadow", "none", ".a")
  collector.add_property("contain", "strict", ".a")
  collector.add_property("mystery-prop", "1", ".a")
  let compact = collector.format_compact()
  // 1 supported, 1 partial, 1 visual, 1 layout, 1 unknown
  assert_true(compact.contains("1 ok"))
  assert_true(compact.contains("1 partial"))
  assert_true(compact.contains("1 visual-only"))
  assert_true(compact.contains("1 layout!"))
  assert_true(compact.contains("1 unknown!"))
}

///|
test "DiagnosticsCollector - format_report header and sections" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("display", "flex", ".a")
  collector.add_property("contain", "strict", ".a")
  collector.add_property("mystery-prop", "1", ".a")
  collector.add_property("typo-prop", "0", ".a")
  let report = collector.format_report(10)
  assert_true(report.contains("CSS Support Report"))
  assert_true(report.contains("Total properties: 4"))
  assert_true(report.contains("Layout-affecting issues"))
  assert_true(report.contains("Unknown properties"))
}

///|
test "DiagnosticsCollector - format_report truncates with max_entries" {
  let collector = DiagnosticsCollector::new()
  for i in 0..<10 {
    collector.add_property("unknown-" + i.to_string(), "x", ".a")
  }
  let report = collector.format_report(3)
  assert_true(report.contains("... and 7 more"))
}

///|
test "Diagnostic - Show output" {
  let diag : Diagnostic = {
    property: "contain",
    value: "strict",
    level: UnsupportedLayout,
    severity: Warning,
    selector: ".a",
  }
  inspect(diag, content="[Warning] contain: strict (UnsupportedLayout)")
}

///|
test "DiagnosticSummary - Show output sanity" {
  let collector = DiagnosticsCollector::new()
  collector.add_property("display", "flex", ".a")
  let summary = collector.get_summary()
  let s = summary.to_string()
  assert_true(s.contains("Total: 1"))
  assert_true(s.contains("Supported: 1"))
}

///|
test "support level - layout-affecting unsupported properties" {
  inspect(get_support_level("columns"), content="UnsupportedLayout")
  inspect(get_support_level("contain"), content="UnsupportedLayout")
  inspect(get_support_level("page-break-before"), content="UnsupportedLayout")
  inspect(get_support_level("widows"), content="UnsupportedLayout")
  inspect(get_support_level("shape-outside"), content="UnsupportedLayout")
  inspect(get_support_level("unicode-bidi"), content="UnsupportedLayout")
}

///|
test "support level - visual-only" {
  inspect(get_support_level("background"), content="UnsupportedVisual")
  inspect(get_support_level("box-shadow"), content="UnsupportedVisual")
  inspect(get_support_level("text-shadow"), content="UnsupportedVisual")
  inspect(get_support_level("filter"), content="UnsupportedVisual")
  inspect(get_support_level("cursor"), content="UnsupportedVisual")
  inspect(get_support_level("user-select"), content="UnsupportedVisual")
  inspect(get_support_level("outline"), content="UnsupportedVisual")
}

///|
test "support level - supported foundational properties" {
  inspect(get_support_level("display"), content="Supported")
  inspect(get_support_level("width"), content="Supported")
  inspect(get_support_level("margin"), content="Supported")
  inspect(get_support_level("padding"), content="Supported")
  inspect(get_support_level("flex-direction"), content="Supported")
  inspect(get_support_level("grid-template-rows"), content="Supported")
  inspect(get_support_level("gap"), content="Supported")
  inspect(get_support_level("position"), content="Supported")
  inspect(get_support_level("overflow"), content="Supported")
  inspect(get_support_level("box-sizing"), content="Supported")
  inspect(get_support_level("border-top-left-radius"), content="Supported")
  inspect(get_support_level("aspect-ratio"), content="Supported")
  inspect(get_support_level("letter-spacing"), content="Supported")
}

///|
test "support level - logical properties" {
  inspect(get_support_level("margin-inline-start"), content="Supported")
  inspect(get_support_level("padding-block"), content="Supported")
  inspect(get_support_level("inset-inline-end"), content="Supported")
  inspect(get_support_level("border-inline-start-width"), content="Supported")
  inspect(get_support_level("inline-size"), content="Supported")
}

///|
test "support level - partial coverage" {
  inspect(
    get_support_level("font-size"),
    content="Partial(relative units may not work correctly)",
  )
  inspect(get_support_level("font-weight"), content="Partial(numeric values only)")
  inspect(
    get_support_level("color"),
    content="Partial(named colors, hex, rgb supported)",
  )
  inspect(
    get_support_level("border"),
    content="Partial(shorthand parsing limited)",
  )
  inspect(get_support_level("opacity"), content="Partial(rendered as visible/hidden)")
}

///|
test "support level - deprecated and vendor prefixes" {
  inspect(get_support_level("clip"), content="Deprecated(use clip-path)")
  inspect(get_support_level("zoom"), content="Deprecated(use transform: scale())")
  inspect(get_support_level("-webkit-clip-path"), content="UnsupportedVisual")
  inspect(get_support_level("-moz-appearance"), content="UnsupportedVisual")
  inspect(get_support_level("-ms-grid"), content="UnsupportedVisual")
  inspect(get_support_level("-o-transition"), content="UnsupportedVisual")
  inspect(get_support_level("--my-var"), content="UnsupportedVisual")
  inspect(get_support_level("_compat"), content="UnsupportedVisual")
  inspect(get_support_level("*hack"), content="UnsupportedVisual")
}

///|
test "support level - case insensitive" {
  inspect(get_support_level("DISPLAY"), content="Supported")
  inspect(get_support_level("Flex-Direction"), content="Supported")
}

///|
test "support level - truly unknown" {
  inspect(get_support_level("totally-not-a-property"), content="Unknown")
}

///|
test "support_to_severity covers every level" {
  inspect(support_to_severity(Supported), content="Info")
  inspect(support_to_severity(Partial("x")), content="Info")
  inspect(support_to_severity(UnsupportedVisual), content="Info")
  inspect(support_to_severity(UnsupportedLayout), content="Warning")
  inspect(support_to_severity(Deprecated("x")), content="Warning")
  inspect(support_to_severity(Unknown), content="Error")
}

///|
test "should_warn excludes only Supported" {
  assert_false(should_warn(Supported))
  assert_true(should_warn(Partial("x")))
  assert_true(should_warn(UnsupportedVisual))
  assert_true(should_warn(UnsupportedLayout))
  assert_true(should_warn(Deprecated("x")))
  assert_true(should_warn(Unknown))
}

///|
test "affects_layout flags layout-affecting and unknown" {
  assert_false(affects_layout(Supported))
  assert_false(affects_layout(Partial("x")))
  assert_false(affects_layout(UnsupportedVisual))
  assert_false(affects_layout(Deprecated("x")))
  assert_true(affects_layout(UnsupportedLayout))
  assert_true(affects_layout(Unknown))
}

///|
test "support level - large sweep of visual-only properties" {
  let visual_props = [
    "background-image", "background-position", "background-size",
    "background-repeat", "background-attachment", "background-origin",
    "background-clip", "transition", "transition-property",
    "transition-duration", "transition-timing-function", "transition-delay",
    "animation", "animation-name", "animation-duration",
    "animation-timing-function", "animation-delay",
    "animation-iteration-count", "animation-direction",
    "animation-fill-mode", "animation-play-state", "filter", "backdrop-filter",
    "outline-width", "outline-style", "outline-color", "outline-offset",
    "pointer-events", "user-select", "scroll-behavior", "scroll-snap-type",
    "scroll-margin", "scroll-padding", "overflow-anchor", "will-change",
    "mask", "mask-image", "mix-blend-mode", "isolation", "object-fit",
    "object-position", "appearance", "resize", "caret-color",
    "text-rendering", "font-feature-settings", "font-variant",
    "font-variant-ligatures", "font-kerning", "font-optical-sizing",
    "font-stretch", "font-synthesis", "font-display", "touch-action",
    "overflow-clip-margin", "overscroll-behavior", "text-emphasis",
    "text-orientation", "text-combine-upright", "backface-visibility",
    "fill", "stroke", "stroke-width", "accent-color", "color-scheme",
    "forced-color-adjust", "print-color-adjust", "line-clamp", "marker",
    "marker-start", "marker-end", "text-transform", "text-indent",
    "white-space", "word-break", "word-wrap", "overflow-wrap", "hyphens",
    "list-style", "list-style-type", "list-style-position",
    "list-style-image", "table-layout", "border-spacing", "caption-side",
    "empty-cells", "quotes", "content", "counter-reset", "counter-increment",
    "transform-origin", "transform-style", "perspective",
    "perspective-origin", "text-decoration", "text-decoration-line",
    "text-decoration-color", "text-decoration-style",
    "text-decoration-thickness", "text-shadow", "box-shadow",
  ]
  for p in visual_props {
    let level = get_support_level(p)
    let s = level.to_string()
    assert_true(s == "UnsupportedVisual")
  }
}

///|
test "support level - sweep of supported logical properties" {
  let logical = [
    "margin-inline", "margin-inline-start", "margin-inline-end",
    "margin-block", "margin-block-start", "margin-block-end",
    "padding-inline", "padding-inline-start", "padding-inline-end",
    "padding-block", "padding-block-start", "padding-block-end",
    "inset-inline", "inset-inline-start", "inset-inline-end",
    "inset-block", "inset-block-start", "inset-block-end",
    "border-inline", "border-inline-start", "border-inline-end",
    "border-block", "border-block-start", "border-block-end",
    "border-inline-width", "border-block-width", "inline-size",
    "block-size", "min-inline-size", "min-block-size",
    "max-inline-size", "max-block-size",
  ]
  for p in logical {
    inspect(get_support_level(p), content="Supported")
  }
}

///|
test "support level - sweep of layout-supported flex/grid" {
  let layout = [
    "flex-direction", "flex-wrap", "flex-flow", "justify-content",
    "align-items", "align-content", "flex", "flex-grow", "flex-shrink",
    "flex-basis", "align-self", "order", "grid-template-rows",
    "grid-template-columns", "grid-auto-rows", "grid-auto-columns",
    "grid-auto-flow", "grid-row-start", "grid-row-end",
    "grid-column-start", "grid-column-end", "grid-row", "grid-column",
    "grid-area", "row-gap", "column-gap", "grid-gap",
  ]
  for p in layout {
    inspect(get_support_level(p), content="Supported")
  }
}

///|
test "support level - sweep of more layout-affecting" {
  let layout = [
    "column-count", "column-width", "break-before", "break-after",
    "break-inside", "page-break-before", "page-break-after",
    "page-break-inside", "orphans", "widows", "shape-margin",
    "shape-image-threshold",
  ]
  for p in layout {
    inspect(get_support_level(p), content="UnsupportedLayout")
  }
}

///|
test "support level - partial place properties" {
  inspect(
    get_support_level("place-content"),
    content="Partial(shorthand for align/justify)",
  )
  inspect(
    get_support_level("place-items"),
    content="Partial(shorthand for align/justify)",
  )
  inspect(
    get_support_level("place-self"),
    content="Partial(shorthand for align/justify)",
  )
  inspect(
    get_support_level("grid-template-areas"),
    content="Partial(basic support only)",
  )
  inspect(
    get_support_level("grid-template"),
    content="Partial(shorthand parsing limited)",
  )
  inspect(
    get_support_level("grid"),
    content="Partial(shorthand parsing limited)",
  )
}

///|
test "Show impls for SupportLevel and Severity" {
  inspect(SupportLevel::Supported, content="Supported")
  inspect(SupportLevel::Partial("limited"), content="Partial(limited)")
  inspect(SupportLevel::UnsupportedLayout, content="UnsupportedLayout")
  inspect(SupportLevel::UnsupportedVisual, content="UnsupportedVisual")
  inspect(
    SupportLevel::Deprecated("clip-path"),
    content="Deprecated(use clip-path)",
  )
  inspect(SupportLevel::Unknown, content="Unknown")
  inspect(Severity::Info, content="Info")
  inspect(Severity::Warning, content="Warning")
  inspect(Severity::Error, content="Error")
}
