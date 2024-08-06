# frozen_string_literal: true

# Just basic implementation of the least common multiple formula.

def lcm(a, b)
  (a * b) / gcd(a, b)
end

def gcd(a, b)
  return a if b.zero?

  gcd(b, a % b)
end

a, b = gets.chomp.split.map(&:to_i)
puts lcm(a, b)
