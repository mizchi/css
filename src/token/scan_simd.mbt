///|
/// SIMD is limited to backends with contiguous UTF-16 string storage. The
/// experimental core API is confined to these private scanners. Scalar
/// prefixes protect short CSS tokens; scalar tails avoid out-of-range loads.
#cfg(any(target="native", target="wasm"))
#warnings("-alert_experimental")
#borrow(input)
#inline
fn scan_name(input : String, start : Int32, end : Int32) -> Int32 {
  // Common CSS property names fit here; defer SIMD setup until longer runs.
  let prefix_end = if end - start < 32 { end } else { start + 32 }
  let mut pos = scan_name_scalar(input, start, prefix_end)
  if pos < prefix_end || pos == end {
    return pos
  }
  if end - pos < 8 {
    return scan_name_scalar(input, pos, end)
  }
  let fold = @v128.i16x8_splat(0x20)
  let a = @v128.i16x8_splat('a')
  let alphabet_range = @v128.i16x8_splat(25)
  let zero = @v128.i16x8_splat('0')
  let digit_range = @v128.i16x8_splat(9)
  let underscore = @v128.i16x8_splat('_')
  let dash = @v128.i16x8_splat('-')
  let ascii_limit = @v128.i16x8_splat(127)
  while end - pos >= 8 {
    let block = @v128.v128_load_i16x8(input, pos)
    let letters = @v128.i16x8_le_u(
      @v128.i16x8_sub(@v128.v128_or_(block, fold), a),
      alphabet_range,
    )
    let digits = @v128.i16x8_le_u(@v128.i16x8_sub(block, zero), digit_range)
    let valid = @v128.v128_or_(
      @v128.v128_or_(letters, digits),
      @v128.v128_or_(
        @v128.i16x8_gt_u(block, ascii_limit),
        @v128.v128_or_(
          @v128.i16x8_eq(block, underscore),
          @v128.i16x8_eq(block, dash),
        ),
      ),
    )
    if !@v128.i16x8_all_true(valid) {
      let mask = @v128.i16x8_bitmask(valid)
      return pos + (mask ^ 0xFF).ctz()
    }
    pos += 8
  }
  scan_name_scalar(input, pos, end)
}

///|
#cfg(any(target="native", target="wasm"))
#warnings("-alert_experimental")
#borrow(input)
#inline
fn scan_whitespace(input : String, start : Int32, end : Int32) -> Int32 {
  let prefix_end = if end - start < 4 { end } else { start + 4 }
  let mut pos = scan_whitespace_scalar(input, start, prefix_end)
  if pos < prefix_end || pos == end {
    return pos
  }
  if end - pos < 8 {
    return scan_whitespace_scalar(input, pos, end)
  }
  let space = @v128.i16x8_splat(' ')
  let tab = @v128.i16x8_splat('\t')
  let lf = @v128.i16x8_splat('\n')
  let cr = @v128.i16x8_splat('\r')
  while end - pos >= 8 {
    let block = @v128.v128_load_i16x8(input, pos)
    let valid = @v128.v128_or_(
      @v128.v128_or_(@v128.i16x8_eq(block, space), @v128.i16x8_eq(block, tab)),
      @v128.v128_or_(@v128.i16x8_eq(block, lf), @v128.i16x8_eq(block, cr)),
    )
    if !@v128.i16x8_all_true(valid) {
      let mask = @v128.i16x8_bitmask(valid)
      return pos + (mask ^ 0xFF).ctz()
    }
    pos += 8
  }
  scan_whitespace_scalar(input, pos, end)
}

///|
#cfg(any(target="native", target="wasm"))
#warnings("-alert_experimental")
#borrow(input)
#inline
fn find_string_special(
  input : String,
  start : Int32,
  end : Int32,
  quote : UInt16,
) -> Int32 {
  let prefix_end = if end - start < 8 { end } else { start + 8 }
  let mut pos = find_string_special_scalar(input, start, prefix_end, quote)
  if pos < prefix_end || pos == end {
    return pos
  }
  if end - pos < 8 {
    return find_string_special_scalar(input, pos, end, quote)
  }
  let quote_lanes = @v128.i16x8_splat(quote)
  let slash = @v128.i16x8_splat('\\')
  let lf = @v128.i16x8_splat('\n')
  let cr = @v128.i16x8_splat('\r')
  while end - pos >= 8 {
    let block = @v128.v128_load_i16x8(input, pos)
    let special = @v128.v128_or_(
      @v128.v128_or_(
        @v128.i16x8_eq(block, quote_lanes),
        @v128.i16x8_eq(block, slash),
      ),
      @v128.v128_or_(@v128.i16x8_eq(block, lf), @v128.i16x8_eq(block, cr)),
    )
    if @v128.v128_any_true(special) {
      return pos + @v128.i16x8_bitmask(special).ctz()
    }
    pos += 8
  }
  find_string_special_scalar(input, pos, end, quote)
}

///|
#cfg(any(target="native", target="wasm"))
#warnings("-alert_experimental")
#borrow(input)
#inline
fn find_comment_end(input : String, start : Int32, end : Int32) -> Int32 {
  let star = @v128.i16x8_splat('*')
  let mut pos = start
  while end - pos >= 8 {
    let block = @v128.v128_load_i16x8(input, pos)
    let stars = @v128.i16x8_eq(block, star)
    if @v128.v128_any_true(stars) {
      let mut candidates = @v128.i16x8_bitmask(stars)
      while candidates != 0 {
        let candidate = pos + candidates.ctz()
        if end - candidate >= 2 && input[candidate + 1] == '/' {
          return candidate
        }
        candidates = candidates & (candidates - 1)
      }
    }
    pos += 8
  }
  find_comment_end_scalar(input, pos, end)
}
