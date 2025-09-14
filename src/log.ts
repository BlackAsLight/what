// deno-lint-ignore no-unused-vars verbatim-module-syntax
import { buffer, view } from "./mod.ts";

export function log(x: number): void {
  console.log(x, buffer.subarray(x, x + 10));
}

export function spy(x: number): number {
  console.log(x, buffer.subarray(x, x + 10));
  return x;
}
