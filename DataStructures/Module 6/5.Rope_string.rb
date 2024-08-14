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

  def update_index
    # Call when merging???
    @index = successor.index + 1
    next_&.update_index
  end

  def successor
    if @left
      @left.max
    else
      parent = self
      parent = parent.parent while parent.parent && parent.parent.right == parent
      parent
    end
  end

  def next_
    if @right
      @right.min
    else
      parent = self
      parent = parent.parent while parent.parent && parent.parent.left == parent
      parent
    end
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

  def find(index)
    if index == @index
      self
    elsif index < @index
      @left.find(index)
    else
      @right.find(index)
    end
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
    if @parent.left == self
      @parent.left = @right
      @right = @parent
      @right.parent = self
    elsif @parent.right == self
      @parent.right = @left
      @left = @parent
      @left.parent = self
    end
    @parent = nil
  end

  def zig_zig
    grandparent = @parent.parent
    if grandparent.left == @parent
      b = @right
      c = @parent.right
      grandparent.left = c
      @parent.left = b
      @parent.right = grandparent
      @parent.parent = self
      @parent, grandparent.parent = grandparent.parent, @parent
      @parent&.left == grandparent ? @parent&.left = self : @parent&.right = self
      @right = grandparent.parent
    else
      b = @left
      c = @parent.left
      grandparent.right = c
      @parent.right = b
      @parent.left = grandparent
      @parent.parent = self
      @parent, grandparent.parent = grandparent.parent, @parent
      @parent&.left == grandparent ? @parent&.left = self : @parent&.right = self
      @left = grandparent.parent
    end
  end

  def zig_zag
    grandparent = @parent.parent
    if grandparent.left == @parent
      a = @left
      b = @right
      @left = @parent
      @right = grandparent
      @parent = grandparent.parent
      grandparent.parent = self
      @left.parent = self
      @left.right = a
      grandparent.left = b
      @parent&.left == grandparent ? @parent.left = self : @parent.right = self
    else
      a = @left
      b = @right
      @left = grandparent
      @right = @parent
      @parent = grandparent.parent
      grandparent.parent = self
      @right.parent = self
      @right.left = b
      grandparent.right = a
      @parent&.left == grandparent ? @parent.left = self : @parent.right = self
    end
  end
end

class SplayTree
  attr_accessor :root
  def initialize
    @root = nil
  end

  def insert(node)
    if @root.nil?
      @root = node
    else
      current = @root
      current = current.right while current.right
      current.right = node
      node.parent = current
    end
  end

  def splay(index)
    return if @root.nil?

    current = @root.find(index)
    current.splay
    @root = current
  end

  def cut_left
    left = @root.left
    @root.left = nil
    left&.parent = nil
    st = SplayTree.new
    st.root = left
    [st, self]
  end

  def cut_right
    right = @root.right
    @root.right = nil
    right&.parent = nil
    st = SplayTree.new
    st.root = right
    [self, st]
  end

  def merge(left, right)
    return left if right.nil?
    return right if left.nil?

    current = left.root
    current = current.right while current.right
    current.right = right.root
    right.root.parent = current
    right.root.update_index
    left
  end

  def swap(i, j, k)
    splay(i)
    left_i, right_i = cut_left
    right_i.splay(j)
    left_j, right_j = cut_right
    tree = merge(left_i, right_j)
    tree.splay(k)
    @root = merge(tree, left_j)&.root
  end

  def to_s
    # in order traversal
    result = []
    stack = []
    current = @root
    while current || !stack.empty?
      while current
        stack << current
        current = current.left
      end
      current = stack.pop
      result << current.key
      current = current.right
    end
    result.join
  end
end

string = gets.chomp
n = gets.chomp.to_i
commands = []
n.times do
  commands << gets.chomp.split.map(&:to_i)
end

puts word_after_commands(string, commands)

def word_after_commands(string, commands)
  tree = SplayTree.new
  string.each_char.with_index { |char, index| tree.insert(Node.new(char, index)) }
  commands.each do |i, j, k|
    tree.swap(i, j, k)
  end
  tree
end
