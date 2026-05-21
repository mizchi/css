/// Auto-generated from css/css-syntax/anb-parsing.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt anb-parsing.html: odd -> 2n+1" {
  wpt_assert_anb("wpt anb-parsing.html: odd -> 2n+1", "odd", "2n+1", false)
}

///|
test "wpt anb-parsing.html: even -> 2n" {
  wpt_assert_anb("wpt anb-parsing.html: even -> 2n", "even", "2n", false)
}

///|
test "wpt anb-parsing.html: 1 -> 1" {
  wpt_assert_anb("wpt anb-parsing.html: 1 -> 1", "1", "1", false)
}

///|
test "wpt anb-parsing.html: +1 -> 1" {
  wpt_assert_anb("wpt anb-parsing.html: +1 -> 1", "+1", "1", false)
}

///|
test "wpt anb-parsing.html: -1 -> -1" {
  wpt_assert_anb("wpt anb-parsing.html: -1 -> -1", "-1", "-1", false)
}

///|
test "wpt anb-parsing.html: 5n -> 5n" {
  wpt_assert_anb("wpt anb-parsing.html: 5n -> 5n", "5n", "5n", false)
}

///|
test "wpt anb-parsing.html: 5N -> 5n" {
  wpt_assert_anb("wpt anb-parsing.html: 5N -> 5n", "5N", "5n", false)
}

///|
test "wpt anb-parsing.html: +n -> n" {
  wpt_assert_anb("wpt anb-parsing.html: +n -> n", "+n", "n", false)
}

///|
test "wpt anb-parsing.html: n -> n" {
  wpt_assert_anb("wpt anb-parsing.html: n -> n", "n", "n", false)
}

///|
test "wpt anb-parsing.html: N -> n" {
  wpt_assert_anb("wpt anb-parsing.html: N -> n", "N", "n", false)
}

///|
test "wpt anb-parsing.html: + n -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: + n -> parse error", "+ n", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: -n -> -n" {
  wpt_assert_anb("wpt anb-parsing.html: -n -> -n", "-n", "-n", false)
}

///|
test "wpt anb-parsing.html: -N -> -n" {
  wpt_assert_anb("wpt anb-parsing.html: -N -> -n", "-N", "-n", false)
}

///|
test "wpt anb-parsing.html: 5n-5 -> 5n-5" {
  wpt_assert_anb("wpt anb-parsing.html: 5n-5 -> 5n-5", "5n-5", "5n-5", false)
}

///|
test "wpt anb-parsing.html: +n-5 -> n-5" {
  wpt_assert_anb("wpt anb-parsing.html: +n-5 -> n-5", "+n-5", "n-5", false)
}

///|
test "wpt anb-parsing.html: n-5 -> n-5" {
  wpt_assert_anb("wpt anb-parsing.html: n-5 -> n-5", "n-5", "n-5", false)
}

///|
test "wpt anb-parsing.html: + n-5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: + n-5 -> parse error", "+ n-5", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: -n-5 -> -n-5" {
  wpt_assert_anb("wpt anb-parsing.html: -n-5 -> -n-5", "-n-5", "-n-5", false)
}

///|
test "wpt anb-parsing.html: 5n +5 -> 5n+5" {
  wpt_assert_anb("wpt anb-parsing.html: 5n +5 -> 5n+5", "5n +5", "5n+5", false)
}

///|
test "wpt anb-parsing.html: 5n -5 -> 5n-5" {
  wpt_assert_anb("wpt anb-parsing.html: 5n -5 -> 5n-5", "5n -5", "5n-5", false)
}

///|
test "wpt anb-parsing.html: +n +5 -> n+5" {
  wpt_assert_anb("wpt anb-parsing.html: +n +5 -> n+5", "+n +5", "n+5", false)
}

///|
test "wpt anb-parsing.html: n +5 -> n+5" {
  wpt_assert_anb("wpt anb-parsing.html: n +5 -> n+5", "n +5", "n+5", false)
}

///|
test "wpt anb-parsing.html: +n -5 -> n-5" {
  wpt_assert_anb("wpt anb-parsing.html: +n -5 -> n-5", "+n -5", "n-5", false)
}

///|
test "wpt anb-parsing.html: + n +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: + n +5 -> parse error", "+ n +5", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: n 5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: n 5 -> parse error", "n 5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -n +5 -> -n+5" {
  wpt_assert_anb("wpt anb-parsing.html: -n +5 -> -n+5", "-n +5", "-n+5", false)
}

