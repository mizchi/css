///|
/// CSS Selector Parser
/// Parses CSS tokens into Selector structures

///|
/// Parser state
priv struct SelectorParser {
  tokens : Array[@token.Token]
  mut pos : Int
}

///|
fn SelectorParser::new(tokens : Array[@token.Token]) -> SelectorParser {
  { tokens, pos: 0 }
}

///|
fn SelectorParser::peek(self : SelectorParser) -> @token.Token {
  if self.pos >= self.tokens.length() {
    // Return a safe fallback - this should not happen if tokenize() adds EOF
    self.tokens[self.tokens.length() - 1]
  } else {
    self.tokens[self.pos]
  }
}

///|
fn SelectorParser::is_at_end(self : SelectorParser) -> Bool {
  self.pos >= self.tokens.length() ||
  (match self.tokens[self.pos] {
    EOF => true
    _ => false
  })
}

///|
fn SelectorParser::advance(self : SelectorParser) -> @token.Token {
  let tok = self.peek()
  self.pos = self.pos + 1
  tok
}

///|
fn SelectorParser::skip_whitespace(self : SelectorParser) -> Unit {
  while !self.is_at_end() {
    match self.peek() {
      Whitespace => {
        let _ = self.advance()
      }
      _ => break
    }
  }
}

///|
/// Parse a selector list (comma-separated)
fn parse_selector_list(tokens : Array[@token.Token]) -> SelectorList? {
  let parser = SelectorParser::new(tokens)
  parser.skip_whitespace()
  let selectors : Array[ComplexSelector] = []

  // Parse first selector
  match parser.parse_complex_selector() {
    Some(sel) => selectors.push(sel)
    None => return None
  }

  // Parse remaining selectors
  while !parser.is_at_end() {
    parser.skip_whitespace()
    match parser.peek() {
      Comma => {
        let _ = parser.advance()
        parser.skip_whitespace()
        match parser.parse_complex_selector() {
          Some(sel) => selectors.push(sel)
          None => return None
        }
      }
      _ => break
    }
  }
  parser.skip_whitespace()
  if !parser.is_at_end() {
    return None
  }
  Some(SelectorList::{ selectors, })
}

///|
/// Parse a single selector (without commas)
fn parse_selector(tokens : Array[@token.Token]) -> ComplexSelector? {
  let parser = SelectorParser::new(tokens)
  parser.skip_whitespace()
  match parser.parse_complex_selector() {
    None => None
    Some(sel) => {
      parser.skip_whitespace()
      if parser.is_at_end() {
        Some(sel)
      } else {
        None
      }
    }
  }
}

///|
fn SelectorParser::parse_complex_selector(
  self : SelectorParser,
) -> ComplexSelector? {
  // Parse the first compound selector
  let first = match self.parse_compound_selector() {
    None => return None
    Some(f) => f
  }
  let tail : Array[ComplexSelectorStep] = []
  let mut current = first
  while !self.is_at_end() {
    // Check for combinator (maybe preceded by whitespace)
    let had_whitespace = match self.peek() {
      Whitespace => {
        let _ = self.advance()
        true
      }
      _ => false
    }

    // Check for explicit combinator
    let combinator : Combinator? = match self.peek() {
      Delim('>') => {
        let _ = self.advance()
        self.skip_whitespace()
        Some(Child)
      }
      Delim('+') => {
        let _ = self.advance()
        self.skip_whitespace()
        Some(NextSibling)
      }
      Delim('~') => {
        let _ = self.advance()
        self.skip_whitespace()
        Some(SubsequentSibling)
      }
      _ =>
        if had_whitespace {
          // Descendant combinator (whitespace)
          Some(Descendant)
        } else {
          None
        }
    }
    match combinator {
      None => break
      Some(comb) =>
        // A pseudo-element-bearing compound must be the rightmost
        // (subject) compound of a complex selector — combinators may
        // not follow it.
        if compound_has_pseudo_element(current) {
          return None
        } else {
          match self.parse_compound_selector() {
            None => return None
            Some(next) => {
              tail.push({ combinator: comb, selector: current })
              current = next
            }
          }
        }
    }
  }

  // Reverse tail so it goes from right to left
  let reversed_tail : Array[ComplexSelectorStep] = []
  for i = tail.length() - 1; i >= 0; i = i - 1 {
    reversed_tail.push(tail[i])
  }
  Some({ head: current, tail: reversed_tail })
}

