import { compile as c, memory } from "./mod.wasm";

const buffer = new Uint8Array(memory.buffer);

export class WhatError extends Error {
  constructor(message?: string, options?: ErrorOptions) {
    super(message, options);
  }
}

async function set(
  input: string | Uint8Array | ReadableStream<Uint8Array>,
): Promise<number> {
  if (typeof input === "string") {
    return new TextEncoder().encodeInto(input, buffer.subarray(256)).written;
  }
  if (input instanceof Uint8Array) {
    buffer.set(input, 256);
    return input.length;
  }
  let x = 256;
  for await (const chunk of input) {
    buffer.set(chunk, x);
    x += chunk.length;
  }
  return x - 256;
}

export async function compile(
  input: string | Uint8Array | ReadableStream<Uint8Array>,
): Promise<ReadableStream<Uint8Array>> {
  const [exit_code, addr1, addr2] = c(await set(input)) as unknown as [
    number,
    number,
    number,
  ];

  if (exit_code) {
    switch (exit_code) {
      case 1:
        throw new WhatError(
          `Unexpected character "${String.fromCharCode(buffer[addr1])}" @ ${
            addr1 - 255
          }`,
        );
      case 2:
        throw new WhatError("Unexpected EOF");
      case 3: {
        const x = new DataView(buffer.buffer).getUint32(addr1 + 1, true);
        throw new WhatError(
          `Unexpected token "${String.fromCharCode(buffer[x])}" @ ${x - 255}`,
        );
      }
      default:
        throw new WhatError(`Unknown Error Code: ${exit_code}`);
    }
  }

  const { stdin, stdout } = new Deno.Command(
    "wat2wasm",
    {
      args: ["-o", "/dev/stdout", "/dev/stdin"],
      stdin: "piped",
      stdout: "piped",
    },
  )
    .spawn();
  const writer = stdin.getWriter();
  await writer.write(buffer.subarray(addr1, addr2));
  writer.close();
  return stdout;
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
