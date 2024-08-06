# frozen_string_literal: true

def money_change(money)
  denominations = [1, 3, 4]
  min_coins = [0]
  (1..money).each do |m|
    min_coins[m] = Float::INFINITY
    denominations.each do |denomination|
      next if m < denomination

      num_coins = min_coins[m - denomination] + 1
      min_coins[m] = num_coins if num_coins < min_coins[m]
    end
  end
  min_coins[money]
end

puts money_change(gets.to_i)