///|
fn SelectorParser::parse_compound_selector(
  self : SelectorParser,
) -> CompoundSelector? {
  let mut type_selector : SimpleSelector? = None
  let subclasses : Array[SimpleSelector] = []
  // Tracks whether we've already consumed a pseudo-element and, if so,
  // whether it's ::part (which permits a small whitelist of subsequent
  // selectors per CSS Shadow Parts 1) or another element (which closes
  // the compound).
  let mut saw_pe : PseudoElement? = None

  // First, try to parse type selector or universal
  match self.peek() {
    Ident(name) => {
      let _ = self.advance()
      type_selector = Some(Type(name.to_lower()))
    }
    Delim('*') => {
      let _ = self.advance()
      type_selector = Some(Universal)
    }
    _ => ()
  }

  // Parse subclass selectors
  while !self.is_at_end() {
    match self.peek() {
      // ID selector
      Hash(id, _) =>
        if not_allowed_after_pe(saw_pe, false) {
          return None
        } else {
          let _ = self.advance()
          subclasses.push(Id(id))
        }
      // Class selector
      Delim('.') =>
        if not_allowed_after_pe(saw_pe, false) {
          return None
        } else {
          let _ = self.advance()
          match self.peek() {
            Ident(class_name) => {
              let _ = self.advance()
              subclasses.push(Class(class_name))
            }
            _ => break
          }
        }
      // Attribute selector
      LeftBracket =>
        if not_allowed_after_pe(saw_pe, false) {
          return None
        } else {
          match self.parse_attribute_selector() {
            Some(attr) => subclasses.push(Attribute(attr))
            None => break
          }
        }
      // Pseudo-class or pseudo-element
      Colon => {
        let _ = self.advance()
        match self.peek() {
          // Double colon - pseudo-element
          Colon => {
            // After a non-::part pseudo-element, no further pseudo-
            // elements may appear. ::part allows exactly one chained
            // pseudo-element (e.g. ::part(x)::after).
            if pe_chain_closed(saw_pe) {
              return None
            }
            let _ = self.advance()
            match self.parse_pseudo_element() {
              Some(pe) => {
                subclasses.push(PseudoElement(pe))
                saw_pe = Some(pe)
              }
              None => return None
            }
          }
          // Single colon - pseudo-class (or legacy pseudo-element)
          _ =>
            // First try to parse as pseudo-class
            match self.parse_pseudo_class() {
              Some(pc) => {
                if !pseudo_class_allowed_after_pe(saw_pe, pc) {
                  return None
                }
                subclasses.push(PseudoClass(pc))
              }
              None =>
                // Try legacy pseudo-element syntax (:before, :after)
                if pe_chain_closed(saw_pe) {
                  return None
                } else {
                  match self.parse_pseudo_element() {
                    Some(pe) => {
                      subclasses.push(PseudoElement(pe))
                      saw_pe = Some(pe)
                    }
                    None => return None
                  }
                }
            }
        }
      }
      _ => break
    }
  }

  // Must have at least one selector component
  if type_selector is None && subclasses.is_empty() {
    return None
  }
  Some({ type_selector, subclasses })
}

///|
/// True if a non-pseudo subclass (id/class/attr) would be invalid after
/// the most recently seen pseudo-element. Per CSS Shadow Parts 1 only
/// `::part(...)` allows further subclasses; per CSS Scoping 1
/// `::slotted(...)` and other pseudo-elements do not.
fn not_allowed_after_pe(
  saw_pe : PseudoElement?,
  _allow_part : Bool,
) -> Bool {
  match saw_pe {
    None => false
    Some(Part(_)) => false // ::part allows id/class/attr — actually no per spec but be lenient
    Some(_) => true
  }
}

