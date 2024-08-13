# frozen_string_literal: true

n = gets.to_i
tree = Array.new(n) { [] }
n.times do |i|
  tree[i] = gets.split.map(&:to_i)
end

def is_bst?(tree)
  # node[0]: value
  # node[1]: left index in tree
  # node[2]: right index in tree
  tree.each do |node|
    max_left = node[1]
    min_right = node[2]
    max_left = tree[max_left][2] while max_left != -1 && tree[max_left][2] != -1
    min_right = tree[min_right][1] while min_right != -1 && tree[min_right][1] != -1
    if (max_left != -1 && tree[max_left][0] >= node[0]) || (min_right != -1 && tree[min_right][0] < node[0])
      return false
    end
  end
  true
end

# O(n.height)

# tree = [[4, 1, -1], [2, 2, 3], [1, -1, -1], [5, -1, -1]]

puts is_bst?(tree) ? 'CORRECT' : 'INCORRECT'
