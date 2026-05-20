# WPT integration

This directory wires up [Web Platform Tests](https://github.com/web-platform-tests/wpt)
selector-parsing tests so they can run against `mizchi/css`'s parser.

`mizchi/css` is a parser and computed-style library, not a browser, so we
focus on the WPT subsets that don't depend on a DOM or layout engine.
Phase 1 (this directory) covers `css/selectors/parsing/**` — selector text
parsing and canonicalization.

## How it works

WPT tests are HTML files that drive `testharness.js`. We can't run them
directly from MoonBit, so instead:

1. **`extract.mjs`** scrapes WPT HTML files for the actual input/expected
   pairs (e.g. `test_valid_selector('[att=val]', '[att="val"]')`) and
   writes them to `fixtures/*.json`.
2. **`gen-mbt.mjs`** converts those JSON fixtures into MoonBit test
   sources under `src/wpt/`, where they become regular `moon test` cases.
3. The harness in `src/wpt/harness.mbt` parses both the input and each
   acceptable canonical form with `@selector.parse_selector_text`, then
   compares the resulting ASTs (via `Show` string equality). Two
   selectors that parse to the same AST are treated as equivalent —
   sufficient for spec conformance even before we ship a CSS-canonical
   serializer.

## Workflow

```bash
node wpt/extract.mjs                # fetch WPT HTML, write fixtures/*.json
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

| Source                                 | Tests | Passing |
|----------------------------------------|------:|--------:|
| `invalid-pseudos.html`                 |    12 |    12/12 |
| `parse-attribute.html`                 |    16 |    14/16 |
| `parse-child.html`                     |     2 |     2/2 |
| `parse-class.html`                     |     4 |     4/4 |
| `parse-descendant.html`                |     3 |     3/3 |
| `parse-focus-visible.html`             |     3 |     3/3 |
| `parse-has.html`                       |    29 |   26/29 |
| `parse-heading.html`                   |    28 |   18/28 |
| `parse-id.html`                        |     3 |     3/3 |
| `parse-is.html`                        |     6 |     6/6 |
| `parse-not.html`                       |    26 |   13/26 |
| `parse-part.html`                      |    28 |    6/28 |
| `parse-sibling.html`                   |     3 |     3/3 |
| `parse-slotted.html`                   |    19 |   10/19 |
| `parse-state.html`                     |    24 |   17/24 |
| `parse-universal.html`                 |     3 |     3/3 |
| `parse-where.html`                     |     6 |     6/6 |
| **total**                              | **215** | **149/215** (69%) |

The remaining 66 failures are all listed in `known-failures.json`. They
cluster around features mizchi/css hasn't implemented yet — primarily
`::part`, `::slotted`, `:host`, namespace selectors, and forgiving empty
argument validation in `:not()` / `:has()`.

## Roadmap (phase 2+)

- `css/css-syntax/**` — tokenization and CSS Syntax 3 conformance
- `css/selectors/` (non-parsing) — selector matching against mock DOM
  trees parsed from each test file's `<style>` and `<body>`
- `css/css-cascade/**` — cascade ordering, importance, layers
