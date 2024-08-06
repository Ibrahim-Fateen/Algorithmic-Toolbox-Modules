# frozen_string_literal: true

def max_loot(max_weight, weights, values)
  value_per_weight = values.zip(weights).map { |v, w| [v.to_f / w, w] }
  value_per_weight = value_per_weight.sort_by { |vpw, _weight| -vpw }
  total_value = 0
  value_per_weight.each do |element|
    vpw, weight = element
    break if max_weight.zero?

    to_take = [max_weight, weight].min
    value = vpw * to_take
    total_value += value
    max_weight -= to_take
  end
  total_value
end

n, W = gets.split.map(&:to_i)
weights = []
values = []
n.times do
  v, w = gets.split.map(&:to_i)
  weights << w
  values << v
end

puts max_loot(W, weights, values)
