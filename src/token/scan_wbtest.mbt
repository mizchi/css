///|
fn reference_name_end(input : String, start : Int32, end : Int32) -> Int32 {
  for pos = start; pos < end; pos = pos + 1 {
    let c = input[pos].to_int()
    if !((c >= 65 && c <= 90) ||
      (c >= 97 && c <= 122) ||
      (c >= 48 && c <= 57) ||
      c == 95 ||
      c == 45 ||
      c > 127) {
      return pos
    }
  }
  end
}

///|
fn reference_whitespace_end(
  input : String,
  start : Int32,
  end : Int32,
) -> Int32 {
  for pos = start; pos < end; pos = pos + 1 {
    let c = input[pos].to_int()
    if c != 32 && c != 9 && c != 10 && c != 13 {
      return pos
    }
  }
  end
}

///|
fn reference_string_special(
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
fn reference_comment_end(input : String, start : Int32, end : Int32) -> Int32 {
  for pos = start; pos + 1 < end; pos = pos + 1 {
    if input[pos] == '*' && input[pos + 1] == '/' {
      return pos
    }
  }
  end
}

///|
test "scanners respect every subrange including vector tails and Unicode" {
  for
    input in [
      "abCD_19-xyz日本語😀\\escaped name \t\n\r",
      " \t\n\r \t\n\r \t\n\r \t\n\r! \u{c}",
      "abcdefghijklmno\"pqrstuvwxyz\\'\n\r",
      "abcdefghijklmno*/pqrstuv**/xyz*",
      String::make(48, 'a') + "Aa_19-日本語😀\\end",
      String::make(48, 'a') + "*/tail**/end*",
      "",
    ] {
    for start in 0..<=input.length() {
      for end in start..<=input.length() {
        assert_eq(
          scan_name(input, start, end),
          reference_name_end(input, start, end),
        )
        assert_eq(
          scan_whitespace(input, start, end),
          reference_whitespace_end(input, start, end),
        )
        for quote in ['\"', '\''] {
          let quote = quote.to_int().to_uint16()
          assert_eq(
            find_string_special(input, start, end, quote),
            reference_string_special(input, start, end, quote),
          )
        }
        assert_eq(
          find_comment_end(input, start, end),
          reference_comment_end(input, start, end),
        )
      }
    }
  }
}

///|
test "name classification covers every ASCII code unit at vector boundaries" {
  for
    length in [0, 7, 8, 15, 16, 23, 24, 31, 32, 39, 40, 47, 48, 63, 64, 95, 96] {
    for code in 0..<128 {
      let input = String::make(length, 'a') +
        code.unsafe_to_char().to_string() +
        "zzzzzzzzzzzzzzzz"
      assert_eq(
        scan_name(input, 0, input.length()),
        reference_name_end(input, 0, input.length()),
      )
    }
  }
}

///|
test "comment terminators straddle vector boundaries and exclude the tail" {
  for length in 0..<40 {
    for suffix in ["*/tail", "**/tail", "* /tail", "*", ""] {
      let input = String::make(length, 'a') + suffix
      assert_eq(
        find_comment_end(input, 0, input.length()),
        reference_comment_end(input, 0, input.length()),
      )
    }
  }
}