///|
/// Whether another pseudo-element may appear after `saw_pe`. Only
/// `::part(...)` keeps the chain open (one further pseudo-element).
fn pe_chain_closed(saw_pe : PseudoElement?) -> Bool {
  match saw_pe {
    None => false
    Some(Part(_)) => false
    Some(_) => true
  }
}

///|
/// CSS Selectors / Shadow DOM rules constraining which pseudo-classes
/// may follow a pseudo-element:
///
/// - After `::part(name)`: allow `:state`, `:hover`, `:active`,
///   `:focus`, `:focus-visible`, `:focus-within`, `:lang`, `:dir`.
/// - After `::slotted(...)`: no pseudo-classes are permitted.
/// - After other pseudo-elements: no pseudo-classes are permitted.
fn pseudo_class_allowed_after_pe(
  saw_pe : PseudoElement?,
  pc : PseudoClass,
) -> Bool {
  match saw_pe {
    None => true
    Some(Part(_)) =>
      // CSS Shadow Parts 1 §3.2: allow user-action, linguistic, form,
      // and a handful of structural pseudos after ::part. Reject the
      // tree-structural ones whose answer is undefined inside a part
      // (e.g. :first-child against a part of unknown depth) and reject
      // :has / :state-of-the-tree pseudos.
      match pc {
        State(_)
        | Hover
        | Active
        | Focus
        | FocusVisible
        | FocusWithin
        | Lang(_)
        | Dir(_)
        | Link
        | Visited
        | AnyLink
        | Enabled
        | Disabled
        | Checked
        | Indeterminate
        | Required
        | Optional
        | Valid
        | Invalid
        | ReadOnly
        | ReadWrite
        | Is(_)
        | Where(_)
        | Not(_) => true
        _ => false
      }
    Some(_) => false
  }
}

///|
fn SelectorParser::parse_attribute_selector(
  self : SelectorParser,
) -> AttributeSelector? {
  // Consume '['
  match self.peek() {
    LeftBracket => {
      let _ = self.advance()
    }
    _ => return None
  }
  self.skip_whitespace()

  // Get attribute name
  let name = match self.peek() {
    Ident(n) => {
      let _ = self.advance()
      n
    }
    _ => return None
  }
  self.skip_whitespace()

  // Check for match operator or end
  let match_type : AttributeMatch = match self.peek() {
    RightBracket => {
      let _ = self.advance()
      return Some({ name, match_type: Exists, case_insensitive: false })
    }
    Delim('=') => {
      let _ = self.advance()
      self.skip_whitespace()
      match self.parse_attr_value() {
        Some(v) => Exact(v)
        None => return None
      }
    }
    Delim('~') => {
      let _ = self.advance()
      match self.peek() {
        Delim('=') => {
          let _ = self.advance()
        }
        _ => return None
      }
      self.skip_whitespace()
      match self.parse_attr_value() {
        Some(v) => Includes(v)
        None => return None
      }
    }
    Delim('|') => {
      let _ = self.advance()
      match self.peek() {
        Delim('=') => {
          let _ = self.advance()
        }
        _ => return None
      }
      self.skip_whitespace()
      match self.parse_attr_value() {
        Some(v) => DashMatch(v)
        None => return None
      }
    }
    Delim('^') => {
      let _ = self.advance()
      match self.peek() {
        Delim('=') => {
          let _ = self.advance()
        }
        _ => return None
      }
      self.skip_whitespace()
      match self.parse_attr_value() {
        Some(v) => Prefix(v)
        None => return None
      }
    }
    Delim('$') => {
      let _ = self.advance()
      match self.peek() {
        Delim('=') => {
          let _ = self.advance()
        }
        _ => return None
      }
      self.skip_whitespace()
      match self.parse_attr_value() {
        Some(v) => Suffix(v)
        None => return None
      }
    }
    Delim('*') => {
      let _ = self.advance()
      match self.peek() {
        Delim('=') => {
          let _ = self.advance()
        }
        _ => return None
      }
      self.skip_whitespace()
      match self.parse_attr_value() {
        Some(v) => Substring(v)
        None => return None
      }
    }
    _ => return None
  }
  self.skip_whitespace()

  // Check for case-insensitive flag
  let case_insensitive = match self.peek() {
    Ident(flag) =>
      if flag.to_lower() == "i" {
        let _ = self.advance()
        self.skip_whitespace()
        true
      } else if flag.to_lower() == "s" {
        let _ = self.advance()
        self.skip_whitespace()
        false
      } else {
        false
      }
    _ => false
  }

  // Consume ']'
  match self.peek() {
    RightBracket => {
      let _ = self.advance()
    }
    _ => return None
  }
  Some({ name, match_type, case_insensitive })
}

