# frozen_string_literal: true

class Node
  attr_accessor :value, :left, :right, :parent, :height, :sum

  def initialize(value)
    @value = value
    @left = nil
    @right = nil
    @parent = nil
    @height = 1
    @sum = value
  end

  def find(value)
    return self if value == @value

    if value < @value
      return self if @left.nil?

      @left.find(value)
    else
      return self if @right.nil?

      @right.find(value)
    end
  end

  def to_swap_with
    current = nil
    if @left
      current = @left
      current = current.right while current.right
    elsif @right
      current = @right
      current = current.left while current.left
    end
    current
  end

  def splay
    while @parent
      if @parent.parent.nil?
        zig
      elsif @parent.left == self && @parent.parent.left == @parent
        zig_zig
      elsif @parent.right == self && @parent.parent.right == @parent
        zig_zig
      else
        zig_zag
      end
    end
  end

  def zig
    a = @left
    b = @right
    parent = @parent
    if parent.left == self
      @right = parent
      parent.left = b
      b&.parent = parent
    else
      @left = parent
      parent.right = a
      a&.parent = parent
    end
    @parent = nil
    parent.parent = self
    parent.update_height_and_sum
  end

  def zig_zig
    parent = @parent
    grandparent = parent.parent
    root = grandparent.parent
    if grandparent.left == parent
      b = @right
      c = parent.right
      grandparent.left = c
      c&.parent = grandparent
      parent.left = b
      b&.parent = parent
      @right = parent
      parent.right = grandparent
    else
      b = parent.left
      c = @left
      grandparent.right = b
      b&.parent = grandparent
      parent.right = c
      c&.parent = parent
      @left = parent
      parent.left = grandparent
    end
    grandparent.parent = parent
    parent.parent = self
    @parent = root
    grandparent.update_height_and_sum
    return unless root

    @parent.left == grandparent ? @parent.left = self : @parent.right = self
  end

  def zig_zag
    parent = @parent
    grandparent = parent.parent
    root = grandparent.parent
    a = @left
    b = @right
    if parent.left == self
      grandparent.right = a
      a&.parent = grandparent
      parent.left = b
      b&.parent = parent
      @left = grandparent
      @right = parent
    else
      grandparent.left = b
      b&.parent = grandparent
      parent.right = a
      a&.parent = parent
      @right = grandparent
      @left = parent
    end
    grandparent.parent = self
    parent.parent = self
    @parent = root
    parent.update_height_and_sum
    grandparent.update_height_and_sum
    return unless root

    @parent.left == grandparent ? @parent.left = self : @parent.right = self
  end

  def update_height_and_sum
    @height = 1 + [left&.height.to_i, right&.height.to_i].max
    @sum = @value + left&.sum.to_i + right&.sum.to_i
    @parent&.update_height_and_sum
  end

  def to_s
    "Node: #{@value}, Sum: #{@sum}, Height: #{@height}"
  end
end

