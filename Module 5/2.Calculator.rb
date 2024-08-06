# frozen_string_literal: true

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
