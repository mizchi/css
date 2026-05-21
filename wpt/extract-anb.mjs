#!/usr/bin/env node
// Extract WPT css-syntax An+B parsing tests.
//
// Source: css/css-syntax/anb-parsing.html, anb-serialization.html
//
// Both files use a custom helper `testANB(input, expected)` defined inline
// at the top of the file. The semantics are equivalent: set the
// selectorText of a `:nth-child()` rule to `:nth-child(<input>)` and check
// the canonical serialization. We extract every testANB(...) call into
// an (input, expected) pair, where expected may also be "parse error".

import { mkdirSync, writeFileSync, readFileSync, existsSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const FIXTURES_DIR = join(__dirname, "fixtures");

const SOURCES = [
  "css/css-syntax/anb-parsing.html",
  "css/css-syntax/anb-serialization.html",
];

const RAW_BASE =
  "https://raw.githubusercontent.com/web-platform-tests/wpt/master/";

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

function parseStringLiteral(src, start) {
  const quote = src[start];
  if (quote !== '"' && quote !== "'" && quote !== "`") return null;
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
      else if (next === "`") out += "`";
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

function skipWs(src, i) {
  while (i < src.length) {
    const c = src[i];
    if (c === " " || c === "\t" || c === "\n" || c === "\r") i += 1;
    else if (c === "/" && src[i + 1] === "/") {
      while (i < src.length && src[i] !== "\n") i += 1;
    } else if (c === "/" && src[i + 1] === "*") {
      i += 2;
      while (i < src.length - 1 && !(src[i] === "*" && src[i + 1] === "/")) i += 1;
      i += 2;
    } else break;
  }
  return i;
}

function extract(src, sourceLabel) {
  const tests = [];
  const reCall = /\btestANB\s*\(/g;
  let match;
  while ((match = reCall.exec(src)) !== null) {
    let i = match.index + match[0].length;
    i = skipWs(src, i);
    const first = parseStringLiteral(src, i);
    if (!first) continue;
    i = skipWs(src, first[1]);
    if (src[i] !== ",") continue;
    i += 1;
    i = skipWs(src, i);
    const second = parseStringLiteral(src, i);
    if (!second) continue;
    tests.push({ input: first[0], expected: second[0] });
  }
  return { source: sourceLabel, tests };
}

async function main() {
  mkdirSync(FIXTURES_DIR, { recursive: true });
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
    const outPath = join(FIXTURES_DIR, `anb-${basename.replace("anb-", "")}.json`);
    writeFileSync(
      outPath,
      JSON.stringify({ source: rel, kind: "anb", tests }, null, 2) + "\n",
    );
    console.log(`${rel}: ${tests.length} tests → ${outPath}`);
  }
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
