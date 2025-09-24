import { compile as c, WhatError, type WhatOptions } from "./mod.ts";
export { WhatError, type WhatOptions };

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
  options: Partial<WhatOptions> = {},
): Promise<Uint8Array<ArrayBuffer>> {
  options.to ??= "wasm";
  options.wat2wasm ??= [];
  options.wasm_opt ??= [];
  return await new Response(await c(input, options as WhatOptions))
    .bytes() as Uint8Array<ArrayBuffer>;
}