///|
test "wpt anb-parsing.html: -n -5 -> -n-5" {
  wpt_assert_anb("wpt anb-parsing.html: -n -5 -> -n-5", "-n -5", "-n-5", false)
}

///|
test "wpt anb-parsing.html: -n 5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n 5 -> parse error", "-n 5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: 5n- 5 -> 5n-5" {
  wpt_assert_anb("wpt anb-parsing.html: 5n- 5 -> 5n-5", "5n- 5", "5n-5", false)
}

///|
test "wpt anb-parsing.html: 5n- -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n- -5 -> parse error", "5n- -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: 5n- +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n- +5 -> parse error", "5n- +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -5n- 5 -> -5n-5" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -5n- 5 -> -5n-5", "-5n- 5", "-5n-5", false,
  )
}

///|
test "wpt anb-parsing.html: +n- 5 -> n-5" {
  wpt_assert_anb("wpt anb-parsing.html: +n- 5 -> n-5", "+n- 5", "n-5", false)
}

///|
test "wpt anb-parsing.html: n- 5 -> n-5" {
  wpt_assert_anb("wpt anb-parsing.html: n- 5 -> n-5", "n- 5", "n-5", false)
}

///|
test "wpt anb-parsing.html: + n- 5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: + n- 5 -> parse error", "+ n- 5", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: n- +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: n- +5 -> parse error", "n- +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: n- -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: n- -5 -> parse error", "n- -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -n- 5 -> -n-5" {
  wpt_assert_anb("wpt anb-parsing.html: -n- 5 -> -n-5", "-n- 5", "-n-5", false)
}

///|
test "wpt anb-parsing.html: -n- +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n- +5 -> parse error", "-n- +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -n- -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n- -5 -> parse error", "-n- -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: 5n + 5 -> 5n+5" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n + 5 -> 5n+5", "5n + 5", "5n+5", false,
  )
}

///|
test "wpt anb-parsing.html: 5n - 5 -> 5n-5" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n - 5 -> 5n-5", "5n - 5", "5n-5", false,
  )
}

///|
test "wpt anb-parsing.html: 5n + +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n + +5 -> parse error", "5n + +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: 5n + -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n + -5 -> parse error", "5n + -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: 5n - +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n - +5 -> parse error", "5n - +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: 5n - -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 5n - -5 -> parse error", "5n - -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: +n + 5 -> n+5" {
  wpt_assert_anb("wpt anb-parsing.html: +n + 5 -> n+5", "+n + 5", "n+5", false)
}

///|
test "wpt anb-parsing.html: n + 5 -> n+5" {
  wpt_assert_anb("wpt anb-parsing.html: n + 5 -> n+5", "n + 5", "n+5", false)
}

///|
test "wpt anb-parsing.html: + n + 5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: + n + 5 -> parse error", "+ n + 5", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: +n - 5 -> n-5" {
  wpt_assert_anb("wpt anb-parsing.html: +n - 5 -> n-5", "+n - 5", "n-5", false)
}

///|
test "wpt anb-parsing.html: +n + +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: +n + +5 -> parse error", "+n + +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: +n + -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: +n + -5 -> parse error", "+n + -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: +n - +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: +n - +5 -> parse error", "+n - +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: +n - -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: +n - -5 -> parse error", "+n - -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -n + 5 -> -n+5" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n + 5 -> -n+5", "-n + 5", "-n+5", false,
  )
}

///|
test "wpt anb-parsing.html: -n - 5 -> -n-5" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n - 5 -> -n-5", "-n - 5", "-n-5", false,
  )
}

///|
test "wpt anb-parsing.html: -n + +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n + +5 -> parse error", "-n + +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -n + -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n + -5 -> parse error", "-n + -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -n - +5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n - +5 -> parse error", "-n - +5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: -n - -5 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -n - -5 -> parse error", "-n - -5", "parse error", true,
  )
}

///|
test "wpt anb-parsing.html: 1 - n -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 1 - n -> parse error", "1 - n", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: 0 - n -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 0 - n -> parse error", "0 - n", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: -1 + n -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: -1 + n -> parse error", "-1 + n", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: 2 n + 2 -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: 2 n + 2 -> parse error", "2 n + 2", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: - 2n -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: - 2n -> parse error", "- 2n", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: + 2n -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: + 2n -> parse error", "+ 2n", "parse error", false,
  )
}

///|
test "wpt anb-parsing.html: +2 n -> parse error" {
  wpt_assert_anb(
    "wpt anb-parsing.html: +2 n -> parse error", "+2 n", "parse error", false,
  )
}
