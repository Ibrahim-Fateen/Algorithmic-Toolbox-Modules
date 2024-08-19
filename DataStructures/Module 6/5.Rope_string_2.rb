# frozen_string_literal: true

class Node
  attr_accessor :key, :index, :left, :right, :parent

  def initialize(key, index)
    @key = key
    @index = index
    @left = nil
    @right = nil
    @parent = nil
  end

  def to_s
    @key
  end

  def find(index)
    if index == @index
      self
    elsif index < @index
      return self if @left.nil?

      @left&.find(index)
    else
      return self if @right.nil?

      @right&.find(index)
    end
  end

  def update_index
    @index = (predecessor&.index || -1) + 1
    successor&.update_index
  end

  def predecessor
    return @left.max if @left

    current = self
    while current.parent
      return current.parent if current.parent.right == current

      current = current.parent
    end
    current.parent
  end

  def successor
    return @right.min if @right

    current = self
    while current.parent
      return current.parent if current.parent.left == current

      current = current.parent
    end
    current.parent
  end

  def max
    current = self
    current = current.right while current.right
    current
  end

  def min
    current = self
    current = current.left while current.left
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
    return unless root

    @parent.left == grandparent ? @parent.left = self : @parent.right = self
  end
end

class Rope
  attr_accessor :root

  def initialize
    @root = nil
  end

  def build_rope(string)
    nodes = string.chars.map.with_index { |char, index| Node.new(char, index) }
    nodes.each_cons(2) { |parent, child| child.parent = parent; parent.right = child }
    @root = nodes.first
  end

  def to_s
    result = []
    in_order_traversal(@root, result)
    result.join
  end

  def in_order_traversal(node, result)
    return unless node

    in_order_traversal(node.left, result)
    result << node.key
    in_order_traversal(node.right, result)
  end

  def find(index)
    node = @root.find(index)
    node.splay
    @root = node
  end

  def cut_left
    left_rope = Rope.new
    right_rope = Rope.new
    left_rope.root = @root.left
    right_rope.root = @root
    left_rope.root&.parent = nil
    right_rope.root.left = nil
    [left_rope, right_rope]
  end

  def cut_right
    left_rope = Rope.new
    right_rope = Rope.new
    left_rope.root = @root
    right_rope.root = @root.right
    left_rope.root.right = nil
    right_rope.root&.parent = nil
    [left_rope, right_rope]
  end

  def merge(left_rope, right_rope, at_start: false, final_merge: false)
    return left_rope if right_rope.root.nil?
    if left_rope.root.nil?
      right_rope.root.update_index
      return right_rope
    end

    if final_merge
      if at_start
        right_rope.root.right = left_rope.root
        left_rope.root.parent = right_rope.root
        left_rope.root.update_index
        return right_rope
      end
      old_right = left_rope.root.right
      left_rope.root.right = right_rope.root
      right_rope.root.parent = left_rope.root
      right_rope.root.right = old_right
      old_right&.parent = right_rope.root
    else
      left_rope.find(Float::INFINITY)
      left_rope.root.right = right_rope.root
      right_rope.root.parent = left_rope.root
    end
    left_rope.root.update_index
    left_rope
  end

  def reposition(left_index, right_index, k)
    find(left_index)
    left_left_rope, left_right_rope = cut_left
    left_right_rope.find(right_index)
    right_left_rope, right_right_rope = left_right_rope.cut_right
    rope = merge(left_left_rope, right_right_rope)
    rope.find(k - 1)
    @root = merge(rope, right_left_rope, at_start: k.zero?, final_merge: true).root
  end
end

def word_after_commands(string, commands)
  rope = Rope.new
  rope.build_rope(string)
  commands.each do |i, j, k|
    rope.reposition(i, j, k)
  end
  rope
end

string = gets.chomp
n = gets.chomp.to_i
commands = []
n.times do
  commands << gets.chomp.split.map(&:to_i)
end
puts word_after_commands(string, commands)

# string = 'abcdef'
# commands = [
#   [0, 0, 5],
#   [4, 4, 5],
#   [5, 5, 0]
# ]

# puts word_after_commands(string, commands)
