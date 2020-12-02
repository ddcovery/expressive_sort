# expressive_sort

In this quora [answere](https://es.quora.com/Por-qu%C3%A9-la-mayor%C3%ADa-de-los-desarrolladores-estudian-solo-lenguajes-muy-simples-como-JavaScript-y-Python-en-lugar-de-aprender-un-lenguaje-verdadero-como-C-2/answer/Antonio-Cabrera-52) I wrote about javascript/python expressiveness vs Go/Rust/D/... performance.

As an example, I mentioned the "3 lines" haskell quick sort and wrote this javascript version

```javascript
const sorted = ([pivot, ...others]) => pivot === void 0 ? [] : [
  ...sorted(others.filter(n => n < pivot)),
  pivot,
  ...sorted(others.filter(n => n >= pivot))
];
```

This, of course, is not a "quick sort" because the original one is an "in place" algorithm that doesn't require additional memory space allocation.  This is a functional oriented expression that exemplarizes how expressive a "functional" orientation can be (You "express" that the sorted version of an array is, given one of it's elements, the sorted version of the smaller ones, plus the item, plus the sorted version of the bigger ones).

As an enthusiastic newbie to the "[D](https://dlang.org)" programming language, I thought that D could affort this expressiveness too...

D has no support for destructuring as javascript has (remember de ```sorted([pivot, ...others])```), but it has **lambdas**, **map/filter/reduce** support, **array slices** and **array concatenation** that allows you to write easily a similar expression:

```d
T[] sorted(T)(T[] items)
{
  return items.length == 0 ? [] : 
    sorted(items[1 .. $].filter!(p => p < items[0]).array) ~ 
    items[0 .. 1] ~ 
    sorted(items[1 .. $].filter!(p => p >= items[0]).array);
}
```

> **note**: **sorted** is a *templated method* (**T** is the type of the elements of the array): "under the scenes", D compiler detects if the final used type is comparable (i.e.:  it is a class with a **opCmp** method, or it is a numerical type, or ...):  yo don't need to tell compiler that T extends something like *"IComparable"* because D libraries are not "interface" based:  D prefers to use "conventions" and check them using instrospection at compile time (D developers write compile-time code and run-time code at the same time:  D allows you to mix them naturally).

Seeing the similarities, I assume (I really don't know) that javascript and D versions are doing the same "under the scenes":

* The ```[...array1, ...array2, ...array3]``` javascript is equivalent to the ```array1 ~ array2 ~ array3``` D code.  That is, a new array is being generated as a result of copying the elements of the original 3.
* The ```.filter!(...).array``` D code is using a "Range" to filter the elements and the ".array()" method to materialize the selected elements as an array.  Internally, it is similar to the javascript code where ```.filter(...)``` iterates and selects the resulting elements and finally materializes the array

## Wich one will perform better?

Here comes the surprise (at least for me):  Javascript version performs better than D version (about **30% faster for 1_000_000 random Float64 numbers**).

* Javascript (node):  **1610 ms**
* D (DMD compiler):  **2017 ms**

Main problem is DMD compiler (compiles fast, but performance is not the best).  D has various compilers... the **lcd2** compiler can generate optimized binaries

* D (LDC2 compiler):  **772 ms**


I decided to write similar code in other languajes and compare.

In python:

```python
def sorted(items):
  return [] if len(items) == 0 else \
    sorted([item for item in items[1:] if item < items[0]]) + \
    items[0:1] + \
    sorted([item for item in items[1:] if item >= items[0]])
```

In crystal:

```ruby
def sorted(a : Array(Float64)) : Array(Float64)
  return a.size == 0 ? [] of Float64  :
    sorted(a[1..].select { |x| x < a[0] }) +
    [ a[0] ] +
    sorted(a[1..].select { |x| x >= a[0] })
end
```

The resulting final table for different sets of data

![Process time](assets/process_time_graph.png)

```
D (LCD)
1.0M: 772 ms
1.5M: 1152 ms
3.0M: 2398 ms
6.0M: 4952 ms
javascript (node)
1.0M: 1610 ms
1.5M: 2355 ms
3.0M: 5760 ms
6.0M: 9829 ms
Crystal
1.0M: 1888.0 ms
1.5M: 2829.0 ms
3.0M: 5813.0 ms
6.0M: 12477.0 ms
D (DMD)
1.0M: 2017 ms
1.5M: 2974 ms
3.0M: 6285 ms
6.0M: 13328 ms
python
1.0M: 4445 ms
1.5M: 7698 ms
3.0M: 17826 ms
6.0M: 41000 ms

```
## Do you know how to improve?
I include the code to the 4 tests.  Please, tell me if you see something we can improve:
* Avoid imperative instructions:  "sorted" must be an unique expression or, at least, an unique "return ..." statement funcion.  
* Of course, you can't use built-in library sort methods :-)
* Remember that this is not a quick-sort performance test (that, obviously, can be implemented in a more efficient way)


## Running the tests

### Prerequisites

All tests has been executed on a Ubuntu 20.04 linux.  
Tests require **Nodejs**, **Python3**, **DMD** compiler and **Crystal** compiler

**Javascript**:  Test runs on Node, I use node 12.20 (see [NodeSource distributions](https://github.com/nodesource/distributions/blob/master/README.md) for more information)

**Python**:  Ubuntu comes with **python 3** preinstalled.  Test the version with
```shell
$ pythong3 --version
```
**D**:  We use **DMD** and **LDC**. The two ones are available in Ubuntu official repositories.
```shell
$ sudo apt install dmd
$ sudo apt install ldc
...
$ dmd --version
DMD64 D Compiler v2.093.0
Copyright (C) 1999-2020 by The D Language Foundation, All Rights Reserved written by Walter Bright
$ ldc2 --version
LDC - the LLVM D compiler (1.20.1):
  based on DMD v2.090.1 and LLVM 10.0.0
  built with LDC - the LLVM D compiler (1.20.1)
  Default target: x86_64-pc-linux-gnu
  Host CPU: skylake
  http://dlang.org - http://wiki.dlang.org/LDC
```

**Crystal**: You must add the repository to your Ubuntu software sources and install it  (see [guide](https://crystal-lang.org/install/on_ubuntu/) for more information )

### Running the test

You can run all languajes tests using tests.sh

```shell
$ test.sh
```

Or test them individually

**D (LDC)**
```shell
$ ldc2 -O -release  --run sorted.d 
```
**D (DMD)**
```shell
$ dmd -O -run sorted.d
```
**Javascript**
```shell
$ node sorted.js
```
**Crystal**
```shell
$ crystal sorted.cr --release
```
**Python**
```shell
$ python3 sorted.py
```
