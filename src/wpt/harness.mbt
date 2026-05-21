///|
/// Helpers used by the auto-generated WPT selector parsing tests.
///
/// WPT's `selectors/parsing/` tests compare CSS selectors via their
/// canonical `selectorText` serialization. `mizchi/css` doesn't ship a
/// canonical CSS serializer yet, so we treat two selectors as
/// equivalent when they parse to the same internal AST — verified by
/// stringifying both with the package's `Show` impls and comparing.
///
/// This is sound for spec conformance: if our parser canonicalizes the
/// AST (it does), then both syntactic forms must reach the same shape.

///|
fn parse_show(input : String) -> String? {
  match @selector.parse_selector_text(input) {
    Some(sel) => Some(sel.to_string())
    None => None
  }
}

///|
/// Try matching `input` against any of `expected_forms`. Returns None on
/// success, Some(msg) on failure.
fn check_valid(input : String, expected_forms : Array[String]) -> String? {
  let got = parse_show(input)
  match got {
    None => Some("input did not parse: " + input)
    Some(g) => {
      for e in expected_forms {
        match parse_show(e) {
          Some(w) => if g == w { return None }
          None => ()
        }
      }
      let mut msg = "selector AST mismatch:\n  input    = " +
        input +
        " → " +
        g
      for e in expected_forms {
        match parse_show(e) {
          Some(w) => msg = msg + "\n  expected = " + e + " → " + w
          None => msg = msg + "\n  expected = " + e + " → (parse error)"
        }
      }
      Some(msg)
    }
  }
}

///|
fn check_invalid(input : String) -> String? {
  match @selector.parse_selector_text(input) {
    None => None
    Some(sel) =>
      Some(
        "selector unexpectedly accepted: " + input + " → " + sel.to_string(),
      )
  }
}

///|
/// Generated WPT test entry point for a "valid selector" case.
///
/// - `name` identifies the test in the known-failures allowlist.
/// - `expected_forms` lists every canonical serialization WPT accepts.
/// - `known_fail` indicates whether this case is expected to fail
///   because mizchi/css doesn't yet support the underlying feature. A
///   known-failure case must *stay* failing — if it starts passing, the
///   test fails so we can move it out of the allowlist.
pub fn wpt_assert_valid(
  name : String,
  input : String,
  expected_forms : Array[String],
  known_fail : Bool,
) -> Unit raise {
  let err = check_valid(input, expected_forms)
  match (known_fail, err) {
    (false, None) => ()
    (false, Some(msg)) => fail(msg)
    (true, Some(_)) => () // expected failure
    (true, None) =>
      fail(
        "test now passes — remove " +
        name +
        " from wpt/known-failures.json",
      )
  }
}

///|
pub fn wpt_assert_invalid(
  name : String,
  input : String,
  known_fail : Bool,
) -> Unit raise {
  let err = check_invalid(input)
  match (known_fail, err) {
    (false, None) => ()
    (false, Some(msg)) => fail(msg)
    (true, Some(_)) => ()
    (true, None) =>
      fail(
        "test now passes — remove " +
        name +
        " from wpt/known-failures.json",
      )
  }
}

///|
/// Roundtrip An+B through `:nth-child(<input>)` and compare the
/// canonical form. WPT's `testANB(input, expected)` calls the same
/// pattern on the CSSOM. `expected == "parse error"` means the
/// parser must reject the input.
pub fn wpt_assert_anb(
  name : String,
  input : String,
  expected : String,
  known_fail : Bool,
) -> Unit raise {
  let err = check_anb(input, expected)
  match (known_fail, err) {
    (false, None) => ()
    (false, Some(msg)) => fail(msg)
    (true, Some(_)) => ()
    (true, None) =>
      fail(
        "test now passes — remove " +
        name +
        " from wpt/known-failures.json",
      )
  }
}

///|
fn check_anb(input : String, expected : String) -> String? {
  let selector_text = ":nth-child(" + input + ")"
  let parsed = @selector.parse_selector_text(selector_text)
  let got : String = match parsed {
    None => "parse error"
    Some(sel) => {
      // Extract the An+B canonical form from `:nth-child(<...>)`.
      let s = sel.to_string()
      if s.has_prefix(":nth-child(") && s.has_suffix(")") {
        s.unsafe_substring(start=11, end=s.length() - 1)
      } else {
        return Some("unexpected selector serialization: " + s)
      }
    }
  }
  if got == expected {
    None
  } else {
    Some(
      "An+B mismatch:\n  input    = " +
      input +
      "\n  expected = " +
      expected +
      "\n  got      = " +
      got,
    )
  }
}

