# frozen_string_literal: true

# Again we need to find the last digit, so we only store the last digit of each Fibonacci number
# and use 10 as the modulo so pisano = 60
# The sum of squares of the first n fib numbers is
# the nth fib number times the (n + 1)th fib number

def last_digit_of_sum_of_squares(n)
  arr = Array.new(2)
  arr[0] = 0
  arr[1] = 1

  pisano10 = 60
  n %= pisano10
  return n if n <= 1

  (2..n).each do
    arr[0], arr[1] = arr[1], (arr[0] + arr[1]) % 10
  end
  (arr[1] * (arr[1] + arr[0])) % 10
end

n = gets.chomp.to_i
puts last_digit_of_sum_of_squares(n)
