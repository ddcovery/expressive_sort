const sorted = ([pivot, ...others]) => pivot === void 0 ? [] : [
  ...sorted(others.filter(n => n < pivot)),
  pivot,
  ...sorted(others.filter(n => n >= pivot))
];

console.log("# JavasScript");
//console.log("Generating");
const numbers1M = [...Array(1000000).keys()].map(i => Math.random());
const numbers1M5 = [...Array(1500000).keys()].map(i => Math.random());
const numbers3M = [...Array(3500000).keys()].map(i => Math.random());
const numbers6M = [...Array(6000000).keys()].map(i => Math.random());

//console.log("Testing");

const [t1M, t1M5, t3M, t6M] = [
  measure(() => sorted(numbers1M)),
  measure(() => sorted(numbers1M5)),
  measure(() => sorted(numbers3M)),
  measure(() => sorted(numbers6M))
]

console.log("1.0M:", t1M, "ms");
console.log("1.5M:", t1M5, "ms");
console.log("3.0M:", t3M, "ms");
console.log("6.0M:", t6M, "ms");

//console.log("ok");

function measure(f) {
  const t_ini = Date.now();
  f();
  return Date.now() - t_ini; 
}