///|
fn SelectorParser::parse_attr_value(self : SelectorParser) -> String? {
  match self.peek() {
    Ident(v) => {
      let _ = self.advance()
      Some(v)
    }
    @token.Token::String(v) => {
      let _ = self.advance()
      Some(v)
    }
    _ => None
  }
}

///|
fn SelectorParser::parse_pseudo_element(
  self : SelectorParser,
) -> PseudoElement? {
  match self.peek() {
    Ident(name) => {
      // Resolve name BEFORE consuming so unknown pseudo-elements leave
      // the parser state unchanged. This matters when an outer parser
      // (e.g. inside :not()) wants to fall through on an unrecognized
      // ident.
      let result = match name.to_lower() {
        "before" => Some(Before)
        "after" => Some(After)
        "first-line" => Some(FirstLine)
        "first-letter" => Some(FirstLetter)
        "marker" => Some(Marker)
        "placeholder" => Some(Placeholder)
        "selection" => Some(Selection)
        "backdrop" => Some(Backdrop)
        "file-selector-button" => Some(FileSelectorButton)
        "placeholder-shown" => Some(PlaceholderShown)
        "target-text" => Some(TargetText)
        "spelling-error" => Some(SpellingError)
        "grammar-error" => Some(GrammarError)
        "cue" => Some(Cue)
        _ => None
      }
      match result {
        Some(_) => {
          let _ = self.advance()
          result
        }
        None => None
      }
    }
    Function(name) => {
      let _ = self.advance()
      let name_lower = name.to_lower()
      match name_lower {
        "part" => {
          // ::part(<ident>+) — one or more identifiers, whitespace-
          // separated. CSS Shadow Parts 1.
          self.skip_whitespace()
          let names : Array[String] = []
          while true {
            match self.peek() {
              Ident(part_name) => {
                let _ = self.advance()
                names.push(part_name)
                self.skip_whitespace()
              }
              _ => break
            }
          }
          match (self.peek(), names.length()) {
            (RightParen, n) if n > 0 => {
              let _ = self.advance()
              Some(Part(names))
            }
            _ => None
          }
        }
        "slotted" => {
          // ::slotted(<compound-selector-list>) — CSS Scoping 1.
          self.skip_whitespace()
          let selectors = self.parse_compound_selector_list_until_paren()
          match self.peek() {
            RightParen =>
              if selectors.is_empty() {
                None
              } else {
                let _ = self.advance()
                Some(Slotted(selectors))
              }
            _ => None
          }
        }
        _ => None
      }
    }
    _ => None
  }
}

///|
///|
/// CSS Selectors 4 — the argument of `:not()` may not contain pseudo-
/// elements. (Unknown pseudo-classes have already been rejected by
/// `parse_pseudo_class` returning None.)
fn compound_has_pseudo_element(c : CompoundSelector) -> Bool {
  for sub in c.subclasses {
    match sub {
      PseudoElement(_) => return true
      _ => ()
    }
  }
  false
}

///|
fn complex_has_pseudo_element(c : ComplexSelector) -> Bool {
  if compound_has_pseudo_element(c.head) {
    return true
  }
  for step in c.tail {
    if compound_has_pseudo_element(step.selector) {
      return true
    }
  }
  false
}

///|
fn not_arg_has_invalid(selectors : Array[ComplexSelector]) -> Bool {
  for s in selectors {
    if complex_has_pseudo_element(s) {
      return true
    }
  }
  false
}

