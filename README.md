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

## License

Apache-2.0.
