#!/usr/bin/env node
// Convert wpt/fixtures/*.json into MoonBit test sources under src/wpt/.
//
// Each fixture becomes one MoonBit test case. The test parses both the
// input and the expected canonical form with `@selector.parse_selector_text`
// and verifies that they produce equivalent ASTs.

import { mkdirSync, readFileSync, readdirSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const FIXTURES_DIR = join(__dirname, "fixtures");
const OUT_DIR = join(__dirname, "..", "src", "wpt");
const KNOWN_FAILURES_FILE = join(__dirname, "known-failures.json");

const SEP = "";

// known-failures.json is a list of {source, input} (and optional kind)
// objects. The source string is the WPT test file basename
// (e.g. "parse-attribute.html"). The input is matched verbatim against
// the JS-side string passed to test_valid_selector / test_invalid_selector.
const KNOWN_FAILURES = (() => {
  try {
    const obj = JSON.parse(readFileSync(KNOWN_FAILURES_FILE, "utf8"));
    const set = new Set();
    for (const entry of obj.expected_failures ?? []) {
      set.add(entry.source + SEP + entry.input);
    }
    return set;
  } catch {
    return new Set();
  }
})();

const args = Object.fromEntries(
  process.argv.slice(2).flatMap((arg) => {
    const m = arg.match(/^--([^=]+)(?:=(.*))?$/);
    return m ? [[m[1], m[2] ?? true]] : [];
  }),
);

function mbtString(s) {
  // Escape a MoonBit string literal. MoonBit accepts the same backslash
  // escapes as Rust/JSON for the basics.
  let out = '"';
  for (const ch of s) {
    const code = ch.codePointAt(0);
    if (ch === "\\") out += "\\\\";
    else if (ch === '"') out += '\\"';
    else if (ch === "\n") out += "\\n";
    else if (ch === "\r") out += "\\r";
    else if (ch === "\t") out += "\\t";
    else if (code < 0x20 || code === 0x7f) {
      out += "\\u{" + code.toString(16) + "}";
    } else {
      out += ch;
    }
  }
  out += '"';
  return out;
}

function sanitizeIdent(s) {
  return s
    .replace(/[^a-zA-Z0-9]+/g, "_")
    .replace(/^_+|_+$/g, "")
    .toLowerCase();
}

function genTest(fixture) {
  const lines = [];
  const sourceBasename = fixture.source.split("/").pop();
  const safe = sanitizeIdent(
    fixture.source.replace(/^css\/selectors\/parsing\//, ""),
  );
  lines.push(
    `/// Auto-generated from ${fixture.source}.`,
    `/// DO NOT EDIT — regenerate with \`node wpt/gen-mbt.mjs\`.`,
    ``,
  );
  for (const t of fixture.tests) {
    const name = `wpt ${sourceBasename}: ${t.kind} ${t.input}`;
    const escName = name.replace(/[^\x20-\x7e]/g, "?");
    const knownFail = KNOWN_FAILURES.has(sourceBasename + SEP + t.input);
    if (t.kind === "valid") {
      const expected = Array.isArray(t.expected) ? t.expected : [t.expected];
      const exprArr = "[" + expected.map(mbtString).join(", ") + "]";
      lines.push(
        `///|`,
        `test ${mbtString(escName)} {`,
        `  wpt_assert_valid(${mbtString(name)}, ${mbtString(t.input)}, ${exprArr}, ${knownFail})`,
        `}`,
        ``,
      );
    } else {
      lines.push(
        `///|`,
        `test ${mbtString(escName)} {`,
        `  wpt_assert_invalid(${mbtString(name)}, ${mbtString(t.input)}, ${knownFail})`,
        `}`,
        ``,
      );
    }
  }
  return { name: safe, body: lines.join("\n") };
}

function main() {
  mkdirSync(OUT_DIR, { recursive: true });
  const files = readdirSync(FIXTURES_DIR).filter(
    (f) => f.endsWith(".json") && f !== "summary.json",
  );
  let totalTests = 0;
  const moduleNames = [];
  for (const file of files) {
    const fixture = JSON.parse(readFileSync(join(FIXTURES_DIR, file), "utf8"));
    if (!fixture.tests || fixture.tests.length === 0) continue;
    const { name, body } = genTest(fixture);
    const out = join(OUT_DIR, `${name}_test.mbt`);
    writeFileSync(out, body);
    moduleNames.push({ name, count: fixture.tests.length, source: fixture.source });
    totalTests += fixture.tests.length;
  }
  const knownFailCount = KNOWN_FAILURES.size;
  console.log(
    `Generated ${moduleNames.length} test files (${totalTests} tests, ${knownFailCount} known-fails)`,
  );
  if (args.report) {
    for (const m of moduleNames) {
      console.log(`  ${m.source}: ${m.count} tests`);
    }
  }
}

main();
