# frozen_string_literal: true

def max_number_of_gold(max_weight, weights)
  dp = Array.new(max_weight + 1, 0)
  weights.each do |weight|
    max_weight.downto(weight) do |i|
      dp[i] = [dp[i], dp[i - weight] + weight].max
    end
  end
  dp[max_weight]
end

max_weight, n = gets.split.map(&:to_i)
weights = gets.split.map(&:to_i)

puts max_number_of_gold(max_weight, weights)
