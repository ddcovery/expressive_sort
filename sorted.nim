import sequtils, sugar
import random
import times 
import std/strformat

const C_TIMES = 5
const C_MILLIONS = [1.0, 1.5, 3, 6]

func sorted[T](xs:seq[T]): seq[T] = 
  if xs.len==0: @[] else: concat(
    xs[1..^1].filter(x=>x<xs[0]).sorted,
    @[xs[0]],
    xs[1..^1].filter(x=>x>=xs[0]).sorted
  )

proc generate[T](count:int, maxValue:T):seq[T] = 
  randomize()
  var res:seq[T] = @[]
  for _ in 1..count: 
    res.add rand(maxValue)
  result = res

proc measure( p: proc():void  ):float =
  let time = cpuTime()
  p()
  result = cpuTime()-time

proc test(times:int, size:int) = 
  var total:float = 0.0;
  for n in 1..times:
    let x = generate(size, 1.0)
    total = total + measure( proc()=discard x.sorted )
  echo( fmt"{size},{ int(1000 * total/float(times)) }" )


for millions in C_MILLIONS:
  test(C_TIMES, int(millions * 1_000_000) )