# frozen_string_literal: true

# For a number of prizes, n, find the distribution of prizes such that the number of prizes is maximized
# And each prize is a distinct integer

# This can be done using a greedy approach, which is not the only solution
# Start by giving the smallest prize, 1, to the first person
# Then give the next smallest prize, 2, to the next person
# Keep incrementing the prize by 1 until the sum of all prizes is greater than n
# Then give the remaining prizes to the last person

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
