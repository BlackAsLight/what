import { compile as c, memory } from "./mod.wasm";

const buffer = new Uint8Array(memory.buffer);

/**
 * @example
 * ```ts
 * import { assertEquals } from "@std/assert";
 * import { encodeBase64 } from "@std/encoding/unstable-base64";
 * import { compile } from "@what/lang";
 *
 * const x =
 *   (await import(
 *     "data:application/wasm;base64," +
 *       encodeBase64(await compile("-10 * 15 + 2 - -8 / 2"))
 *   ))
 *     .main() as number;
 *
 * assertEquals(x, -144);
 * ```
 */
export async function compile(input: string): Promise<Uint8Array<ArrayBuffer>> {
  const written = new TextEncoder()
    .encodeInto(input, buffer.subarray(256)).written;
  const [exit_code, addr1, addr2] = c(written) as unknown as [
    number,
    number,
    number,
  ];
  if (exit_code) {
    switch (exit_code) {
      case 1:
        throw new SyntaxError(
          `Unexpected character "${String.fromCharCode(buffer[addr1])}" @ ${
            addr1 - 255
          }`,
        );
      case 2:
        throw new RangeError("Unexpected EOF");
      case 3: {
        const x = new DataView(buffer.buffer).getUint32(addr1 + 1, true);
        throw new ReferenceError(
          `Unexpected token "${String.fromCharCode(buffer[x])}" @ ${x - 255}`,
        );
      }
      default:
        throw new Error(`Unknown Error Code: ${exit_code}`);
    }
  }

  await Deno.writeFile(".temp.wat", buffer.subarray(addr1, addr2));
  const { code } = await new Deno.Command(
    "wat2wasm",
    { args: ["-o", ".temp.wasm", ".temp.wat"] },
  )
    .spawn()
    .status;
  if (code) {
    throw new Error(`wat2wasm Error Code: ${code}`);
  }
  await Deno.remove(".temp.wat");
  const result = await Deno.readFile(".temp.wasm");
  await Deno.remove(".temp.wasm");
  return result;
}

/* Token Enum // 1 Does not appear in array; merely to remove whitespace
  " ": 1
  "\n": 1
  "+": 2
  "-": 3
  "*": 4
  "/": 5
  "0": 6
  "1": 6
  "2": 6
  "3": 6
  "4": 6
  "5": 6
  "6": 6
  "7": 6
  "8": 6
  "9": 6
*/

/* Token Struct
  {
    token: i8
    start_addr: i32
    end_addr: i32
  }
*/

/* AST Enum
  Primary: {
    id: i8
    token_addr: i32
  }
  Unary: {
    id: i8
    token_addr: i32
    expr_addr: i32
  }
  Binary: {
    id: i8
    expr_addr1: i32
    token_addr: i32
    expr_addr2: i32
  }
*/

/* Compiler Response
  0: Success
  1: Syntax Error
  2: Unexpected EOF
  3: Unexpected Token
*/
