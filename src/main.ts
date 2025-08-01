import { extname } from "@std/path/extname";
import { parseArgs } from "@std/cli/parse-args";
import { compile, WhatError } from "./mod.ts";

const args = parseArgs(Deno.args);
if (!args._.length) {
  throw new WhatError("Incorrect Usage: Expected input path");
}

const inputPath = args._[0].toString();
const outputPath = args._[1]?.toString() ??
  (extname(inputPath) === ".what"
      ? inputPath.substring(0, inputPath.length - 5)
      : inputPath) +
    ".wasm";

await (await compile((await Deno.open(inputPath)).readable))
  .pipeTo((await Deno.create(outputPath)).writable);
