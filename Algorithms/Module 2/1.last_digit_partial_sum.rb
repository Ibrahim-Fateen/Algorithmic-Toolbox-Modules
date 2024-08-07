# frozen_string_literal: true

def last_digit_of_partial_sum(m, n)
  pisano10 = 60
  n %= pisano10
  m %= pisano10

  arr = [0, 1]
  (2..61).each do |i|
    arr << (arr[i - 1] + arr[i - 2]) % 10
  end

  (arr[n + 2] - arr[m + 1]).negative? ? (arr[n + 2] - arr[m + 1] + 10).abs : (arr[n + 2] - arr[m + 1]).abs
end

m, n = gets.chomp.split.map(&:to_i)
puts last_digit_of_partial_sum(m, n)
