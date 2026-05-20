#!/usr/bin/env node
// Extract WPT selector-parsing test cases into JSON fixtures.
//
// Source:
//   web-platform-tests/wpt @ master, files under css/selectors/parsing/
//
// Each WPT test file calls one of these helpers (defined in
// css/selectors/parsing/parsing-utils.js):
//
//   test_valid_selector(input[, expected_or_array])
//   test_invalid_selector(input)
//
// We scrape those calls verbatim with a regex pass and emit a JSON file
// per test source. The MoonBit test runner only needs (input, expected,
// valid_flag) triples.
//
// Usage:
//   node wpt/extract.mjs                  # fetches from GitHub raw
//   node wpt/extract.mjs --wpt-dir=PATH   # uses a local WPT checkout
//
// Output: wpt/fixtures/<basename>.json

import { mkdirSync, writeFileSync, readFileSync, existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const FIXTURES_DIR = join(__dirname, "fixtures");

// Curated list of WPT selector-parsing tests. Keep this in sync with
// css/selectors/parsing/ in web-platform-tests; new files can be added
// here without code changes.
const SOURCES = [
  "css/selectors/parsing/parse-anplusb.html",
  "css/selectors/parsing/parse-attribute.html",
  "css/selectors/parsing/parse-child.html",
  "css/selectors/parsing/parse-class.html",
  "css/selectors/parsing/parse-descendant.html",
  "css/selectors/parsing/parse-focus-visible.html",
  "css/selectors/parsing/parse-has.html",
  "css/selectors/parsing/parse-has-forgiving-selector.html",
  "css/selectors/parsing/parse-heading.html",
  "css/selectors/parsing/parse-id.html",
  "css/selectors/parsing/parse-is-where.html",
  "css/selectors/parsing/parse-is.html",
  "css/selectors/parsing/parse-not.html",
  "css/selectors/parsing/parse-part.html",
  "css/selectors/parsing/parse-sibling.html",
  "css/selectors/parsing/parse-slotted.html",
  "css/selectors/parsing/parse-state.html",
  "css/selectors/parsing/parse-universal.html",
  "css/selectors/parsing/parse-where.html",
  "css/selectors/parsing/invalid-pseudos.html",
];

const RAW_BASE = "https://raw.githubusercontent.com/web-platform-tests/wpt/master/";

const args = Object.fromEntries(
  process.argv.slice(2).flatMap((arg) => {
    const m = arg.match(/^--([^=]+)(?:=(.*))?$/);
    return m ? [[m[1], m[2] ?? true]] : [];
  }),
);

async function fetchSource(relativePath) {
  if (args["wpt-dir"]) {
    const path = join(args["wpt-dir"], relativePath);
    if (!existsSync(path)) {
      throw new Error(`Missing local WPT file: ${path}`);
    }
    return readFileSync(path, "utf8");
  }
  const url = RAW_BASE + relativePath;
  const res = await fetch(url);
  if (!res.ok) {
    throw new Error(`HTTP ${res.status} for ${url}`);
  }
  return res.text();
}

// Parse a JavaScript string literal — single or double quoted, with
// standard escapes. Returns [value, end_index].
function parseStringLiteral(src, start) {
  const quote = src[start];
  if (quote !== '"' && quote !== "'") return null;
  let i = start + 1;
  let out = "";
  while (i < src.length) {
    const c = src[i];
    if (c === "\\") {
      const next = src[i + 1];
      if (next === undefined) return null;
      if (next === "n") out += "\n";
      else if (next === "t") out += "\t";
      else if (next === "r") out += "\r";
      else if (next === "\\") out += "\\";
      else if (next === "'") out += "'";
      else if (next === '"') out += '"';
      else out += next;
      i += 2;
      continue;
    }
    if (c === quote) return [out, i + 1];
    out += c;
    i += 1;
  }
  return null;
}

// Skip whitespace and JS comments.
function skipWs(src, i) {
  while (i < src.length) {
    const c = src[i];
    if (c === " " || c === "\t" || c === "\n" || c === "\r") {
      i += 1;
    } else if (c === "/" && src[i + 1] === "/") {
      while (i < src.length && src[i] !== "\n") i += 1;
    } else if (c === "/" && src[i + 1] === "*") {
      i += 2;
      while (i < src.length - 1 && !(src[i] === "*" && src[i + 1] === "/")) i += 1;
      i += 2;
    } else {
      break;
    }
  }
  return i;
}

// Try to parse a single argument starting at i — either a string literal
// or an array of string literals (for the dual-expected form). Returns
// [value, next_index] or null.
function parseArg(src, i) {
  i = skipWs(src, i);
  if (src[i] === "[") {
    const arr = [];
    i += 1;
    i = skipWs(src, i);
    while (i < src.length && src[i] !== "]") {
      const item = parseStringLiteral(src, i);
      if (!item) return null;
      arr.push(item[0]);
      i = skipWs(src, item[1]);
      if (src[i] === ",") {
        i += 1;
        i = skipWs(src, i);
      }
    }
    if (src[i] !== "]") return null;
    return [arr, i + 1];
  }
  const lit = parseStringLiteral(src, i);
  return lit;
}

// Find each invocation of test_valid_selector / test_invalid_selector and
// extract its arguments. We use a token-by-token scan so we tolerate
// nested string contents and trailing comments.
function extract(src, sourceLabel) {
  const tests = [];
  const reCall = /\btest_(valid|invalid)_selector\s*\(/g;
  let match;
  while ((match = reCall.exec(src)) !== null) {
    const kind = match[1];
    let i = match.index + match[0].length;
    const first = parseArg(src, i);
    if (!first) continue;
    i = skipWs(src, first[1]);
    let expected = null;
    if (src[i] === ",") {
      i += 1;
      const second = parseArg(src, i);
      if (second) {
        expected = second[0];
        i = skipWs(src, second[1]);
      }
    }
    // Skip remaining args (we don't care about test name overrides etc.)
    if (typeof first[0] !== "string") continue; // unsupported first-arg shape
    // expected may be a string (single canonical form), an array (any of
    // these is acceptable), or null (canonical = input). Normalize to an
    // array of acceptable canonical forms.
    let expectedForms;
    if (expected === null) {
      expectedForms = [first[0]];
    } else if (Array.isArray(expected)) {
      expectedForms = expected;
    } else {
      expectedForms = [expected];
    }
    tests.push({
      kind,
      input: first[0],
      expected: expectedForms,
    });
  }
  return { source: sourceLabel, tests };
}

async function main() {
  mkdirSync(FIXTURES_DIR, { recursive: true });
  const summary = [];
  for (const rel of SOURCES) {
    let html;
    try {
      html = await fetchSource(rel);
    } catch (err) {
      console.error(`skip ${rel}: ${err.message}`);
      continue;
    }
    const { tests } = extract(html, rel);
    const basename = rel.split("/").pop().replace(/\.html$/, "");
    const outPath = join(FIXTURES_DIR, basename + ".json");
    writeFileSync(outPath, JSON.stringify({ source: rel, tests }, null, 2) + "\n");
    console.log(`${rel}: ${tests.length} tests → ${outPath}`);
    summary.push({ source: rel, count: tests.length });
  }
  writeFileSync(
    join(FIXTURES_DIR, "summary.json"),
    JSON.stringify({ summary }, null, 2) + "\n",
  );
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
