const buffer = new Uint8Array(1024);
const view = new DataView(buffer.buffer);

const decode = function () {
  const decoder = new TextDecoder();
  return decoder.decode.bind(decoder);
}();

while (true) {
  const read = Deno.stdin.readSync(buffer)! - 1;
  if (read <= 0) break;
  buffer.fill(0, read);
  for (let i = 0; i < read; i += 4) {
    console.log(
      ">",
      decode(buffer.subarray(i, i + 4)).replaceAll("\0", " "),
      view.getUint32(i, true),
    );
  }
}
