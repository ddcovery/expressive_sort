C_TIMES = 5
C_MILLIONS = [1, 1.5, 3, 6]

def sorted(xs):
  return [] if len(xs) == 0 else \
    sorted([x for x in xs[1:] if x < xs[0]]) + \
    xs[0:1] + \
    sorted([x for x in xs[1:] if x >= xs[0]])

def measure(fun):
  import time  
  start = time.time()
  fun()
  return (time.time()-start) * 1000;
 
def test(times, size):
  import random
  total = 0;
  for n in range(times):
    numbers = [ random.random() for a in range(size) ]
    total+= measure(lambda :sorted(numbers) ) 
  print( '%d,%d' %(size, total/times if times>0 else 0) )

for millions in C_MILLIONS:
  test( C_TIMES, int(millions * 1000000) )