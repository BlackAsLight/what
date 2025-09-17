import { compile as c, memory } from "./mod.wasm";

export const buffer = new Uint8Array(memory.buffer);
export const view = new DataView(memory.buffer);
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
          }" @ byte ${addr1 - 1024}`,
        );
      case 2:
        throw new WhatError("Unexpected EOF");
      case 3: {
        const token = view.getUint8(addr1);
        const start_addr = view.getUint32(addr1 + 1, true);
        const end_addr = view.getUint32(addr1 + 5, true);
        console.log(
          exit_code,
          addr1,
          addr2,
          token,
          start_addr,
          end_addr,
          buffer.subarray(addr1),
        );
        throw new WhatError(
          `Unexpected token (ID: ${token}) "${
            decode(buffer.subarray(start_addr, end_addr))
          }" @ byte ${start_addr - 1024}`,
        );
      }
      case 5:
        throw new WhatError(
          `Expected Assignment Expression. Expression ID Found: ${
            buffer[addr1]
          }`,
        );
      case 6: {
        const start_addr = view.getUint32(addr1 + 1, true);
        const end_addr = view.getUint32(addr1 + 5, true);
        throw new WhatError(
          `Variable "${
            decode(buffer.subarray(start_addr, end_addr))
          }" already exists.`,
        );
      }
      case 7: {
        const start_addr = view.getUint32(addr1 + 1, true);
        const end_addr = view.getUint32(addr1 + 5, true);
        throw new WhatError(
          `Variable "${
            decode(buffer.subarray(start_addr, end_addr))
          }" doesn't exist.`,
        );
      }
      case 8:
        throw new WhatError("Variable Existence for Scope hit. (Max: 192)");
      case 9:
        throw new WhatError("Unexpected Type Received in Expression");
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
  ":": 7
  "(": 8
  ")": 9
  "{": 10
  "}": 11
  ",": 12
  "=": 50
  "==": 51
  "!": 52
  "!=": 53
  "<": 54
  "<=": 55
  ">": 56
  ">=": 57
  "[0-9]+": 100
  "[a-zA-Z][a-zA-Z0-9]*": 101
  "var": 150
  "func": 151
  "i32": 200
*/

/* Token Struct
  {
    token: i8
    start_addr: i32
    end_addr: i32
  }
*/

/* Memory Structure
  Range: 256 - 1024
  Struct: {
    type: i8
    expr_addr: i32
  }
*/

/* Type Enum
  0: No Type
  1: Boolean
  2: i32
*/

/* AST Enum
  Node: {
    node_addr: i32 | Node?
    expr_addr: i32
  }
  Primary: {
    id: i8 | 1
    type: i8
    token_addr: i32
  }
  Unary: {
    id: i8 | 2
    type: i8
    token_addr: i32
    expr_addr: i32
  }
  Factor: {
    id: i8 | 3
    type: i8
    expr_addr1: i32
    token_addr: i32
    expr_addr2: i32
  }
  Term: {
    id: i8 | 4
    type: i8
    expr_addr1: i32
    token_addr: i32
    expr_addr2: i32
  }
  Root: {
    id: i8 | 5
    type: i8
    node_addr: i32 | Node?
  }
  Var: {
    id: i8 | 6
    type: i8
    identifier_token_addr: i32
    expr_addr: i32
  }
  Assign: {
    id: i8 | 7
    type: i8
    expr_addr1: i32
    expr_addr2: i32
  }
  Identifier: {
    id: i8 | 8
    type: i8
    token_addr: i32
  }
  Compare: {
    id: i8 | 9
    type: i8
    expr_addr1: i32
    token_addr: i32
    expr_addr2: i32
  }
  Function: {
    id: i8 | 10
    type: i8
    identifier_token_addr: i32
    argument_node_addr: i32 | Node?
    return_type: i8
    body_node_addr: i32 | Node?
  }
  Argument: {
    id: i8 | 11
    type: i8
    identifier_token_addr: i32
  }
  Call: {
    id: i8 | 12
    type: i8
    identifier_token_addr: i32
    parameter_node_addr: i32 | Node?
  }
*/

/* Compiler Response
  0: Success
  1: Syntax Error
  2: Unexpected EOF
  3: Unexpected Token
  5: Declaration Error
  6: Reference Already Exists Error
  7: Reference Doesn't Exist Error
  8: Too Many Refereces Exist Error
  9: Received Wrong Type
*/
