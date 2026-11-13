///|
/// Expanded `flex` shorthand. `basis` is the specified flex-basis text.
#derive(Eq, Debug)
pub(all) struct FlexShorthand {
  grow : Double
  shrink : Double
  basis : String
}

///|
pub extend FlexShorthand with Eq::{equal, not_equal}

///|
pub extend FlexShorthand with @debug.Debug::{to_repr}

///|
fn flex_factor(token : String) -> Double? {
  // <number [0,∞]> without a unit
  let mut seen_digit = false
  let mut seen_dot = false
  for c in token {
    if c >= '0' && c <= '9' {
      seen_digit = true
    } else if c == '.' && !seen_dot {
      seen_dot = true
    } else {
      return None
    }
  }
  if !seen_digit {
    return None
  }
  Some(@string.parse_double(token)) catch {
    _ => None
  }
}

///|
fn flex_basis_token(token : String) -> Bool {
  if token == "auto" || token == "content" || token.contains("(") {
    return true
  }
  // <length-percentage [0,∞]>: digits, optional fraction, then a unit or %
  let mut i = 0
  let mut digits = 0
  while i < token.length() {
    let c = token[i]
    if (c >= '0' && c <= '9') || c == '.' {
      digits += 1
      i += 1
    } else {
      break
    }
  }
  if digits == 0 || i == token.length() {
    return false
  }
  let unit = token.unsafe_substring(start=i, end=token.length())
  if unit == "%" {
    return true
  }
  for c in unit {
    if !(c >= 'a' && c <= 'z') {
      return false
    }
  }
  true
}

///|
/// Whitespace-separated tokens at parenthesis depth 0, so `calc(a + b)` stays whole.
fn top_level_tokens(value : String) -> Array[String] {
  let tokens : Array[String] = []
  let current = StringBuilder()
  let mut depth = 0
  for c in value {
    if c == '(' {
      depth += 1
    } else if c == ')' && depth > 0 {
      depth -= 1
    }
    if depth == 0 && (c == ' ' || c == '\t' || c == '\n') {
      if current.to_string() != "" {
        tokens.push(current.to_string())
        current.reset()
      }
    } else {
      current.write_char(c)
    }
  }
  if current.to_string() != "" {
    tokens.push(current.to_string())
  }
  tokens
}

///|
/// css-flexbox-1 §7.2: `none | [ <'flex-grow'> <'flex-shrink'>? || <'flex-basis'> ]`.
/// The factors are contiguous; the basis may come before or after them. A
/// unitless zero is a factor unless two factors already precede it. Omitted
/// grow and shrink are 1; an omitted basis is 0 (serialized as `0%`).
/// Returns None for an invalid value. CSS-wide keywords are not handled here.
pub fn parse_flex_shorthand(value : String) -> FlexShorthand? {
  let v = value.trim().to_lower()
  if v == "none" {
    return Some({ grow: 0.0, shrink: 0.0, basis: "auto", })
  }
  if v == "auto" {
    return Some({ grow: 1.0, shrink: 1.0, basis: "auto", })
  }
  let factors : Array[Double] = []
  let mut basis : String? = None
  let mut group_closed = false
  for token in top_level_tokens(v.to_owned()) {
    let factor = flex_factor(token)
    let zero_basis = token == "0" && factors.length() == 2
    match factor {
      Some(f) if !zero_basis && !(group_closed && factors.length() > 0) => {
        if factors.length() == 2 {
          return None
        }
        factors.push(f)
      }
      _ =>
        if basis is None && (zero_basis || flex_basis_token(token)) {
          basis = Some(token)
          if factors.length() > 0 {
            group_closed = true
          }
        } else {
          return None
        }
    }
  }
  if factors.is_empty() && basis is None {
    return None
  }
  Some({
    grow: if factors.length() > 0 {
      factors[0]
    } else {
      1.0
    },
    shrink: if factors.length() > 1 {
      factors[1]
    } else {
      1.0
    },
    basis: basis.unwrap_or("0%"),
  })
}

///|
/// `flex-flow: <'flex-direction'> || <'flex-wrap'>`. An omitted component is
/// its initial value (row, nowrap). Returns None for an invalid value.
pub fn parse_flex_flow(value : String) -> (FlexDirection, FlexWrap)? {
  let mut direction : FlexDirection? = None
  let mut wrap : FlexWrap? = None
  let tokens = top_level_tokens(value.trim().to_lower().to_owned())
  if tokens.is_empty() {
    return None
  }
  for token in tokens {
    let d : FlexDirection? = match token {
      "row" => Some(Row)
      "row-reverse" => Some(RowReverse)
      "column" => Some(Column)
      "column-reverse" => Some(ColumnReverse)
      _ => None
    }
    let w : FlexWrap? = match token {
      "nowrap" => Some(NoWrap)
      "wrap" => Some(Wrap)
      "wrap-reverse" => Some(WrapReverse)
      _ => None
    }
    match (d, w) {
      (Some(_), _) if direction is None => direction = d
      (_, Some(_)) if wrap is None => wrap = w
      _ => return None
    }
  }
  Some((direction.unwrap_or(Row), wrap.unwrap_or(NoWrap)))
}