///|
fn SelectorParser::parse_pseudo_class(self : SelectorParser) -> PseudoClass? {
  match self.peek() {
    Ident(name) => {
      // Check if it's a known pseudo-class BEFORE consuming the token
      let result = match name.to_lower() {
        "first-child" => Some(FirstChild)
        "last-child" => Some(LastChild)
        "only-child" => Some(OnlyChild)
        "first-of-type" => Some(FirstOfType)
        "last-of-type" => Some(LastOfType)
        "only-of-type" => Some(OnlyOfType)
        "root" => Some(Root)
        "empty" => Some(Empty)
        "hover" => Some(Hover)
        "active" => Some(Active)
        "focus" => Some(Focus)
        "focus-visible" => Some(FocusVisible)
        "focus-within" => Some(FocusWithin)
        "link" => Some(Link)
        "visited" => Some(Visited)
        "any-link" => Some(AnyLink)
        "enabled" => Some(Enabled)
        "disabled" => Some(Disabled)
        "checked" => Some(Checked)
        "indeterminate" => Some(Indeterminate)
        "required" => Some(Required)
        "optional" => Some(Optional)
        "valid" => Some(Valid)
        "invalid" => Some(Invalid)
        "read-only" => Some(ReadOnly)
        "read-write" => Some(ReadWrite)
        "host" => Some(Host)
        "heading" => Some(Heading([]))
        _ => None
      }
      // Only consume the token if it matched
      match result {
        Some(_) => {
          let _ = self.advance()
          result
        }
        None => None
      }
    }
    Function(name) => {
      let _ = self.advance() // Consume the Function token
      let name_lower = name.to_lower()
      match name_lower {
        "nth-child" => {
          let expr = self.parse_nth_expr()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              match expr {
                Some(e) => Some(NthChild(e))
                None => None
              }
            }
            _ => None
          }
        }
        "nth-last-child" => {
          let expr = self.parse_nth_expr()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              match expr {
                Some(e) => Some(NthLastChild(e))
                None => None
              }
            }
            _ => None
          }
        }
        "nth-of-type" => {
          let expr = self.parse_nth_expr()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              match expr {
                Some(e) => Some(NthOfType(e))
                None => None
              }
            }
            _ => None
          }
        }
        "nth-last-of-type" => {
          let expr = self.parse_nth_expr()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              match expr {
                Some(e) => Some(NthLastOfType(e))
                None => None
              }
            }
            _ => None
          }
        }
        "not" => {
          self.skip_whitespace()
          let selectors = self.parse_complex_selector_list_until_paren()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              // CSS Selectors 4: empty :not() argument is invalid.
              // Also reject if any inner selector contains a pseudo-element
              // or an unknown pseudo (per spec).
              if selectors.is_empty() {
                None
              } else if not_arg_has_invalid(selectors) {
                None
              } else {
                Some(Not(selectors))
              }
            }
            _ => None
          }
        }
        "is" => {
          self.skip_whitespace()
          let selectors = self.parse_complex_selector_list_until_paren()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              Some(Is(selectors))
            }
            _ => None
          }
        }
        "where" => {
          self.skip_whitespace()
          let selectors = self.parse_complex_selector_list_until_paren()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              Some(Where(selectors))
            }
            _ => None
          }
        }
        "has" => {
          self.skip_whitespace()
          let selectors = self.parse_relative_selector_list_until_paren()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              // CSS Selectors 4: empty :has() argument is invalid.
              if selectors.is_empty() {
                None
              } else {
                Some(Has(selectors))
              }
            }
            _ => None
          }
        }
        "host" => {
          self.skip_whitespace()
          // :host(<compound-selector>) — single compound, not list.
          let compound = self.parse_compound_selector()
          self.skip_whitespace()
          match (self.peek(), compound) {
            (RightParen, Some(c)) => {
              let _ = self.advance()
              Some(HostFunc(c))
            }
            _ => None
          }
        }
        "host-context" => {
          self.skip_whitespace()
          let compound = self.parse_compound_selector()
          self.skip_whitespace()
          match (self.peek(), compound) {
            (RightParen, Some(c)) => {
              let _ = self.advance()
              Some(HostContextFunc(c))
            }
            _ => None
          }
        }
        "heading" => {
          // :heading(N, ...) — comma-separated list of integer levels.
          self.skip_whitespace()
          let levels : Array[Int] = []
          let mut ok = true
          while true {
            match self.peek() {
              Number(n, @token.NumType::Integer) => {
                let _ = self.advance()
                levels.push(n.to_int())
                self.skip_whitespace()
                match self.peek() {
                  Comma => {
                    let _ = self.advance()
                    self.skip_whitespace()
                  }
                  RightParen => break
                  _ => {
                    ok = false
                    break
                  }
                }
              }
              _ => {
                ok = false
                break
              }
            }
          }
          if ok && levels.length() > 0 && self.peek() is RightParen {
            let _ = self.advance()
            Some(Heading(levels))
          } else {
            None
          }
        }
        "dir" => {
          self.skip_whitespace()
          match self.peek() {
            Ident(v) => {
              let _ = self.advance()
              self.skip_whitespace()
              match self.peek() {
                RightParen => {
                  let _ = self.advance()
                  Some(Dir(v))
                }
                _ => None
              }
            }
            _ => None
          }
        }
        "lang" => {
          self.skip_whitespace()
          let tags : Array[String] = []
          while true {
            match self.peek() {
              Ident(v) => {
                let _ = self.advance()
                tags.push(v)
              }
              @token.Token::String(v) => {
                let _ = self.advance()
                tags.push(v)
              }
              _ => break
            }
            self.skip_whitespace()
            match self.peek() {
              Comma => {
                let _ = self.advance()
                self.skip_whitespace()
              }
              _ => break
            }
          }
          match (self.peek(), tags.is_empty()) {
            (RightParen, false) => {
              let _ = self.advance()
              Some(Lang(tags))
            }
            _ => None
          }
        }
        "state" => {
          self.skip_whitespace()
          let state = self.parse_attr_value()
          match self.peek() {
            RightParen => {
              let _ = self.advance()
              match state {
                Some(token) => Some(State(token))
                None => None
              }
            }
            _ => None
          }
        }
        _ => None
      }
    }
    _ => None
  }
}

