///|
test "tokenize basic selectors" {
  let tokens = tokenize(".foo #bar div")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content=(
      #|[
      #|  "Delim(.)",
      #|  "Ident(foo)",
      #|  "Whitespace",
      #|  "Hash(bar)",
      #|  "Whitespace",
      #|  "Ident(div)",
      #|  "EOF",
      #|]
    ),
  )
}

///|
test "tokenize property declaration" {
  let tokens = tokenize("width: 100px")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content="[\"Ident(width)\", \"Colon\", \"Whitespace\", \"Dimension(100, px)\", \"EOF\"]",
  )
}

///|
test "tokenize numbers" {
  let tokens = tokenize("10 10.5 10% 10px 10em")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content=(
      #|[
      #|  "Number(10, int)",
      #|  "Whitespace",
      #|  "Number(10.5, num)",
      #|  "Whitespace",
      #|  "Percentage(10)",
      #|  "Whitespace",
      #|  "Dimension(10, px)",
      #|  "Whitespace",
      #|  "Dimension(10, em)",
      #|  "EOF",
      #|]
    ),
  )
}

///|
test "tokenize function" {
  let tokens = tokenize("calc(100% - 20px)")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content=(
      #|[
      #|  "Function(calc)",
      #|  "Percentage(100)",
      #|  "Whitespace",
      #|  "Delim(-)",
      #|  "Whitespace",
      #|  "Dimension(20, px)",
      #|  "RightParen",
      #|  "EOF",
      #|]
    ),
  )
}

///|
test "tokenize string" {
  let tokens = tokenize("\"hello world\"")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content="[\"String(hello world)\", \"EOF\"]",
  )
}

///|
test "tokenize at-rule" {
  let tokens = tokenize("@media screen")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content="[\"AtKeyword(media)\", \"Whitespace\", \"Ident(screen)\", \"EOF\"]",
  )
}

///|
test "tokenize braces and brackets" {
  let tokens = tokenize("{ [ ( ) ] }")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content=(
      #|[
      #|  "LeftBrace",
      #|  "Whitespace",
      #|  "LeftBracket",
      #|  "Whitespace",
      #|  "LeftParen",
      #|  "Whitespace",
      #|  "RightParen",
      #|  "Whitespace",
      #|  "RightBracket",
      #|  "Whitespace",
      #|  "RightBrace",
      #|  "EOF",
      #|]
    ),
  )
}

///|
test "tokenize comment" {
  let tokens = tokenize("a /* comment */ b")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content="[\"Ident(a)\", \"Whitespace\", \"Whitespace\", \"Ident(b)\", \"EOF\"]",
  )
}

///|
test "tokenize css rule" {
  let tokens = tokenize(".container { display: flex; }")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content=(
      #|[
      #|  "Delim(.)",
      #|  "Ident(container)",
      #|  "Whitespace",
      #|  "LeftBrace",
      #|  "Whitespace",
      #|  "Ident(display)",
      #|  "Colon",
      #|  "Whitespace",
      #|  "Ident(flex)",
      #|  "Semicolon",
      #|  "Whitespace",
      #|  "RightBrace",
      #|  "EOF",
      #|]
    ),
  )
}

///|
test "tokenize negative number" {
  let tokens = tokenize("-10px")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content="[\"Dimension(-10, px)\", \"EOF\"]",
  )
}

///|
test "tokenize hash unrestricted vs id" {
  let id_tokens = tokenize("#main")
  debug_inspect(
    id_tokens.map(fn(t) { t.to_string() }),
    content="[\"Hash(main)\", \"EOF\"]",
  )
  // numeric hash is still parsed as Hash
  let num_tokens = tokenize("#123")
  inspect(num_tokens[0].to_string(), content="Hash(123)")
}

///|
test "tokenize single-quoted string" {
  let tokens = tokenize("'hello'")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content="[\"String(hello)\", \"EOF\"]",
  )
}

///|
test "tokenize comma" {
  let tokens = tokenize("a,b")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content="[\"Ident(a)\", \"Comma\", \"Ident(b)\", \"EOF\"]",
  )
}

///|
test "tokenize delim characters" {
  let tokens = tokenize("> + ~ |")
  debug_inspect(
    tokens.map(fn(t) { t.to_string() }),
    content=(
      #|[
      #|  "Delim(>)",
      #|  "Whitespace",
      #|  "Delim(+)",
      #|  "Whitespace",
      #|  "Delim(~)",
      #|  "Whitespace",
      #|  "Delim(|)",
      #|  "EOF",
      #|]
    ),
  )
}

///|
test "tokenize positive signed number" {
  let tokens = tokenize("+5em")
  inspect(tokens[0].to_string(), content="Dimension(5, em)")
}

///|
test "tokenize float number" {
  let tokens = tokenize("3.14")
  inspect(tokens[0].to_string(), content="Number(3.14, num)")
}

///|
test "tokenize empty input yields just EOF" {
  let tokens = tokenize("")
  inspect(tokens.length(), content="1")
  inspect(tokens[0].to_string(), content="EOF")
}

///|
test "tokenize identifier with hyphens" {
  let tokens = tokenize("flex-direction")
  inspect(tokens[0].to_string(), content="Ident(flex-direction)")
}

///|
test "tokenize url-like value via function token" {
  let tokens = tokenize("url(image.png)")
  inspect(tokens[0].to_string(), content="Function(url)")
}

///|
test "tokenize CDO and CDC" {
  let tokens = tokenize("<!-- -->")
  // CDO and CDC may or may not be emitted depending on tokenizer; assert no panic.
  assert_true(tokens.length() > 0)
}

///|
test "tokenize colon and semicolon adjacency" {
  let tokens = tokenize("a:b;c")
  inspect(tokens[0].to_string(), content="Ident(a)")
  inspect(tokens[1].to_string(), content="Colon")
  inspect(tokens[2].to_string(), content="Ident(b)")
  inspect(tokens[3].to_string(), content="Semicolon")
  inspect(tokens[4].to_string(), content="Ident(c)")
}

///|
test "tokenize at-keyword variants" {
  let tokens = tokenize("@import @media @keyframes")
  inspect(tokens[0].to_string(), content="AtKeyword(import)")
  inspect(tokens[2].to_string(), content="AtKeyword(media)")
  inspect(tokens[4].to_string(), content="AtKeyword(keyframes)")
}

///|
test "tokenize escaped backslash in identifier" {
  let tokens = tokenize("\\\\foo")
  // Escape consumed and produced something; just confirm we got an ident.
  let first = tokens[0].to_string()
  assert_true(first.has_prefix("Ident("))
}
