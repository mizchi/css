///|
test "trimmed token text keeps single-token values and interior whitespace" {
  for
    (input, expected) in [
      ("  flex  ", "flex"),
      ("  12  ", "12"),
      ("  -1.5px  ", "-1.5px"),
      ("  50%  ", "50%"),
      ("  #abc  ", "#abc"),
      ("  ' a '  ", "\" a \""),
      ("  calc(100% - 2px)  ", "calc(100% - 2px)"),
      ("  1px  2px  ", "1px 2px"),
      ("  ", ""),
      ("", ""),
      ("\\ flex\\ ", "flex"),
    ] {
    let tokens = @token.tokenize(input)
    assert_eq(
      tokens_to_trimmed_string(tokens, 0, tokens.length() - 1),
      expected,
    )
  }
}

///|
test "trimmed token text respects a range within a larger stream" {
  let tokens = @token.tokenize("ignored;  red  ;ignored")
  assert_eq(tokens_to_trimmed_string(tokens, 2, 5), "red")
  assert_eq(tokens_to_trimmed_string(tokens, 3, 3), "")
}

///|
test "style rule records the first nested block during declaration parsing" {
  let flat = @token.tokenize(".card { content: '&'; color: red; }")
  let (_, _, _, flat_nested) = parse_style_rule(flat, 0).unwrap()
  assert_eq(flat_nested, None)
  let nested = @token.tokenize(
    ".card { color: red; &:hover { color: blue; } & > span { opacity: 0; } display: flex; }",
  )
  let (selectors, declarations, end, nested_start) = parse_style_rule(nested, 0).unwrap()
  assert_eq(declarations.length(), 2)
  let start = nested_start.unwrap()
  assert_true(nested[start] is @token.Token::Delim('&'))
  assert_eq(
    extract_ampersand_nested_rules(nested, start, end, selectors).length(),
    2,
  )
}
