# WPT integration

This directory wires up [Web Platform Tests](https://github.com/web-platform-tests/wpt)
selector-parsing tests so they can run against `mizchi/css`'s parser.

`mizchi/css` is a parser and computed-style library, not a browser, so we
focus on the WPT subsets that don't depend on a DOM or layout engine.
Currently this directory covers:

- `css/selectors/parsing/**` — selector text parsing and canonicalization
- `css/css-syntax/anb-parsing.html` — `<an+b>` micro-syntax inside
  `:nth-child(...)`
- `css/css-syntax/anb-serialization.html` — canonical serialization of
  `<an+b>` values

## How it works

WPT tests are HTML files that drive `testharness.js`. We can't run them
directly from MoonBit, so instead:

1. **`extract.mjs`** scrapes WPT HTML files for the actual input/expected
   pairs (e.g. `test_valid_selector('[att=val]', '[att="val"]')`) and
   writes them to `fixtures/*.json`. **`extract-anb.mjs`** does the same
   for `testANB(input, expected)` cases from the css-syntax suite.
2. **`gen-mbt.mjs`** converts those JSON fixtures into MoonBit test
   sources under `src/wpt/`, where they become regular `moon test` cases.
3. The harness in `src/wpt/harness.mbt` parses both the input and each
   acceptable canonical form with `@selector.parse_selector_text`, then
   compares the resulting ASTs (via `Show` string equality). Two
   selectors that parse to the same AST are treated as equivalent —
   sufficient for spec conformance even before we ship a CSS-canonical
   serializer. An+B cases are roundtripped through `:nth-child(<input>)`
   and the canonical form is extracted from the serialized selector.

## Workflow

```bash
node wpt/extract.mjs                # fetch WPT selector HTML, write fixtures/*.json
node wpt/extract-anb.mjs            # fetch WPT css-syntax An+B HTML
node wpt/gen-mbt.mjs                # regenerate src/wpt/*_test.mbt
moon test --package mizchi/css/wpt  # run the suite
```

`extract.mjs` fetches from `raw.githubusercontent.com` by default — no
submodule needed. Pass `--wpt-dir=/path/to/wpt` to use a local checkout.

## Known failures

Tests covering features mizchi/css doesn't implement yet (Shadow DOM
pseudos like `:host` / `::part` / `::slotted`, namespace selectors
(`*|attr`), `:heading()`, forgiving `:not()` / `:has()` empty-argument
validation, etc.) are listed in `known-failures.json`. The harness marks
those as expected failures so they don't break CI, but flips to a
failure the moment they start passing — that's the cue to remove the
entry.

To refresh the allowlist after a parser improvement:

```bash
echo '{"expected_failures":[]}' > wpt/known-failures.json
node wpt/gen-mbt.mjs
node wpt/build-known-failures.mjs --from-moon  # captures current state
node wpt/gen-mbt.mjs
moon test --package mizchi/css/wpt              # green again
```

## Current status

**302 / 302 passing — 100% across selector-parsing + An+B.**

| Source                     | Tests | Passing |
|----------------------------|------:|--------:|
| `invalid-pseudos.html`     |    12 |   12/12 ✓ |
| `parse-attribute.html`     |    16 |   16/16 ✓ |
| `parse-child.html`         |     2 |    2/2 ✓ |
| `parse-class.html`         |     4 |    4/4 ✓ |
| `parse-descendant.html`    |     3 |    3/3 ✓ |
| `parse-focus-visible.html` |     3 |    3/3 ✓ |
| `parse-has.html`           |    29 |   29/29 ✓ |
| `parse-heading.html`       |    28 |   28/28 ✓ |
| `parse-id.html`            |     3 |    3/3 ✓ |
| `parse-is.html`            |     6 |    6/6 ✓ |
| `parse-not.html`           |    26 |   26/26 ✓ |
| `parse-part.html`          |    28 |   28/28 ✓ |
| `parse-sibling.html`       |     3 |    3/3 ✓ |
| `parse-slotted.html`       |    19 |   19/19 ✓ |
| `parse-state.html`         |    24 |   24/24 ✓ |
| `parse-universal.html`     |     3 |    3/3 ✓ |
| `parse-where.html`         |     6 |    6/6 ✓ |
| `anb-parsing.html`         |    67 |   67/67 ✓ |
| `anb-serialization.html`   |    20 |   20/20 ✓ |
| **total**                  | **302** | **302/302** ✓ |

## Roadmap (phase 3+)

- `css/css-syntax/**` (rest) — tokenization and remaining CSS Syntax 3
  conformance tests
- `css/selectors/` (non-parsing) — selector matching against mock DOM
  trees parsed from each test file's `<style>` and `<body>`
- `css/css-cascade/**` — cascade ordering, importance, layers
