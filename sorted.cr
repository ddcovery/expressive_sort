#puts "Generating"
numbers1M = (0..1000000).map { |x| Random.rand }
numbers1M5 = (0..1500000).map { |x| Random.rand }
numbers3M = (0..3000000).map { |x| Random.rand }
numbers6M = (0..6000000).map { |x| Random.rand }
#puts "Testing"
r1M = measure { sorted(numbers1M) }
r1M5 = measure { sorted(numbers1M5) }
r3M = measure { sorted(numbers3M) }
r6M = measure { sorted(numbers6M) }
puts "1.0M: #{r1M} ms"
puts "1.5M: #{r1M5} ms"
puts "3.0M: #{r3M} ms"
puts "6.0M: #{r6M} ms"
#puts "Ok"

def sorted(items : Array(Float64)) : Array(Float64)
  return items.size == 0 ? [] of Float64  :
    sorted(items[1..].select { |item| item < items[0] }) +
    [ items[0] ] +
    sorted(items[1..].select { |item| item >= items[0] })
end

def measure
  t1 = Time.utc
  yield
  return (Time.utc - t1).total_milliseconds.ceil
end
