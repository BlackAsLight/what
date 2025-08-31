import { compile as c, memory } from "./mod.wasm";

const buffer = new Uint8Array(memory.buffer);
const view = new DataView(memory.buffer);
const decode = function () {
  const decoder = new TextDecoder();
  return decoder.decode.bind(decoder);
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
    return new TextEncoder().encodeInto(input, buffer.subarray(1024)).written;
  }
  if (input instanceof Uint8Array) {
    buffer.set(input, 1024);
    return input.length;
  }
  let x = 1024;
  for await (const chunk of input) {
    buffer.set(chunk, x);
    x += chunk.length;
  }
  return x - 1024;
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
          `Unexpected character "${
            decode(buffer.subarray(addr1, addr1 + 1))
          }" @ byte ${addr1 - 1023}`,
        );
      case 2:
        throw new WhatError("Unexpected EOF");
      case 3: {
        const token = view.getUint8(addr1);
        const start_addr = view.getUint32(addr1 + 1, true);
        const end_addr = view.getUint32(addr1 + 5, true);
        throw new WhatError(
          `Unexpected token (ID: ${token}) "${
            decode(buffer.subarray(start_addr, end_addr))
          }" @ byte ${start_addr - 1023}`,
        );
      }
      case 4:
        throw new WhatError(
          `Too Many Expressions Starting @ byte ${addr1 - 1023}. Max 256/Scope`,
        );
      case 5:
        throw new WhatError(
          `Expected Assignment Expression. Expression ID Found: ${
            buffer[addr1]
          }`,
        );
      case 6: {
        const token_addr = view.getUint32(addr1 + 1, true);
        const start_addr = view.getUint32(token_addr + 1, true);
        const end_addr = view.getUint32(token_addr + 5, true);
        throw new WhatError(
          `Variable "${
            decode(buffer.subarray(start_addr, end_addr))
          }" already exists.`,
        );
      }
      case 7: {
        const token_addr = view.getUint32(addr1 + 1, true);
        const start_addr = view.getUint32(token_addr + 1, true);
        const end_addr = view.getUint32(token_addr + 5, true);
        throw new WhatError(
          `Variable "${
            decode(buffer.subarray(start_addr, end_addr))
          }" doesn't exist.`,
        );
      }
      case 8:
        throw new WhatError("Variable Existence for Scope hit. (Max: 192)");
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
  "=": 50
  "0-9": 100
  "a-zA-Z": 101
  "var": 150
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
    assign_addr: i32
  }
  Assign: {
    id: i8 | 7
    identifier_addr: i32
    token_addr: i32
    expr_addr: i32
  }
  Identifier: {
    id: i8 | 8
    token_addr: i32
  }
*/

/* Compiler Response
  0: Success
  1: Syntax Error
  2: Unexpected EOF
  3: Unexpected Token
  4: Expression Error
  5: Declaration Error
  6: Variable Already Exists Error
  7: Variable Doesn't Exist Error
  8: Too Many Varaibles Exist Error
*/
