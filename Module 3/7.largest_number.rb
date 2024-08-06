# frozen_string_literal: true

def largest_number(a)
  a.sort { |x, y| y.to_s + x.to_s <=> x.to_s + y.to_s }.join.to_i
end

_ = gets.to_i
a = gets.split.map(&:to_i)
puts largest_number(a)
