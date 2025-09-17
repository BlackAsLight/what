import { compile as c } from "./mod.ts";
export { WhatError } from "./mod.ts";

/**
 * @example
 * ```ts
 * import { assertEquals } from "@std/assert";
 * import { encodeBase64 } from "@std/encoding/unstable-base64";
 * import { compile } from "@what/lang";
 *
 * const input = "\
 * export func main(a: i32, b: i32): i32 {\
 *   var c = a + b;\
 *   c = c * 3;\
 *   c;\
 * }\
 * ";
 *
 * const x =
 *   (await import(
 *     "data:application/wasm;base64," +
 *       encodeBase64(await compile(input))
 *   ))
 *     .main(2, 7);
 *
 * assertEquals(x, 27);
 * ```
 */
export async function compile(
  input: string | Uint8Array | ReadableStream<Uint8Array>,
): Promise<Uint8Array<ArrayBuffer>> {
  return await new Response(await c(input)).bytes() as Uint8Array<ArrayBuffer>;
}
