# frozen_string_literal: true

def money_change(c)
  c / 10 + (c % 10) / 5 + (c % 10) % 5
end

c = gets.to_i
puts money_change(c)
