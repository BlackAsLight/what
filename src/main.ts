import { extname } from "@std/path/extname";
import { parseArgs } from "@std/cli/parse-args";
import { compile, WhatError } from "./mod.ts";

const args = parseArgs(Deno.args, {
  boolean: ["wat"],
  string: ["wat2wasm", "wasm_opt"],
});

if (!args._.length) {
  throw new WhatError("Incorrect Usage: Expected input path");
}

const inputPath = args._[0].toString();
const outputPath = args._[1]?.toString() ??
  (extname(inputPath) === ".what"
      ? inputPath.substring(0, inputPath.length - 5)
      : inputPath) +
    (args.wat ? ".wat" : ".wasm");

await (await compile((await Deno.open(inputPath)).readable, {
  to: args.wat ? "wat" : "wasm",
  wat2wasm: args.wat2wasm?.split(",") ?? [],
  wasm_opt: args.wasm_opt?.split(",") ?? [],
}))
  .pipeTo((await Deno.create(outputPath)).writable);

console.log(`Compiled: ${outputPath}`);
