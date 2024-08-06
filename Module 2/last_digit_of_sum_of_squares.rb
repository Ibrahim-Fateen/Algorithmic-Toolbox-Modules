# frozen_string_literal: true

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
