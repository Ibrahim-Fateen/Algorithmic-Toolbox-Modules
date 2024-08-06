# frozen_string_literal: true

# Used euclidean recursive algorithm to find the greatest common divisor of two numbers
def gcd(a, b)
  return a if b.zero?

  gcd(b, a % b)
end

a, b = gets.chomp.split.map(&:to_i)
puts gcd(a, b)
