# frozen_string_literal: true

n = gets.to_i
tree = Array.new(n) { [] }
n.times do |i|
  tree[i] = gets.split.map(&:to_i)
end

def is_bst?(tree, i, min, max)
  return true if tree.empty? || i == -1

  return false if tree[i][0] < min || tree[i][0] > max

  left = is_bst?(tree, tree[i][1], min, tree[i][0] - 1)
  right = is_bst?(tree, tree[i][2], tree[i][0], max)

  left && right
end

puts is_bst?(tree, 0, -Float::INFINITY, Float::INFINITY) ? 'CORRECT' : 'INCORRECT'
