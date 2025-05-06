import { compile as c, memory } from "./mod.wasm";

const buffer = new Uint8Array(memory.buffer);

export function compile(input: string): Uint8Array {
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
        throw new SyntaxError(`Unexpected character @ ${addr1 - 256}`);
      default:
        throw new Error(`Unknown Error Code: ${exit_code}`);
    }
  }
  return buffer.slice(addr1, addr2);
}

console.log(compile("10 + 15"));

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
