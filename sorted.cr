C_TIMES = 5;
C_MILLIONS = [1,1.5,3,6];

C_MILLIONS.each do |x|
  test(C_TIMES, (1000000 * x).to_i )
end

def sorted(xs : Array(Float64)) : Array(Float64)
  return xs.size == 0 ? [] of Float64  :
    sorted(xs[1..].select { |x| x < xs[0] }) +
    [ xs[0] ] +
    sorted(xs[1..].select { |x| x >= xs[0] })
end

def test( times : Int32, n : Int32 )
  total = 0;
  (1..times).each do
    numbers = (0..n-1).map { |x| Random.rand }
    total += measure { sorted(numbers) }
  end
  puts "\"crystal\",#{n},#{ times>0 ? (total/times).ceil : 0}"
end

def measure
  t1 = Time.utc
  yield
  return (Time.utc - t1).total_milliseconds  
end