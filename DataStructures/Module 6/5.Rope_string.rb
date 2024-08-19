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
    @index = (predecessor&.index || -1) + 1
    next_&.update_index
  end

  def predecessor
    if @left
      @left.max
    else
      current = self
      while current.parent
        return current.parent if current.parent.right == current

        current = current.parent
      end
      current.parent
    end
  end

  def next_
    if @right
      @right.min
    else
      parent = self
      parent = parent.parent while parent.parent && parent.parent.left == parent
      parent unless parent == self
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
    root = @parent
    a = @left
    b = @right
    if root.left == self
      @right = root
      root.left = b
      b&.parent = root
    else
      @left = root
      root.right = a
      a&.parent = root
    end
    root.parent = self
    @parent = nil
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

    root.left == grandparent ? root.left = self : root.right = self
  end

  def zig_zag
    parent = @parent
    grandparent = parent.parent
    root = grandparent.parent
    if parent.left == self
      a = @left
      b = @right
      grandparent.right = a
      a&.parent = grandparent
      parent.left = b
      b&.parent = parent
      @left = grandparent
      @right = parent
    else
      a = @left
      b = @right
      grandparent.left = b
      b&.parent = grandparent
      parent.right = a
      a&.parent = parent
      @left = parent
      @right = grandparent
    end
    grandparent.parent = self
    parent.parent = self
    @parent = root
    return unless root

    root.left == grandparent ? root.left = self : root.right = self
  end

  def to_s
    @key
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

    current = index == -1 ? @root.min : @root.find(index)
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

  def merge(left, right, final_merge: false, at_start: false)
    if left.nil? || left.root.nil?
      right.root.min.update_index
      return right
    end
    if right.nil? || right.root.nil?
      left.root.min.update_index
      return left
    end

    if final_merge
      if at_start
        right.root.right = left.root
        left.root.parent = right.root
        right.root.min.update_index
        return right
      end
      right.root.right = left.root.right
      right.root.right&.parent = right.root
      left.root.right = right.root
      right.root.parent = left.root
    else
      current = left.root.max
      # current = current.right while current&.right
      right.root&.parent = current
      current.right = right.root
    end
    right.root.min.update_index
    left
  end

  def swap(i, j, k)
    splay(i)
    left_i, right_i = cut_left
    right_i.splay(j)
    left_j, right_j = right_i.cut_right
    tree = merge(left_i, right_j)
    tree.splay(k - 1)
    @root = merge(tree, left_j, final_merge: true, at_start: k.zero?).root
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

# string = gets.chomp
# n = gets.chomp.to_i
# commands = []
# n.times do
#   commands << gets.chomp.split.map(&:to_i)
# end

# string = "hlelowrold"
# commands = [[1, 1, 2], [6, 6, 7]]
# string = 'abcdef'
# commands = [[0, 1, 1], [4, 5, 0]]
# string = 'abcdef'
# commands = [[0, 0, 5], [4, 4, 5], [5, 5, 0]]
# string = 'birhmai'
# commands = [[1, 1, 0], [5, 6, 3], [4, 4, 5]]

string = 'The quick brown fox jumps over the lazy dog.'
commands = [[1, 2, 4], [5, 5, 0], [9, 12, 4], [20, 25, 0]]

def word_after_commands(string, commands)
  tree = SplayTree.new
  string.each_char.with_index { |char, index| tree.insert(Node.new(char, index)) }
  commands.each do |i, j, k|
    tree.swap(i, j, k)
  end
  tree
end

puts word_after_commands(string, commands)