class SplayTree
  attr_accessor :root

  def initialize
    @root = nil
  end

  def add(value)
    if @root.nil?
      @root = Node.new(value)
      return
    end

    parent = @root.find(value)
    return if parent.value == value

    node = Node.new(value)
    node.parent = parent
    if parent.value > value
      parent.left = node
    else
      parent.right = node
    end
    node.splay
    @root = node
  end

  def find(value)
    node = @root&.find(value)
    node&.splay
    @root = node
  end

  def delete(value)
    return if @root.nil?

    node = find(value)
    return if node.value != value

    to_swap_with = node.to_swap_with
    if to_swap_with
      if to_swap_with.value < node.value
        # make sure not in the first generation
        if to_swap_with.parent == node
          node.left = to_swap_with.left
          to_swap_with.left&.parent = node
        else
          to_swap_with.parent.right = to_swap_with.left
          to_swap_with.left&.parent = to_swap_with.parent
        end
      else
        # make sure not in the first generation
        if to_swap_with.parent == node
          node.right = to_swap_with.right
          to_swap_with.right&.parent = node
        else
          to_swap_with.parent.left = to_swap_with.right
          to_swap_with.right&.parent = to_swap_with.parent
        end
      end
      node.value = to_swap_with.value
      to_swap_with.parent.update_height_and_sum
    else
      @root = nil
    end
  end

  def sum_range(l, r)
    left_node = find(l)
    left_left_tree, left_right_tree = cut_left
    right_node = left_right_tree.find(r)
    right_left_tree, right_right_tree = left_right_tree.cut_right
    sum = right_left_tree.root.sum
    sum -= left_node.value if left_node.value < l
    sum -= right_node.value if right_node.value > r
    @root = merge(left_left_tree, merge(right_left_tree, right_right_tree, left_has_no_right: true)).root
    sum
  end

  def cut_left
    left_tree = SplayTree.new
    right_tree = SplayTree.new
    left_tree.root = @root.left
    right_tree.root = @root
    left_tree.root&.parent = nil
    right_tree.root&.left = nil
    right_tree.root&.update_height_and_sum
    [left_tree, right_tree]
  end

  def cut_right
    left_tree = SplayTree.new
    right_tree = SplayTree.new
    left_tree.root = @root
    right_tree.root = @root.right
    left_tree.root&.right = nil
    right_tree.root&.parent = nil
    left_tree.root&.update_height_and_sum
    [left_tree, right_tree]
  end

  def merge(left_tree, right_tree, left_has_no_right: false)
    return right_tree if left_tree.root.nil?
    return left_tree if right_tree.root.nil?

    if left_has_no_right
      left_tree.root.right = right_tree.root
      right_tree.root.parent = left_tree.root
      left_tree.root.update_height_and_sum
      return left_tree
    end

    left_tree.find(Float::INFINITY)
    merge(left_tree, right_tree, left_has_no_right: true)
  end
end

tree = SplayTree.new
M = 1_000_000_001
x = 0

add = lambda do |a|
  tree.add((a + x) % M)
  # tree.add(a)
end

delete = lambda do |a|
  tree.delete((a + x) % M)
  # tree.delete(a)
end

find = lambda do |a|
  node = tree.find((a + x) % M)
  puts node&.value == (a + x) % M ? 'Found' : 'Not found'
  # node = tree.find(a)
  # puts node&.value == a ? 'Found' : 'Not found'
end

sum = lambda do |l, r|
  x = tree.root ? tree.sum_range((l + x) % M, (r + x) % M) : 0
  puts x
  # puts tree.root ? tree.sum_range(l, r) : 0
end

n = gets.to_i
n.times do
  query = gets.chomp.split
  case query[0]
  when '+'
    add.call(query[1].to_i)
  when '-'
    delete.call(query[1].to_i)
  when '?'
    find.call(query[1].to_i)
  when 's'
    sum.call(query[1].to_i, query[2].to_i)
  end
end

# commands = [
#   ['+', 1],
#   ['+', 2],
#   ['+', 3],
#   ['+', 5],
#   ['+', 4],
#   ['+', 7],
#   ['s', 9, 10],
#   ['s', 1, 7],
#   ['?', -19],
#   ['s', 1, 10],
#   ['?', 1],
#   ['-', 1],
#   ['?', 1],
#   ['?', 2],
#   ['-', 2],
#   ['?', 2],
#   ['-', 3],
#   ['-', 5],
#   ['-', 4],
#   ['-', 7],
#   ['s', 9, 10],
#   ['s', 1, 7],
#   ['?', -19],
#   ['?', 1], # find when empty
#   ['-', 1], # delete when empty
#   ['+', 1], # restart all operations
#   ['?', 1],
#   ['+', 2],
#   ['+', 3],
#   ['+', 5],
#   ['+', 4],
#   ['+', 7],
#   ['s', 9, 10],
#   ['s', 1, 7],
#   ['?', -19],
#   ['s', 1, 10],
#   ['?', 1],
#   ['-', 1],
#   ['?', 1],
#   ['?', 2],
#   ['-', 2],
#   ['?', 2],
#   ['-', 3],
#   ['-', 5],
#   ['-', 4],
#   ['-', 7],
#   ['s', 9, 10],
#   ['s', 1, 7],
#   ['?', -19],
#   ['?', 1],
#   ['-', 1],
#   ['+', 1],
#   ['?', 1]
# ]
#
# commands.each do |command|
#   case command[0]
#   when '+'
#     add.call(command[1])
#   when '-'
#     delete.call(command[1])
#   when '?'
#     find.call(command[1])
#   when 's'
#     sum.call(command[1], command[2])
#   end
# end
