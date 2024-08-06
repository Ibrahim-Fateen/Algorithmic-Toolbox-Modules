# frozen_string_literal: true

def fib(n)
  if n <= 1
    return n
  end
  arr = Array.new(2)
  arr[0] = 0
  arr[1] = 1
  (2..n).each do |i|
    arr[0], arr[1] = arr[1], arr[0] + arr[1]
  end
  arr[-1]
end

n = gets.chomp.to_i
puts fib(n)
