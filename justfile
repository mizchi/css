default:
    @just --list

# Format source and manifests with the current MoonBit toolchain.
fmt:
    moon fmt

# Reject formatting drift and compiler warnings on every backend.
check:
    moon fmt --check
    moon check --target all --deny-warn

# Run tests on a selected backend.
test target="js":
    moon test --target {{ quote(target) }} --deny-warn

# Verify JavaScript, Native, Wasm and Wasm GC runtimes.
test-all:
    just test js
    just test native
    just test wasm
    just test wasm-gc

# Measure the public CSS pipeline without competing benchmark processes.
bench target="native" file="top_bench_test.mbt":
    moon bench --target {{ quote(target) }} --package mizchi/css --file {{ quote(file) }} --no-parallelize --deny-warn

# Regenerate the committed WPT cases from the local fixtures.
wpt-gen:
    node wpt/gen-mbt.mjs
    moon fmt
