# frozen_string_literal: true

def last_digit_of_partial_sum(m, n)
  return n if n <= 1

  arr = Array.new(2)
  arr[0] = 0
  arr[1] = 1
  pisano10 = 60
  n %= pisano10
  m %= pisano10
  # puts "n: #{n}, m: #{m}"

  (2..61).each do |i|
    arr[i] = (arr[i - 1] + arr[i - 2]) % 10
  end
  # puts "arr[m+1] = arr[#{m + 1}]: #{m_sum}"
  # puts "arr[n+2] = arr[#{n + 2}]: #{arr[n + 2]}"
  (arr[n + 2] - arr[m + 1]).abs % 10
end

m, n = gets.chomp.split.map(&:to_i)
puts last_digit_of_partial_sum(m, n)
