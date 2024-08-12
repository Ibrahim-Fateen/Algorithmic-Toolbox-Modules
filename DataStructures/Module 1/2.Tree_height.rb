# frozen_string_literal: true
class Node
  attr_accessor :value, :children

  def initialize(value)
    @value = value
    @children = []
  end

  def add_child(child)
    @children << child
  end
end

def tree_height(n, parents)
  nodes = []
  n.times { |i| nodes << Node.new(i) }
  root = nil
  parents.each_with_index do |parent, i|
    if parent == -1
      root = nodes[i]
    else
      nodes[parent].add_child(nodes[i])
    end
  end

  height = 0
  queue = [root]
  until queue.empty?
    height += 1
    queue.size.times do
      node = queue.shift
      node.children.each { |child| queue << child }
    end
  end
  height
end

n = gets.chomp.to_i
parents = gets.chomp.split.map(&:to_i)
puts tree_height(n, parents)
