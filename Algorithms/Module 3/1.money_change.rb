# frozen_string_literal: true

# greedy implementation of money change problem with denominations 10, 5, 1

def money_change(c)
  c / 10 + (c % 10) / 5 + (c % 10) % 5
end

c = gets.to_i
puts money_change(c)
