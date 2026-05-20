///|
test "parse type selector" {
  let sel = parse_selector_text("div")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  inspect(s.head.type_selector is Some(_), content="true")
  match s.head.type_selector {
    Some(Type(name)) => inspect(name, content="div")
    _ => fail("expected type selector")
  }
}

///|
test "parse class selector" {
  let sel = parse_selector_text(".foo")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  inspect(s.head.subclasses.length(), content="1")
  match s.head.subclasses[0] {
    Class(name) => inspect(name, content="foo")
    _ => fail("expected class selector")
  }
}

///|
test "parse id selector" {
  let sel = parse_selector_text("#bar")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  inspect(s.head.subclasses.length(), content="1")
  match s.head.subclasses[0] {
    Id(name) => inspect(name, content="bar")
    _ => fail("expected id selector")
  }
}

///|
test "parse universal selector" {
  let sel = parse_selector_text("*")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.type_selector {
    Some(Universal) => ()
    _ => fail("expected universal selector")
  }
}

///|
test "parse compound selector" {
  let sel = parse_selector_text("div.foo#bar")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  // Type selector
  match s.head.type_selector {
    Some(Type(name)) => inspect(name, content="div")
    _ => fail("expected type selector")
  }
  // Subclasses: class and id
  inspect(s.head.subclasses.length(), content="2")
  match s.head.subclasses[0] {
    Class(name) => inspect(name, content="foo")
    _ => fail("expected class selector")
  }
  match s.head.subclasses[1] {
    Id(name) => inspect(name, content="bar")
    _ => fail("expected id selector")
  }
}

///|
test "parse descendant combinator" {
  let sel = parse_selector_text("div p")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  // head should be 'p'
  match s.head.type_selector {
    Some(Type(name)) => inspect(name, content="p")
    _ => fail("expected type selector p")
  }
  // tail should have one step with 'div' and Descendant combinator
  inspect(s.tail.length(), content="1")
  match s.tail[0].combinator {
    Descendant => ()
    _ => fail("expected descendant combinator")
  }
  match s.tail[0].selector.type_selector {
    Some(Type(name)) => inspect(name, content="div")
    _ => fail("expected type selector div")
  }
}

///|
test "parse child combinator" {
  let sel = parse_selector_text("div > p")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.tail[0].combinator {
    Child => ()
    _ => fail("expected child combinator")
  }
}

///|
test "parse adjacent sibling combinator" {
  let sel = parse_selector_text("div + p")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.tail[0].combinator {
    NextSibling => ()
    _ => fail("expected next-sibling combinator")
  }
}

///|
test "parse general sibling combinator" {
  let sel = parse_selector_text("div ~ p")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.tail[0].combinator {
    SubsequentSibling => ()
    _ => fail("expected subsequent-sibling combinator")
  }
}

///|
test "parse attribute exists selector" {
  let sel = parse_selector_text("[disabled]")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    Attribute(attr) => {
      inspect(attr.name, content="disabled")
      match attr.match_type {
        Exists => ()
        _ => fail("expected Exists match type")
      }
    }
    _ => fail("expected attribute selector")
  }
}

///|
test "parse attribute exact match" {
  let sel = parse_selector_text("[type=button]")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    Attribute(attr) => {
      inspect(attr.name, content="type")
      match attr.match_type {
        Exact(v) => inspect(v, content="button")
        _ => fail("expected Exact match type")
      }
    }
    _ => fail("expected attribute selector")
  }
}

///|
test "parse pseudo-class first-child" {
  let sel = parse_selector_text(":first-child")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    PseudoClass(FirstChild) => ()
    _ => fail("expected :first-child pseudo-class")
  }
}

///|
test "parse pseudo-class nth-child" {
  let sel = parse_selector_text(":nth-child(2n+1)")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    PseudoClass(NthChild(expr)) => {
      inspect(expr.a, content="2")
      inspect(expr.b, content="1")
    }
    _ => fail("expected :nth-child pseudo-class")
  }
}

