# frozen_string_literal: true

# The goal is to maximize the revenue from ads
# The revenue is the sum of the product of the price and the number of clicks
# We need a way to pair the prices and clicks to maximize the revenue
# Greedy approach works here
def max_ad_revenue(prices, clicks)
  prices = prices.sort
  clicks = clicks.sort
  prices.zip(clicks).map { |p, c| p * c }.sum
end

_ = gets.to_i
prices = gets.split.map(&:to_i)
clicks = gets.split.map(&:to_i)
puts max_ad_revenue(prices, clicks)
