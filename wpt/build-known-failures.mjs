#!/usr/bin/env node
// Rebuild wpt/known-failures.json from the current `moon test` results.
//
// Use this after intentional parser improvements:
//   1. node wpt/extract.mjs
//   2. node wpt/gen-mbt.mjs        (with the OLD known-failures.json)
//   3. moon test --package mizchi/css/wpt  → see what fails
//   4. node wpt/build-known-failures.mjs   (clears known-failures.json)
//   5. node wpt/gen-mbt.mjs        (no known-failures => everything fails again)
//   6. moon test --package mizchi/css/wpt  → capture all failures
//   7. node wpt/build-known-failures.mjs --from-moon
//      (records every currently-failing test into known-failures.json)
//
// For a one-shot bootstrap (current state defines the baseline), run:
//   node wpt/build-known-failures.mjs --bootstrap

import { execSync } from "node:child_process";
import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const FIXTURES_DIR = join(__dirname, "fixtures");
const OUT = join(__dirname, "known-failures.json");

function fixturesByBasename() {
  const map = new Map();
  for (const f of readdirSync(FIXTURES_DIR)) {
    if (!f.endsWith(".json") || f === "summary.json") continue;
    const data = JSON.parse(readFileSync(join(FIXTURES_DIR, f), "utf8"));
    const basename = data.source.split("/").pop();
    map.set(basename, data);
  }
  return map;
}

function bootstrap() {
  // Mark every test as expected-fail so the next moon test run is green.
  // Then a parser improvement turns some into "now passes — remove from
  // known-failures" failures, which is the signal to refresh the list.
  console.error(
    "Bootstrap mode is not the recommended workflow; prefer --from-moon.",
  );
  process.exit(1);
}

function fromMoon() {
  const out = execSync(
    "moon test --package mizchi/css/wpt 2>&1 || true",
    { encoding: "utf8", cwd: join(__dirname, "..") },
  );
  const failures = [];
  // moon prints lines like:
  //   [pkg] test wpt/parse_attribute_html_test.mbt:10 ("wpt parse-attribute.html: valid [att]") failed: ...
  const re =
    /test wpt\/(\S+)_test\.mbt:\d+ \("wpt ([^:]+): (valid|invalid) (.+?)"\) failed:/g;
  let m;
  while ((m = re.exec(out)) !== null) {
    const sourceBasename = m[2]; // e.g. "parse-attribute.html"
    const kind = m[3];
    let input = m[4];
    // Moon doubles-escapes \" → \\\" in the test-name display. Reverse.
    input = input.replace(/\\\\"/g, '\\"').replace(/\\\\/g, "\\");
    // Then decode the MoonBit string literal escapes.
    input = input.replace(/\\"/g, '"').replace(/\\\\/g, "\\");
    failures.push({ source: sourceBasename, input, kind });
  }
  // Dedup
  const seen = new Set();
  const dedup = [];
  for (const f of failures) {
    const k = `${f.source}\x00${f.input}\x00${f.kind}`;
    if (seen.has(k)) continue;
    seen.add(k);
    dedup.push(f);
  }
  dedup.sort((a, b) => {
    if (a.source !== b.source) return a.source.localeCompare(b.source);
    return a.input.localeCompare(b.input);
  });
  return dedup;
}

const mode = process.argv[2];
let list;
if (mode === "--from-moon") {
  list = fromMoon();
} else if (mode === "--bootstrap") {
  bootstrap();
} else {
  console.error("usage: node wpt/build-known-failures.mjs --from-moon");
  process.exit(1);
}

writeFileSync(
  OUT,
  JSON.stringify(
    {
      description:
        "Tests expected to fail because the underlying selector feature is not yet implemented (shadow DOM pseudos, namespace selectors, empty :not()/:has() forgiving validation, etc.). Each entry is matched verbatim by gen-mbt.mjs and turned into a known-failure case. A test that starts passing reports an error so we can clean it up.",
      expected_failures: list,
    },
    null,
    2,
  ) + "\n",
);
console.log(`Wrote ${list.length} expected failures to ${OUT}`);
