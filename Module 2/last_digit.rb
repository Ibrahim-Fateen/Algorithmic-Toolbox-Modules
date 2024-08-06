# frozen_string_literal: true

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
