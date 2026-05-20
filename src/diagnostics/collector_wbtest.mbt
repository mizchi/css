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