///|
test "parse pseudo-class nth-child odd" {
  let sel = parse_selector_text(":nth-child(odd)")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    PseudoClass(NthChild(expr)) => {
      inspect(expr.a, content="2")
      inspect(expr.b, content="1")
    }
    _ => fail("expected :nth-child pseudo-class")
  }
}

///|
test "parse pseudo-class nth-child compact anb form" {
  let sel = parse_selector_text(":nth-child(2n1)")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    PseudoClass(NthChild(expr)) => {
      inspect(expr.a, content="2")
      inspect(expr.b, content="1")
    }
    _ => fail("expected :nth-child pseudo-class")
  }
}

///|
test "parse pseudo-class state" {
  let sel = parse_selector_text("x-panel:state(open)")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    PseudoClass(State(name)) => inspect(name, content="open")
    _ => fail("expected :state pseudo-class")
  }
}

///|
test "parse pseudo-element before" {
  let sel = parse_selector_text("::before")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  match s.head.subclasses[0] {
    PseudoElement(Before) => ()
    _ => fail("expected ::before pseudo-element")
  }
}

///|
test "parse unknown pseudo-element invalidates selector" {
  let sel = parse_selector_text("div::scroll-marker")
  inspect(sel is None, content="true")
}

///|
test "parse unknown pseudo-class invalidates selector" {
  let sel = parse_selector_text("div:target-current")
  inspect(sel is None, content="true")
}

///|
test "parse unknown pseudo-element in descendant selector invalidates selector" {
  let sel = parse_selector_text("#scroller div::scroll-marker")
  inspect(sel is None, content="true")
}

///|
test "parse unknown functional pseudo-element invalidates selector" {
  let sel = parse_selector_text("div::scroll-button(*)")
  inspect(sel is None, content="true")
}

///|
test "parse selector with trailing garbage invalidates selector" {
  let sel = parse_selector_text("div ???")
  inspect(sel is None, content="true")
}

///|
test "parse selector list" {
  let list = parse_selector_list_text("div, .foo, #bar")
  inspect(list is Some(_), content="true")
  let l = list.unwrap()
  inspect(l.selectors.length(), content="3")
}

///|
test "parse :nth-child keywords odd/even" {
  let odd = parse_selector_text(":nth-child(odd)")
  match odd.unwrap().head.subclasses[0] {
    PseudoClass(NthChild(expr)) => {
      inspect(expr.a, content="2")
      inspect(expr.b, content="1")
    }
    _ => fail("expected :nth-child(odd)")
  }
  let even = parse_selector_text(":nth-child(even)")
  match even.unwrap().head.subclasses[0] {
    PseudoClass(NthChild(expr)) => {
      inspect(expr.a, content="2")
      inspect(expr.b, content="0")
    }
    _ => fail("expected :nth-child(even)")
  }
}

///|
test "parse :nth-of-type with simple b" {
  let sel = parse_selector_text(":nth-of-type(3)")
  match sel.unwrap().head.subclasses[0] {
    PseudoClass(NthOfType(expr)) => {
      inspect(expr.a, content="0")
      inspect(expr.b, content="3")
    }
    _ => fail("expected :nth-of-type")
  }
}

///|
test "parse :nth-last-of-type" {
  let sel = parse_selector_text(":nth-last-of-type(2n)")
  match sel.unwrap().head.subclasses[0] {
    PseudoClass(NthLastOfType(expr)) => {
      inspect(expr.a, content="2")
      inspect(expr.b, content="0")
    }
    _ => fail("expected :nth-last-of-type")
  }
}

///|
test "parse :not with compound selector" {
  let sel = parse_selector_text(".item:not(.hidden)")
  match sel.unwrap().head.subclasses[0] {
    Class(_) => ()
    _ => fail("expected class first")
  }
  match sel.unwrap().head.subclasses[1] {
    PseudoClass(Not(selectors)) =>
      inspect(selectors.length(), content="1")
    _ => fail("expected :not")
  }
}

