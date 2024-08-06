# frozen_string_literal: true

def max_prizes(n)
  summands = []
  sum = 0
  i = 1
  while sum + i <= n
    summands << i
    sum += i
    i += 1
  end
  summands[-1] += n - sum
  summands
end

n = gets.to_i
max_prizes = max_prizes(n)
puts max_prizes.size
puts max_prizes.join(' ')
