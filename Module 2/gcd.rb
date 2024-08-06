# frozen_string_literal: true

def gcd(a, b)
  return a if b.zero?

  gcd(b, a % b)
end

a, b = gets.chomp.split.map(&:to_i)
puts gcd(a, b)