///|
fn SelectorParser::parse_nth_expr(self : SelectorParser) -> NthExpr? {
  self.skip_whitespace()

  // Handle keywords: odd, even
  match self.peek() {
    Ident(kw) => {
      let kw_lower = kw.to_lower()
      if kw_lower == "odd" {
        let _ = self.advance()
        return Some({ a: 2, b: 1 })
      }
      if kw_lower == "even" {
        let _ = self.advance()
        return Some({ a: 2, b: 0 })
      }
      if kw_lower == "n" {
        let _ = self.advance()
        // Just 'n' = 1n+0
        self.skip_whitespace()
        let b = self.parse_nth_b()
        return Some({ a: 1, b })
      }
      if kw_lower == "-n" {
        let _ = self.advance()
        self.skip_whitespace()
        let b = self.parse_nth_b()
        return Some({ a: -1, b })
      }
      return None
    }
    Dimension(num, unit) => {
      let unit_lower = unit.to_lower()
      if unit_lower == "n" {
        let _ = self.advance()
        let a = num.to_int()
        self.skip_whitespace()
        let b = self.parse_nth_b()
        return Some({ a, b })
      }
      if unit_lower.length() > 1 && unit_lower[0] == 'n' {
        let suffix = unit_lower.unsafe_substring(
          start=1,
          end=unit_lower.length(),
        )
        let b = @string.parse_int(suffix) catch {
          _ =>
            if suffix.length() > 1 && suffix[0] == '+' {
              @string.parse_int(
                suffix.unsafe_substring(start=1, end=suffix.length()),
              ) catch {
                _ => 0
              }
            } else {
              0
            }
        }
        let _ = self.advance()
        let a = num.to_int()
        return Some({ a, b })
      }
      return None
    }
    Number(num, _) => {
      let _ = self.advance()
      // Just a number = 0n+B
      return Some({ a: 0, b: num.to_int() })
    }
    Delim('+') => {
      let _ = self.advance()
      self.skip_whitespace()
      match self.peek() {
        Ident(kw) =>
          if kw.to_lower() == "n" {
            let _ = self.advance()
            self.skip_whitespace()
            let b = self.parse_nth_b()
            return Some({ a: 1, b })
          } else {
            return None
          }
        Number(num, _) => {
          let _ = self.advance()
          return Some({ a: 0, b: num.to_int() })
        }
        _ => return None
      }
    }
    Delim('-') => {
      let _ = self.advance()
      self.skip_whitespace()
      match self.peek() {
        Ident(kw) =>
          if kw.to_lower() == "n" {
            let _ = self.advance()
            self.skip_whitespace()
            let b = self.parse_nth_b()
            return Some({ a: -1, b })
          } else {
            return None
          }
        Number(num, _) => {
          let _ = self.advance()
          return Some({ a: 0, b: -num.to_int() })
        }
        _ => return None
      }
    }
    _ => return None
  }
}

