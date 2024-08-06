# frozen_string_literal: true

def max_ad_revenue(prices, clicks)
  prices = prices.sort
  clicks = clicks.sort
  prices.zip(clicks).map { |p, c| p * c }.sum
end

_ = gets.to_i
prices = gets.split.map(&:to_i)
clicks = gets.split.map(&:to_i)
puts max_ad_revenue(prices, clicks)
