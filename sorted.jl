using Printf

C_TIMES = 5
C_MILLIONS = [1, 1.5, 3, 6]

function sorted(xs::Array{Float64, 1})::Array{Float64, 1}
  return length(xs) == 0 ? Array{Float64, 1}() : vcat(
    sorted([ x for x in xs[2:end] if x < xs[1] ]),
    xs[1],
    sorted([ x for x in xs[2:end] if x >= xs[1] ])
  )
end

function test(times, size)
  total = 0;
  for n = 1:times
    numbers::Array{Float64, 1} = [ rand() for a = 1:size ]
    r = @timed begin
      sorted(numbers)
    end
    total = total + r[2] * 1000
  end
  @printf "%d,%d\n" size (times>0 ? total/times : 0)
end

for millions in C_MILLIONS
  test(C_TIMES, millions * 1000000)
end