#!/usr/bin/env rdmd

import std.array : array;

const C_TIMES = 5;
const C_MILLIONS = [1, 1.5, 3, 6];

void main()
{
  import std.algorithm : each;
  import std.conv : to;

  C_MILLIONS.each!(millions => 
    C_TIMES.test( (millions * 1_000_000).to!ulong )
  );
}

T[] sorted(T)(T[] xs)
{
  import std.algorithm : filter;

  return xs.length == 0 ? [] : 
    xs[1 .. $].filter!(x => x < xs[0]).array.sorted ~ 
    xs[0 .. 1] ~ 
    xs[1 .. $].filter!(x => x >= xs[0]).array.sorted;
}

void test(ulong times, ulong size)
{
  import std.stdio : writefln;
  import std.range : iota;
  import std.algorithm : map, sum;

  auto avg = times == 0 ? 0 : 
    iota(times)
    .map!(_ => generateNumbers(size))
    .map!(xs => measure!(() => xs.sorted))
    .sum() / times;

  "%s,%d,%d".writefln("\"D\"", size, avg);
}

auto generateNumbers(long howMany)
{
  import std.range : generate, take;
  import std.random : Random, uniform, unpredictableSeed;

  auto rnd = Random(unpredictableSeed);
  return generate!(() => uniform(0., 1., rnd))().take(howMany).array();
}

auto measure(alias f)()
{
  import std.datetime.stopwatch : benchmark;

  auto bm = benchmark!(f)(1);
  return bm[0].total!"msecs";
}