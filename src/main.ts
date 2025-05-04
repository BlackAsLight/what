import { memory, scan } from "./mod.wasm";

const buffer = new Uint8Array(memory.buffer);

function scan_tokens(input: string): Uint8Array {
  const output = new TextEncoder().encode(input) as Uint8Array<ArrayBuffer>;
  buffer.set(output, buffer.length - output.length);
  const [a, b] = scan(buffer.length - output.length);
  if (b) throw new TypeError(`Unexpected Character: 0x${a.toString(16)}`);
  return buffer.subarray(256, a);
}

console.log(scan_tokens("10 + -15"));
/*
  " ": [1]
  "\n": [1]
  "+": [2]
  "-": [3]
  "*": [4]
  "/": [5]
  "0": [6, len, bytes]
  "1": [6, len, bytes]
  "2": [6, len, bytes]
  "3": [6, len, bytes]
  "4": [6, len, bytes]
  "5": [6, len, bytes]
  "6": [6, len, bytes]
  "7": [6, len, bytes]
  "8": [6, len, bytes]
  "9": [6, len, bytes]
*/
