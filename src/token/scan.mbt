///|
/// All scanners use UTF-16 code-unit offsets in the half-open range
/// [start, end), with 0 <= start <= end <= input.length().
#borrow(input)
#inline
fn scan_name_scalar(input : String, start : Int32, end : Int32) -> Int32 {
  for pos = start; pos < end; pos = pos + 1 {
    if !is_name_char(input[pos].to_int().unsafe_to_char()) {
      return pos
    }
  }
  end
}

///|
#borrow(input)
#inline
fn scan_whitespace_scalar(input : String, start : Int32, end : Int32) -> Int32 {
  for pos = start; pos < end; pos = pos + 1 {
    if !is_whitespace(input[pos].to_int().unsafe_to_char()) {
      return pos
    }
  }
  end
}

///|
#borrow(input)
#inline
fn find_string_special_scalar(
  input : String,
  start : Int32,
  end : Int32,
  quote : UInt16,
) -> Int32 {
  for pos = start; pos < end; pos = pos + 1 {
    let c = input[pos]
    if c == quote || c == '\\' || c == '\n' || c == '\r' {
      return pos
    }
  }
  end
}

///|
#borrow(input)
#inline
fn find_comment_end_scalar(input : String, start : Int32, end : Int32) -> Int32 {
  for pos = start; end - pos >= 2; pos = pos + 1 {
    if input[pos] == '*' && input[pos + 1] == '/' {
      return pos
    }
  }
  end
}

///|
#cfg(not(any(target="native", target="wasm")))
#borrow(input)
#inline
fn scan_name(input : String, start : Int32, end : Int32) -> Int32 {
  scan_name_scalar(input, start, end)
}

///|
#cfg(not(any(target="native", target="wasm")))
#borrow(input)
#inline
fn scan_whitespace(input : String, start : Int32, end : Int32) -> Int32 {
  scan_whitespace_scalar(input, start, end)
}

///|
#cfg(not(any(target="native", target="wasm")))
#borrow(input)
#inline
fn find_string_special(
  input : String,
  start : Int32,
  end : Int32,
  quote : UInt16,
) -> Int32 {
  find_string_special_scalar(input, start, end, quote)
}

///|
#cfg(target="js")
#borrow(input)
#inline
fn find_comment_end(input : String, start : Int32, end : Int32) -> Int32 {
  // Native string search avoids emulated V128 operations on long runs.
  if end - start >= 32 {
    return match input.unsafe_view(start~, end~).find("*/") {
      Some(offset) => start + offset
      None => end
    }
  }
  find_comment_end_scalar(input, start, end)
}

///|
#cfg(not(any(target="native", target="wasm", target="js")))
#borrow(input)
#inline
fn find_comment_end(input : String, start : Int32, end : Int32) -> Int32 {
  find_comment_end_scalar(input, start, end)
}
