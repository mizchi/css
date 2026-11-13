# CSS pipeline benchmarks

Measured on 2026-11-08 with an Apple M5 (arm64), MoonBit
`v0.10.20+65efd5b93`, and Node.js `v24.21.0` for the JS backend.
The parser-tuning baseline below is `de07aa0`; its after column was measured
before the SIMD stage described later in this document.
Values are the benchmark runner's means over 10 samples for these workloads.

## Parser serialization and nested-rule scans

| Backend | Workload | Before | After | Time reduction |
|---|---|---:|---:|---:|
| Native | Parse small stylesheet | 4.13 µs | 3.60 µs | 12.8% |
| Native | Parse medium stylesheet | 79.65 µs | 72.53 µs | 8.9% |
| Native | Full small pipeline | 7.34 µs | 6.51 µs | 11.3% |
| JS | Parse small stylesheet | 6.14 µs | 5.64 µs | 8.1% |
| JS | Parse medium stylesheet | 127.17 µs | 122.57 µs | 3.6% |
| JS | Full small pipeline | 9.92 µs | 8.73 µs | 12.0% |

The parser reuses strings for single-token declarations, trims boundary
whitespace before serialization, and skips copying text that is already
trimmed. It records the first nested selector while parsing declarations so
flat rules avoid a second scan and an empty nested-rule array allocation.

Reproduce the workloads with `just bench` and `just bench js`. Run each backend
sequentially and keep other builds and benchmarks idle during measurement.
The cases are in `src/top_bench_test.mbt`.


## SIMD scans and attribute searches

The baseline for this stage is a separate copy of the worktree after parser
optimization, immediately before the scanner and matcher changes. Before and
after runs used the same toolchain, ran sequentially on each backend, and used
10 samples per case. These are full tokenizer/parser/matcher calls, including
allocation, rather than isolated SIMD kernels.

| Backend | Workload | Before | After | Speed ratio |
|---|---|---:|---:|---:|
| Native | tokenize long string | 3.09 µs | 814.03 ns | 3.80× |
| Native | parse stylesheet long string | 4.39 µs | 1.80 µs | 2.44× |
| Native | tokenize long comment | 2.12 µs | 301.53 ns | 7.03× |
| Native | tokenize long identifier | 4.19 µs | 1.01 µs | 4.15× |
| Native | tokenize mixed whitespace | 1.87 µs | 551.60 ns | 3.39× |
| Native | attribute long substring | 365.33 ns | 110.90 ns | 3.29× |
| Native | attribute long prefix | 55.98 ns | 20.14 ns | 2.78× |
| Native | attribute long suffix | 57.24 ns | 24.00 ns | 2.39× |
| Native | attribute short prefix | 13.27 ns | 13.86 ns | 0.96× |
| Native | attribute short substring | 17.54 ns | 19.46 ns | 0.90× |
| JS | parse stylesheet long string | 11.40 µs | 6.23 µs | 1.83× |
| JS | tokenize long comment | 5.54 µs | 129.02 ns | 42.94× |
| JS | attribute long substring | 1.60 µs | 41.38 ns | 38.67× |

Long tokenizer inputs contain 4,096 code units. The long substring attribute
has 1,024 padding characters followed by `target`; long prefixes and suffixes
contain 128 characters. The short attribute cases remain in the table: they
cost about 0.6–1.9 ns more on Native in this run.

Native and Wasm use UTF-16 × 8 SIMD scans. Ordinary identifiers first scan
32 code units with the scalar loop to avoid SIMD setup for common CSS keywords.
Short strings and whitespace likewise use scalar prefixes, and all scans finish
with a bounded scalar tail. Bitmasks are extracted only when a block needs
individual lane inspection. JavaScript uses native string search for comments
and attribute substrings; other scans, including Wasm GC scans, remain scalar.

The ordinary Native stylesheet benchmark changed from 73.29 to 70.80 µs for
medium input, and from 7.01 to 6.88 µs for the small full pipeline. Repeated
small JS full-pipeline controls were 9.58 / 9.80 µs before and 9.51 / 10.46 µs
after, so they show no consistent improvement on that workload. Long spans
and attribute searches are the workloads with clear gains.

```sh
just bench native simd_bench_test.mbt
just bench js simd_bench_test.mbt
just bench native token_micro_bench_test.mbt
just bench js token_micro_bench_test.mbt
just test-all
```

Differential scanner tests cover every subrange of mixed ASCII/Unicode inputs,
ASCII classification at vector boundaries, partial blocks, and comment
terminators split across blocks. Tokenizer regressions cover escaped quotes,
hex escapes, raw newlines, unterminated strings/comments, and numeric signs
after comments. All 1,648 tests pass on JS, Native, Wasm and Wasm GC.