///|
test "parse :is() and :where() with multiple selectors" {
  let is_sel = parse_selector_text(":is(h1, h2, h3)")
  match is_sel.unwrap().head.subclasses[0] {
    PseudoClass(Is(selectors)) =>
      inspect(selectors.length(), content="3")
    _ => fail("expected :is")
  }
  let where_sel = parse_selector_text(":where(.a, .b)")
  match where_sel.unwrap().head.subclasses[0] {
    PseudoClass(Where(selectors)) =>
      inspect(selectors.length(), content="2")
    _ => fail("expected :where")
  }
}

///|
test "parse :has with multiple relative selectors" {
  let sel = parse_selector_text(":has(.foo, > .bar)")
  match sel.unwrap().head.subclasses[0] {
    PseudoClass(Has(selectors)) =>
      inspect(selectors.length(), content="2")
    _ => fail("expected :has")
  }
}

///|
test "parse all user-action pseudo-classes" {
  match parse_selector_text(":hover").unwrap().head.subclasses[0] {
    PseudoClass(Hover) => ()
    _ => fail("hover")
  }
  match parse_selector_text(":active").unwrap().head.subclasses[0] {
    PseudoClass(Active) => ()
    _ => fail("active")
  }
  match parse_selector_text(":focus").unwrap().head.subclasses[0] {
    PseudoClass(Focus) => ()
    _ => fail("focus")
  }
  match parse_selector_text(":focus-visible").unwrap().head.subclasses[0] {
    PseudoClass(FocusVisible) => ()
    _ => fail("focus-visible")
  }
  match parse_selector_text(":focus-within").unwrap().head.subclasses[0] {
    PseudoClass(FocusWithin) => ()
    _ => fail("focus-within")
  }
}

///|
test "parse all form pseudo-classes" {
  let names = [
    "enabled", "disabled", "checked", "indeterminate", "required", "optional",
    "valid", "invalid", "read-only", "read-write",
  ]
  for n in names {
    let sel = parse_selector_text(":" + n)
    inspect(sel is Some(_), content="true")
  }
}

///|
test "parse pseudo-element variants" {
  let variants = [
    ("::before", "Before"),
    ("::after", "After"),
    ("::first-line", "FirstLine"),
    ("::first-letter", "FirstLetter"),
    ("::marker", "Marker"),
    ("::placeholder", "Placeholder"),
    ("::selection", "Selection"),
  ]
  for v in variants {
    let sel = parse_selector_text(v.0)
    inspect(sel is Some(_), content="true")
  }
}

///|
test "parse attribute selectors - all match types" {
  let exact = parse_selector_text("[type=text]")
  match exact.unwrap().head.subclasses[0] {
    Attribute(_) => ()
    _ => fail("expected attribute")
  }
  let cases = [
    "[a]",
    "[a=b]",
    "[a~=b]",
    "[a|=b]",
    "[a^=b]",
    "[a$=b]",
    "[a*=b]",
    "[a=b i]",
  ]
  for c in cases {
    let sel = parse_selector_text(c)
    inspect(sel is Some(_), content="true")
  }
}

///|
test "parse_selector_list_text rejects bad input" {
  let bad = parse_selector_list_text("@@@")
  inspect(bad is None, content="true")
}

///|
test "parse_selector_text - empty string returns None" {
  let none = parse_selector_text("")
  inspect(none is None, content="true")
}

///|
test "parse complex selector chain" {
  let sel = parse_selector_text("nav > ul li a:hover")
  inspect(sel is Some(_), content="true")
  let s = sel.unwrap()
  // head should be 'a:hover'
  match s.head.type_selector {
    Some(Type(name)) => inspect(name, content="a")
    _ => fail("expected type selector a")
  }
  // Should have :hover pseudo-class
  inspect(s.head.subclasses.length(), content="1")
  match s.head.subclasses[0] {
    PseudoClass(Hover) => ()
    _ => fail("expected :hover pseudo-class")
  }
  // tail should have 3 steps: nav > ul, ul li (implicit descendant)
  inspect(s.tail.length(), content="3")
}
