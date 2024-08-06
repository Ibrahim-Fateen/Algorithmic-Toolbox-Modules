# frozen_string_literal: true

# The goal is to form the largest number from the given list of integers
# We made use of ruby's sort method, which takes a block to compare two elements
# The maximum combination of two elements is determined by comparing the concatenation of the two elements
# The rest of the approach is just a greedy solution, where we sort the elements in descending order.
def largest_number(a)
  a.sort { |x, y| y.to_s + x.to_s <=> x.to_s + y.to_s }.join.to_i
end

_ = gets.to_i
a = gets.split.map(&:to_i)
puts largest_number(a)