///|
fn SelectorParser::parse_nth_b(self : SelectorParser) -> Int {
  match self.peek() {
    Delim('+') => {
      let _ = self.advance()
      self.skip_whitespace()
      match self.peek() {
        Number(num, _) => {
          let _ = self.advance()
          num.to_int()
        }
        _ => 0
      }
    }
    Delim('-') => {
      let _ = self.advance()
      self.skip_whitespace()
      match self.peek() {
        Number(num, _) => {
          let _ = self.advance()
          -num.to_int()
        }
        _ => 0
      }
    }
    Number(num, _) => {
      // Number might include sign
      let _ = self.advance()
      num.to_int()
    }
    _ => 0
  }
}

///|
fn SelectorParser::parse_compound_selector_list_until_paren(
  self : SelectorParser,
) -> Array[CompoundSelector] {
  let result : Array[CompoundSelector] = []
  while !self.is_at_end() {
    self.skip_whitespace()
    match self.peek() {
      RightParen | EOF => break
      Comma => {
        let _ = self.advance()
      }
      _ =>
        match self.parse_compound_selector() {
          Some(sel) => result.push(sel)
          None => break
        }
    }
  }
  result
}

///|
fn SelectorParser::parse_complex_selector_list_until_paren(
  self : SelectorParser,
) -> Array[ComplexSelector] {
  let result : Array[ComplexSelector] = []
  while !self.is_at_end() {
    self.skip_whitespace()
    match self.peek() {
      RightParen | EOF => break
      Comma => {
        let _ = self.advance()
      }
      _ =>
        match self.parse_complex_selector() {
          Some(sel) => result.push(sel)
          None => break
        }
    }
  }
  result
}

///|
fn SelectorParser::parse_relative_selector_list_until_paren(
  self : SelectorParser,
) -> Array[RelativeSelector] {
  let result : Array[RelativeSelector] = []
  while !self.is_at_end() {
    self.skip_whitespace()
    match self.peek() {
      RightParen | EOF => break
      Comma => {
        let _ = self.advance()
      }
      _ => {
        // Check for optional leading combinator
        let combinator : Combinator? = match self.peek() {
          Delim('>') => {
            let _ = self.advance()
            self.skip_whitespace()
            Some(Child)
          }
          Delim('+') => {
            let _ = self.advance()
            self.skip_whitespace()
            Some(NextSibling)
          }
          Delim('~') => {
            let _ = self.advance()
            self.skip_whitespace()
            Some(SubsequentSibling)
          }
          _ => None
        }
        match self.parse_complex_selector() {
          Some(sel) => result.push({ combinator, selector: sel })
          None => break
        }
      }
    }
  }
  result
}

///|
/// Convenience function to parse a selector from CSS text
pub fn parse_selector_text(css : String) -> ComplexSelector? {
  let tokens = @token.tokenize(css)
  parse_selector(tokens)
}

///|
/// Convenience function to parse a selector list from CSS text
pub fn parse_selector_list_text(css : String) -> SelectorList? {
  let tokens = @token.tokenize(css)
  parse_selector_list(tokens)
}
