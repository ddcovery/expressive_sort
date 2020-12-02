#!/usr/bin/env rdmd
void main()
{
  import std.stdio : writefln;
  import std.datetime.stopwatch : benchmark;

  const C_TIMES = 5;

  //writefln("Generating");
  double[] numbers1M = generateNumbers(1_000_000);
  double[] numbers1M5 = generateNumbers(1_500_000);
  double[] numbers3M = generateNumbers(3_000_000);
  double[] numbers6M = generateNumbers(6_000_000);
  //writefln("Testing");
  auto bm = benchmark!({ 
    sorted(numbers1M);
  }, { 
    sorted(numbers1M5);
  }, { 
    sorted(numbers3M);
  },{ 
    sorted(numbers6M);
  })(C_TIMES);
  writefln("1.0M: %s ms", bm[0].total!"msecs"/C_TIMES);
  writefln("1.5M: %s ms", bm[1].total!"msecs"/C_TIMES);
  writefln("3.0M: %s ms", bm[2].total!"msecs"/C_TIMES);
  writefln("6.0M: %s ms", bm[3].total!"msecs"/C_TIMES);
  
  //writefln("Ok");
}

T[] sorted(T)(T[] items)
{
  import std.algorithm : filter;
  import std.array : array;

  return items.length == 0 ? [] : 
    sorted( items[1 .. $].filter!(item => item < items[0]).array() ) ~ 
    items[0 .. 1] ~ 
    sorted( items[1 .. $].filter!(item => item >= items[0]).array() );
}
double [] generateNumbers(int howMany)
{
  import std.range: generate, take;  
  import std.array: array;
  import std.random: Random, uniform, unpredictableSeed;
  auto rnd = Random(unpredictableSeed); 
  return generate!(() => uniform(0.,1.,rnd) )().take(howMany).array();
  
}
