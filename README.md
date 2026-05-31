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
| `mizchi/css/animation` | Web Animations timing model and numeric keyframe sampling |
| `mizchi/css` | Facade re-exporting the most-used types |

## Easing Values

`mizchi/css/values` includes easing primitives that are independent from a
specific animation engine:

- `parse_easing("ease-in-out")`, `parse_easing("cubic-bezier(...)")`,
  `parse_easing("steps(...)")`, and CSS Easing Level 2 `linear(...)`.
- `Easing::sample(progress)` returns the eased progress for normalized input.
- `Easing::apply(from, to, progress)` returns an interpolated numeric value.
- `Easing::frame(from, to, progress)` and `Easing::frames(from, to, count)`
  expose intermediate `progress`, `eased_progress`, and `value` triples.

The parser accepts CSS keywords plus common named Penner/easings.net aliases
such as `ease-in-sine`, `easeOutBack`, and `ease_in_out_bounce`. `sample`
clamps input progress to `[0, 1]`; overshooting curves such as back/elastic can
still produce eased progress outside that range.

## Web Animations

`mizchi/css/animation` provides a small, DOM-independent subset of the Web
Animations timing model. It models effect timing fields such as `delay`, `fill`,
`iterations`, `duration`, `direction`, and `easing`, and can sample numeric
keyframe effects:

- `EffectTiming::new(duration).at(local_time)` returns phase, progress, current
  iteration, directed progress, and transformed progress.
- `NumericKeyframeEffect::new(keyframes, timing)` validates explicit offsets
  from `0.0` to `1.0`.
- `NumericKeyframeEffect::sample(local_time)` returns the interpolated numeric
  value or `None` when the effect is outside its active interval without fill.
- `NumericKeyframeEffect::sample_with_underlying(local_time, value)` applies
  numeric `add` / `accumulate` composition against an underlying value.

This is the timing/interpolation foundation only. DOM playback, CSS property
specific interpolation, and timeline scheduling are left to higher layers.

## Web Platform Tests

`wpt/` ships a runner that converts upstream WPT selector-parsing tests
(`css/selectors/parsing/**`) into MoonBit test cases. After
`node wpt/extract.mjs && node wpt/gen-mbt.mjs`, the suite is exercised
with `moon test --package mizchi/css/wpt` — **215 / 215 tests passing
(100%)** against upstream WPT. See `wpt/README.md`.

## License

Apache-2.0.
