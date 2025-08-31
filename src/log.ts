import { buffer } from "./mod.ts";
export function log(x: number, y: number): void {
  console.log(x, y);
  console.log(buffer.subarray(y));
}
