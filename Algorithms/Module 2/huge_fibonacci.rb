# frozen_string_literal: true

# Using some insight, the fibonacci numbers mod m have a period of pisano(m), meaning they repeat
# after pisano(m) numbers. So, we can calculate the fibonacci number at n mod pisano(m) instead of
# calculating the fibonacci number at n directly.
# The pisano period of m is the smallest number k such that F(k) mod m = 0 and F(k + 1) mod m = 1,
# where F(k) is the kth fibonacci number.


def huge_fib(n, m)
  return n if n <= 1

  pisano_period = pisano(m)
  n %= pisano_period
  # puts "n: #{n}, pisano_period: #{pisano_period}"
  return n if n <= 1

  arr = Array.new(2)
  arr[0] = 0
  arr[1] = 1
  (2..n).each do
    arr[0], arr[1] = arr[1], (arr[0] + arr[1]) % m
  end
  arr[-1]
end

def pisano(m)
  a = 0
  b = 1
  (0..m * m).each do |i|
    a, b = b, (a + b) % m
    return i + 1 if a.zero? && b == 1
  end
end

n, m = gets.chomp.split.map(&:to_i)
puts huge_fib(n, m)
