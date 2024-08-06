# frozen_string_literal: true

# finding the last number of the nth fibonacci number
# No need to store every number,
# just the last digit since adding the last digit of two numbers will give the last digit of the sum
def last_digit(n)
  arr = Array.new(n)
  arr[0] = 0
  arr[1] = 1
  (2..n).each do |i|
    arr[i] = (arr[i - 1] + arr[i - 2]) % 10
  end
  arr[n]
end

n = gets.chomp.to_i
puts last_digit(n)
