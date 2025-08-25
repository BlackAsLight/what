import { compile as c, memory } from "./mod.wasm";

const buffer = new Uint8Array(memory.buffer);
const view = new DataView(buffer.buffer);
const decode = function () {
  const decoder = new TextDecoder();
  return decoder.decode.bind(decoder);
}();
const encodeInto = function () {
  const encoder = new TextEncoder();
  return encoder.encodeInto.bind(encoder);
}();

export class WhatError extends Error {
  constructor(message?: string, options?: ErrorOptions) {
    super(message, options);
  }
}

async function set(
  input: string | Uint8Array | ReadableStream<Uint8Array>,
): Promise<number> {
  if (typeof input === "string") {
    return encodeInto(input, buffer.subarray(256)).written;
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

  console.log(buffer.subarray(256));

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
        const x = view.getUint32(addr1 + 1, true);
        const y = view.getUint32(addr1 + 5, true);
        throw new WhatError(
          `Unexpected token "${decode(buffer.subarray(x, y))}" @ ${x - 255}`,
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
  ";": 6
  "=": 7
  "0-9": 100
  "a-zA-Z": 101
  "var": 102
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
    id: i8 | 1
    token_addr: i32
  }
  Unary: {
    id: i8 | 2
    token_addr: i32
    expr_addr: i32
  }
  Factor: {
    id: i8 | 3
    expr_addr1: i32
    token_addr: i32
    expr_addr2: i32
  }
  Term: {
    id: i8 | 4
    expr_addr1: i32
    token_addr: i32
    expr_addr2: i32
  }
  Scope: {
    id: i8 | 5
    size: i8
    expr_addr(1) .. expr_addr(size): i32
  }
  Var: {
    id: i8 | 6
    token_addr: i32
    expr_addr: i32
  }
  Assign: {
    id: i8 | 7
    identifier_addr: i32
    token_addr: i32
    expr_addr: i32
  }
*/

/* Compiler Response
  0: Success
  1: Syntax Error
  2: Unexpected EOF
  3: Unexpected Token
  4: Scope Error
  5: Expected Assign Token
*/
