def sorted(items):
  return [] if len(items) == 0 else \
    sorted([item for item in items[1:] if item < items[0]]) + \
    items[0:1] + \
    sorted([item for item in items[1:] if item >= items[0]])

def measure(times, fun):
  import time
  total = 0;
  for n in range(times):
    start = time.time()
    fun()
    end = time.time()
    total += (end-start)
  
  return 0 if times == 0 else  1000 * total / times

def test():
  import random

  numbers1M = [ random.random() for a in range(1000000) ]
  numbers1M5= [ random.random() for a in range(1500000) ]
  numbers3M = [ random.random() for a in range(3000000) ]
  numbers6M = [ random.random() for a in range(6000000) ]

  t = measure(5, lambda :sorted(numbers1M) )
  print('1.0M: %d ms' %t)
  t = measure(5, lambda :sorted(numbers1M5) )
  print('1.5M: %d ms' %t)
  t = measure(5, lambda :sorted(numbers3M) )
  print('3.0M: %d ms' %t)
  t = measure(5, lambda :sorted(numbers6M) )
  print( '6.0M: %d ms' %t)


test()
