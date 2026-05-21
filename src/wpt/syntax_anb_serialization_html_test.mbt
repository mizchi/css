/// Auto-generated from css/css-syntax/anb-serialization.html.
/// DO NOT EDIT — regenerate with `node wpt/gen-mbt.mjs`.

///|
test "wpt anb-serialization.html: 1 -> 1" {
  wpt_assert_anb("wpt anb-serialization.html: 1 -> 1", "1", "1", false)
}

///|
test "wpt anb-serialization.html: +1 -> 1" {
  wpt_assert_anb("wpt anb-serialization.html: +1 -> 1", "+1", "1", false)
}

///|
test "wpt anb-serialization.html: -1 -> -1" {
  wpt_assert_anb("wpt anb-serialization.html: -1 -> -1", "-1", "-1", false)
}

///|
test "wpt anb-serialization.html: 0n + 0 -> 0" {
  wpt_assert_anb(
    "wpt anb-serialization.html: 0n + 0 -> 0", "0n + 0", "0", false,
  )
}

///|
test "wpt anb-serialization.html: 0n + 1 -> 1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: 0n + 1 -> 1", "0n + 1", "1", false,
  )
}

///|
test "wpt anb-serialization.html: 0n - 1 -> -1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: 0n - 1 -> -1", "0n - 1", "-1", false,
  )
}

///|
test "wpt anb-serialization.html: 1n -> n" {
  wpt_assert_anb("wpt anb-serialization.html: 1n -> n", "1n", "n", false)
}

///|
test "wpt anb-serialization.html: 1n - 0 -> n" {
  wpt_assert_anb(
    "wpt anb-serialization.html: 1n - 0 -> n", "1n - 0", "n", false,
  )
}

///|
test "wpt anb-serialization.html: 1n + 1 -> n+1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: 1n + 1 -> n+1", "1n + 1", "n+1", false,
  )
}

///|
test "wpt anb-serialization.html: 1n - 1 -> n-1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: 1n - 1 -> n-1", "1n - 1", "n-1", false,
  )
}

///|
test "wpt anb-serialization.html: -1n -> -n" {
  wpt_assert_anb("wpt anb-serialization.html: -1n -> -n", "-1n", "-n", false)
}

///|
test "wpt anb-serialization.html: -1n - 0 -> -n" {
  wpt_assert_anb(
    "wpt anb-serialization.html: -1n - 0 -> -n", "-1n - 0", "-n", false,
  )
}

///|
test "wpt anb-serialization.html: -1n + 1 -> -n+1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: -1n + 1 -> -n+1", "-1n + 1", "-n+1", false,
  )
}

///|
test "wpt anb-serialization.html: -1n - 1 -> -n-1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: -1n - 1 -> -n-1", "-1n - 1", "-n-1", false,
  )
}

///|
test "wpt anb-serialization.html: +n+1 -> n+1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: +n+1 -> n+1", "+n+1", "n+1", false,
  )
}

///|
test "wpt anb-serialization.html: -n-1 -> -n-1" {
  wpt_assert_anb(
    "wpt anb-serialization.html: -n-1 -> -n-1", "-n-1", "-n-1", false,
  )
}

///|
test "wpt anb-serialization.html: n + 0 -> n" {
  wpt_assert_anb("wpt anb-serialization.html: n + 0 -> n", "n + 0", "n", false)
}

///|
test "wpt anb-serialization.html: n - 0 -> n" {
  wpt_assert_anb("wpt anb-serialization.html: n - 0 -> n", "n - 0", "n", false)
}

///|
test "wpt anb-serialization.html: 2n + 2 -> 2n+2" {
  wpt_assert_anb(
    "wpt anb-serialization.html: 2n + 2 -> 2n+2", "2n + 2", "2n+2", false,
  )
}

///|
test "wpt anb-serialization.html: -2n - 2 -> -2n-2" {
  wpt_assert_anb(
    "wpt anb-serialization.html: -2n - 2 -> -2n-2", "-2n - 2", "-2n-2", false,
  )
}
