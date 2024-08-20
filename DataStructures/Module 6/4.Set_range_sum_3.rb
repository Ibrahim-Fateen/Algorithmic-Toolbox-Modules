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

  def update_height_and_sum
    @height = [left&.height || 0, right&.height || 0].max + 1
    @sum = (left&.sum || 0) + (right&.sum || 0) + @value
    @parent&.update_height_and_sum
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

  def successor
    current = @right
    current = current.left while current.left
    current
  end

  def to_s
    "Node: #{@value}, Sum: #{@sum}, Height: #{@height}"
  end
end

class Tree
  attr_accessor :root
  def initialize
    @root = nil
  end

  def add(value)
    return @root = Node.new(value) if @root.nil?

    node = @root.find(value)
    return if node.value == value

    new_node = Node.new(value)
    if value < node.value
      node.left = new_node
    else
      node.right = new_node
    end
    node.update_height_and_sum
    new_node.parent = node
    while node
      rebalance(node)
      node = node.parent
    end
  end

  def find(value)
    return nil if @root.nil?

    @root.find(value)
  end

  def AVL_delete(value)
    parent = delete(value)
    rebalance(parent) if parent
  end

  def delete(value)
    node = find(value)

    return if node.nil? || node.value != value

    parent = node.parent
    if node.left.nil? && node.right.nil?
      if parent
        parent.left == node ? parent.left = nil : parent.right = nil
        parent.update_height_and_sum
      else
        @root = nil
      end
      return parent
    end

    if node.right.nil?
      # promote left child
      node.left.parent = parent
      if parent
        parent.left == node ? parent.left = node.left : parent.right = node.left
        parent.update_height_and_sum
      else
        @root = node.left
        @root.parent = nil
      end
      return parent
    end

    successor = node.successor
    successor_parent = successor.parent
    node.value = successor.value
    successor.right&.parent = successor_parent
    successor_parent == node ? successor_parent.right = successor.right : successor_parent.left = successor.right
    successor_parent.update_height_and_sum
    successor_parent
  end

  def sum_range(l, r)
    return 0 if @root.nil?

    queue = [@root]
    sum = 0
    until queue.empty?
      node = queue.shift
      next if node.nil?

      if node.value < l
        queue.push(node.right)
      elsif node.value > r
        queue.push(node.left)
      else
        sum += node.value
        if (l..r).include?(node.parent&.value)
          if node.value > node.parent.value
            sum += node.left&.sum || 0
            queue.push(node.right)
          else
            sum += node.right&.sum || 0
            queue.push(node.left)
          end
        else
          queue.push(node.left)
          queue.push(node.right)
        end
      end
    end
    sum
  end

  def rebalance(node)
    return if ((node.left&.height || 0) - (node.right&.height || 0)).abs <= 1

    parent = node.parent
    rebalance_right(node) if (node.left&.height || 0) > (node.right&.height || 0) + 1
    rebalance_left(node) if (node.right&.height || 0) > (node.left&.height || 0) + 1
    rebalance(parent) if parent
  end

  def rebalance_right(node)
    m = node.left
    rotate_left(m) if (m.right&.height || 0) > (m.left&.height || 0)
    rotate_right(node)
  end

  def rebalance_left(node)
    m = node.right
    rotate_right(m) if (m.left&.height || 0) > (m.right&.height || 0)
    rotate_left(node)
  end

  def rotate_right(node)
    root = node.parent
    left = node.left
    b = left.right
    left.right = node
    node.parent = left
    node.left = b
    b&.parent = node
    left.parent = root
    if root
      if root.left == node
        root.left = left
      else
        root.right = left
      end
    else
      @root = left
    end
    node.update_height_and_sum
  end

  def rotate_left(node)
    root = node.parent
    right = node.right
    c = right.left
    right.left = node
    node.parent = right
    node.right = c
    c&.parent = node
    right.parent = root
    if root
      if root.left == node
        root.left = right
      else
        root.right = right
      end
    else
      @root = right
    end
    node.update_height_and_sum
  end
end

tree = Tree.new
M = 1_000_000_001
x = 0

add = lambda do |a|
  tree.add((a + x) % M)
  # tree.add(a)
end

delete = lambda do |a|
  tree.AVL_delete((a + x) % M)
  # tree.delete(a)
end

find = lambda do |a|
  node = tree.find((a + x) % M)
  puts node&.value == (a + x) % M ? 'Found' : 'Not found'
  # node = tree.find(a)
  # puts node&.value == a ? 'Found' : 'Not found'
end

sum = lambda do |l, r|
  x = tree.sum_range((l + x) % M, (r + x) % M)
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
