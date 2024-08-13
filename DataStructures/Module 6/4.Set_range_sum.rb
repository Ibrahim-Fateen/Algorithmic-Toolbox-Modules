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
    @height = [left&.height.to_i, right&.height.to_i].max + 1
    @sum = @key + left&.sum.to_i + right&.sum.to_i
    @parent&.update_height_and_sum
  end

  # def sum(l, r)
  #   sum = 0
  #   node = find(l)
  #   while node.key <= r
  #     sum += node.key if node.key >= l
  #     node = node.next
  #   end
  #   sum
  # end

  def sum_range(l, r)
    common_root = first_common_root(l, r)
    exclude = 0

    left_node = common_root.find(l)
    right_node = common_root.find(r)
    while left_node != common_root
      exclude += left_node.parent.sum - left_node.sum unless left_node.parent.left == left_node
      left_node = left_node.parent
    end

    while right_node != common_root
      exclude += right_node.parent.sum - right_node.sum unless right_node.parent.right == right_node
      right_node = right_node.parent
    end
    common_root.sum - exclude
  end

  def add(key)
    parent = find(key)
    if key < parent.key
      parent.left = Node.new(key)
      parent.left.parent = parent
    elsif key > parent.key
      parent.right = Node.new(key)
      parent.right.parent = parent
    end
    # rotate here if necessary??
    parent.update_height_and_sum
  end

  def find(key)
    return self if key == @key

    if key < @key
      return self if @left.nil?

      @left&.find(key)
    else
      return self if @right.nil?

      @right&.find(key)
    end
  end

  def delete_from_tree(key)
    to_delete = find(key)
    return if to_delete.nil? || to_delete.key != key

    to_delete.delete
  end

  def delete
    if @left.nil? && @right.nil?
      if @parent.nil?
        @key = nil
        return
      end
      @parent.left = nil if @parent&.left == self
      @parent.right = nil if @parent&.right == self
    elsif @left.nil?
      @parent.left = @right if @parent&.left == self
      @parent.right = @right if @parent&.right == self
      @right.parent = @parent
    elsif @right.nil?
      @parent.left = @left if @parent&.left == self
      @parent.right = @left if @parent&.right == self
      @left.parent = @parent
    else
      to_swap = successor
      @key = to_swap.key
      to_swap.delete
    end
    @parent&.update_height_and_sum
  end

  def successor
    @left&.max
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

  def first_common_root(left, right)
    root = self
    while root
      if left < root.key && right < root.key
        root = root.left
      elsif left > root.key && right > root.key
        root = root.right
      else
        return root
      end
    end
  end
end

bst_root = nil
M = 1_000_000_001
x = 0
add = lambda do |a|
  if bst_root.nil? || bst_root.key.nil?
    bst_root = Node.new((a + x) % M)
  else
    bst_root.add((a + x) % M)
  end
end

delete = lambda do |a|
  bst_root&.delete_from_tree((a + x) % M)
end

find = lambda do |a|
  if bst_root.nil? || bst_root.key.nil?
    puts 'Not found'
    return
  end
  node = bst_root&.find((a + x) % M)
  if node && node.key == (a + x) % M
    puts 'Found'
  else
    puts 'Not found'
  end
end

sum = lambda do |l, r|
  x = bst_root ? bst_root.sum_range((l + x) % M, (r + x) % M) : x
  puts x
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

