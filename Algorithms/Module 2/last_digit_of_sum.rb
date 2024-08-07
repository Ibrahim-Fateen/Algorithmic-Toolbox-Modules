# frozen_string_literal: true

# Pisano period of 10 is 60
# The sum of the first n fibonacci numbers is the (n + 2)th fibonacci number minus 1
def last_digit_of_sum(n)
  arr = [0, 1, 1]
  pisano10 = 60
  n %= pisano10

  (2..n + 2).each do |i|
    # arr[2], arr[1], arr[0] = (arr[1] + arr[0]) % 10, arr[2], arr[1]
    arr[i] = (arr[i - 1] + arr[i - 2]) % 10
  end
  # puts arr.join(' ')
  arr[-1].zero? ? 9 : arr[-1] - 1
end

n = gets.chomp.to_i
puts last_digit_of_sum(n)
