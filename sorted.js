const C_TIMES = 5;
const C_MILLIONS = [1, 1.5, 3, 6];

const sorted = ([pivot, ...others]) => pivot === void 0 ? [] : [
  ...sorted(others.filter(x => x < pivot)),
  pivot,
  ...sorted(others.filter(x => x >= pivot))
];

C_MILLIONS.forEach(millions =>
  test(C_TIMES, millions * 1000000)
);

function test(times, size) {
  let total = 0;
  for (let n = 0; n < times; n++) {
    const numbers = [...Array(size).keys()].map(i => Math.random());
    total += measure(() => sorted(numbers));
  }
  console.log(`${size},${times > 0 ? Math.round(total / times) : 0}`);
}

function measure(f) {
  const t_ini = Date.now();
  f();
  return Date.now() - t_ini;
}
