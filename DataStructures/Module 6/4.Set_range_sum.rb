# frozen_string_literal: true

class Node
  attr_accessor :key, :left, :right, :parent, :height, :sum

  def initialize(key)
    @key = key
    @left = nil
    @right = nil
    @parent = nil
    @height = 1
    @sum = key
  end

  def update_height_and_sum
    ########## needs work ???
    @height = [left&.height.to_i, right&.height.to_i].max + 1
    @sum = @key + left&.sum.to_i + right&.sum.to_i
    @parent&.update_height_and_sum
  end

  def find(key)
    if key == @key
      splay
      return self
    end

    if key < @key
      if @left.nil?
        splay
        return self
      end

      @left&.find(key)
    else
      if @right.nil?
        splay
        return self
      end

      @right&.find(key)
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
      update_height_and_sum
    end
  end

  def zig
    if @parent.left == self
      @parent.left = @right
      @right = @parent
    else
      @parent.right = @left
      @left = @parent
    end
    @parent.update_height_and_sum
    @parent.parent = self
    @parent = nil
  end

  def zig_zig
    grandparent = @parent.parent
    if grandparent.left == @parent
      b = @right
      c = @parent.right
      d = grandparent.right
      @right = @parent
      @parent.left = b
      @parent.right = grandparent
      grandparent.left = c
      grandparent.right = d
    else
      b = @left
      c = @parent.left
      d = grandparent.left
      @left = @parent
      @parent.left = grandparent
      @parent.right = b
      grandparent.left = d
      grandparent.right = c
    end
    @parent.parent = self
    @parent = grandparent.parent
    grandparent.parent = @parent
    if @parent&.left == grandparent
      @parent.left = self
    else
      @parent.right = self
    end
    grandparent.update_height_and_sum
  end

  def zig_zag
    grandparent = @parent.parent
    c = @left
    d = @right
    if grandparent.left == @parent
      @left = @parent
      @right = grandparent
      grandparent.left = d
      @parent.right = c
    else
      @left = grandparent
      @right = @parent
      grandparent.right = c
      @parent.left = d
    end
    @parent.parent = self
    grandparent.parent = self
    @parent = grandparent.parent
    if @parent&.left == grandparent
      @parent.left = self
    else
      @parent.right = self
    end
    @left.update_height_and_sum
    @right.update_height_and_sum
  end

  def delete_from_tree(key)
    to_delete = find(key)
    return if to_delete.nil? || to_delete.key != key

    to_delete.delete
  end

  def delete
    to_swap = if @left.nil?
                successor_right
              else
                successor_left
              end
    @key = to_swap.key
    to_swap.remove_from_tree
    update_height_and_sum
  end

  def remove_from_tree
    if @parent&.left == self
      @parent.left = @left || @right
    else
      @parent.right = @left || @right
    end
    @parent&.update_height_and_sum
  end

  def successor_left
    @left&.max
  end

  def successor_right
    @right&.min
  end

  def max
    return self if @right.nil?

    @right&.max
  end

  def min
    return self if @left.nil?

    @left&.min
  end

  def next
    return @right&.min if @right

    node = self
    node = node.parent while node.parent && node.parent.right == node
    node.parent
  end
end

class BST
  attr_accessor :root

  def initialize
    @root = nil
  end

  def add(key)
    if @root.nil?
      @root = Node.new(key)
    else
      node = @root.find(key)
      if node.key != key
        new_node = Node.new(key)
        new_node.parent = node
        if key < node.key
          node.left = new_node
        else
          node.right = new_node
        end
      end
      @root = node
      @root.update_height_and_sum
    end
  end

  def find(key)
    node = @root&.find(key)
    @root = node if node
    node
  end

  def delete(key)
    to_delete = find(key)
    return if to_delete.nil? || to_delete.key != key

    if to_delete.left.nil? && to_delete.right.nil?
      @root = nil
    else
      to_delete.delete
      @root = to_delete
    end
  end

  def sum_range(l, r)
    left_node = find(l)
    left_left_tree, left_right_tree = cut_left
    right_node = left_right_tree.find(r)
    right_left_tree, right_right_tree = left_right_tree.cut_right
    sum = right_left_tree.root.sum
    sum -= left_node.key if left_node.key > l
    sum -= right_node.key if right_node.key < r
    @root = merge(left_left_tree, merge(left_right_tree, right_right_tree)).root
    if left_node == right_node
      sum = left_node.key.between?(l, r) ? left_node.key : 0
    end
    sum
  end

  def cut_left
    @root&.left&.parent = nil
    left_root = @root&.left
    @root&.left = nil
    left_bst = BST.new
    left_bst.root = left_root
    [left_bst, self]
  end

  def cut_right
    @root&.right&.parent = nil
    right_root = @root&.right
    @root&.right = nil
    right_bst = BST.new
    right_bst.root = right_root
    [self, right_bst]
  end

  def merge(left_bst, right_bst)
    if left_bst&.root.nil?
      right_bst
    elsif right_bst&.root.nil?
      left_bst
    else
      right_bst.root.find(-Float::INFINITY)
      right_bst.root.left = left_bst.root
      right_bst.root.update_height_and_sum
      right_bst
  end
  end
end

bst = BST.new
M = 1_000_000_001
x = 0
add = lambda do |a|
  bst.add((a + x) % M)
end

delete = lambda do |a|
  bst.delete((a + x) % M)
end

find = lambda do |a|
  node = bst.find((a + x) % M)
  if node && node.key == (a + x) % M
    puts 'Found'
  else
    puts 'Not found'
  end
end

sum = lambda do |l, r|
  x = bst.root ? bst.sum_range((l + x) % M, (r + x) % M) : x
  puts x
end # test thissssss, and test x

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
