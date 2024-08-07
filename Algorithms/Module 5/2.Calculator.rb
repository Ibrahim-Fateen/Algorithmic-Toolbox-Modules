# frozen_string_literal: true

# The goal here is to use a primitive calculator
# that can: add 1, multiply by 2, or multiply by 3
# to reach the target number, using the minimum number of operations.

# The backtrace array's purpose is to store the previous number that led to the current number.
# The operations array stores the minimum number of operations (price) to reach the target number.

# Starting from 1, the algorithm finds the price of reaching a given number by
# comparing the prices of each of the 3 possible operations.
# The backtrace array is updated with the number that led to the current number.

# At the end, the algorithm backtraces the path from the target number to 1 in the results array.

def min_operations(target)
  operations = []
  backtrace = []
  backtrace[0] = 0
  operations[0] = 0
  (1..target).each do |i|
    add_price = operations[i - 1] + 1
    double_price = operations[i / 2] + 1 if i.even?
    triple_price = operations[i / 3] + 1 if (i % 3).zero?
    operations[i] = [add_price, double_price, triple_price].compact.min
    backtrace[i] = i - 1 if operations[i] == add_price
    backtrace[i] = i / 2 if operations[i] == double_price
    backtrace[i] = i / 3 if operations[i] == triple_price
  end
  results = []
  while target.positive?
    results << target
    target = backtrace[target]
  end
  [results.reverse, operations.last - 1]
end

results, operations = min_operations(gets.to_i)
puts operations
puts results.join(' ')
