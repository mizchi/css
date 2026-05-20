# mizchi/css

Standalone CSS parser, selector matcher, cascade resolver, and computed-style engine for [MoonBit](https://docs.moonbitlang.com).

Originally extracted from [`mizchi/crater`](https://github.com/mizchi/crater) (a CSS layout / browser engine) so the CSS pipeline can be reused by other tools (linters, formatters, static analyzers, alternative layout engines).

## Packages

| Package | Responsibility |
|---|---|
| `mizchi/css/values` | CSS value primitives (`Color`, `Length`, `Dimension`, `Display`, `Position`, `Overflow`, `BoxSizing`, `FlexDirection`, grid track sizing, etc.) |
| `mizchi/css/style` | Computed `Style` struct (resolved declarations + per-element style) |
| `mizchi/css/token` | CSS tokenizer |
| `mizchi/css/selector` | Selector parser and matcher |
| `mizchi/css/cascade` | Cascade rules, rule indexing, importance, origin handling |
| `mizchi/css/media` | `@media` queries, evaluation |
| `mizchi/css/diagnostics` | Parse / cascade diagnostics |
| `mizchi/css/parser` | Stylesheet parser (declarations, at-rules, selectors) |
| `mizchi/css/computed` | Computed-style resolution (cascade output → `Style`) |
| `mizchi/css` | Facade re-exporting the most-used types |

## Web Platform Tests

`wpt/` ships a runner that converts upstream WPT selector-parsing tests
(`css/selectors/parsing/**`) into MoonBit test cases. After
`node wpt/extract.mjs && node wpt/gen-mbt.mjs`, the suite is exercised
with `moon test --package mizchi/css/wpt` — 215 tests scraped directly
from web-platform-tests/wpt, of which 149 pass today. The remaining 66
cover features the parser doesn't yet support (Shadow DOM pseudos,
namespace selectors, forgiving `:not()`/`:has()` empty-arg validation)
and are tracked in `wpt/known-failures.json`. See `wpt/README.md`.

## License

Apache-2.0.
