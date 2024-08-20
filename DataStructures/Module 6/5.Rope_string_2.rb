# frozen_string_literal: true

# class Node
#   attr_accessor :key, :index, :left, :right, :parent
#
#   def initialize(key, index)
#     @key = key
#     @index = index
#     @left = nil
#     @right = nil
#     @parent = nil
#   end
#
#   def to_s
#     @key
#   end
#
#   def find(index)
#     current = self
#     while current
#       return current if current.index == index
#
#       if index < current.index
#         return current if current.left.nil?
#
#         current = current.left
#       else
#         return current if current.right.nil?
#
#         current = current.right
#       end
#     end
#   end
#
#   def update_index
#     @index = (predecessor&.index || -1) + 1
#     _next = successor
#     last_index = @index
#     while _next
#       _next.index = last_index + 1
#       last_index = _next.index
#       _next = _next.successor
#     end
#   end
#
#   def predecessor
#     return @left.max if @left
#
#     current = self
#     while current.parent
#       return current.parent if current.parent.right == current
#
#       current = current.parent
#     end
#     current.parent
#   end
#
#   def successor
#     return @right.min if @right
#
#     current = self
#     while current.parent
#       return current.parent if current.parent.left == current
#
#       current = current.parent
#     end
#     current.parent
#   end
#
#   def max
#     current = self
#     current = current.right while current.right
#     current
#   end
#
#   def min
#     current = self
#     current = current.left while current.left
#     current
#   end
#
#   def splay
#     while @parent
#       if @parent.parent.nil?
#         zig
#       elsif @parent.left == self && @parent.parent.left == @parent
#         zig_zig
#       elsif @parent.right == self && @parent.parent.right == @parent
#         zig_zig
#       else
#         zig_zag
#       end
#     end
#   end
#
#   def zig
#     a = @left
#     b = @right
#     parent = @parent
#     if parent.left == self
#       @right = parent
#       parent.left = b
#       b&.parent = parent
#     else
#       @left = parent
#       parent.right = a
#       a&.parent = parent
#     end
#     @parent = nil
#     parent.parent = self
#   end
#
#   def zig_zig
#     parent = @parent
#     grandparent = parent.parent
#     root = grandparent.parent
#     if grandparent.left == parent
#       b = @right
#       c = parent.right
#       grandparent.left = c
#       c&.parent = grandparent
#       parent.left = b
#       b&.parent = parent
#       @right = parent
#       parent.right = grandparent
#     else
#       b = parent.left
#       c = @left
#       grandparent.right = b
#       b&.parent = grandparent
#       parent.right = c
#       c&.parent = parent
#       @left = parent
#       parent.left = grandparent
#     end
#     grandparent.parent = parent
#     parent.parent = self
#     @parent = root
#     return unless root
#
#     @parent.left == grandparent ? @parent.left = self : @parent.right = self
#   end
#
#   def zig_zag
#     parent = @parent
#     grandparent = parent.parent
#     root = grandparent.parent
#     a = @left
#     b = @right
#     if parent.left == self
#       grandparent.right = a
#       a&.parent = grandparent
#       parent.left = b
#       b&.parent = parent
#       @left = grandparent
#       @right = parent
#     else
#       grandparent.left = b
#       b&.parent = grandparent
#       parent.right = a
#       a&.parent = parent
#       @right = grandparent
#       @left = parent
#     end
#     grandparent.parent = self
#     parent.parent = self
#     @parent = root
#     return unless root
#
#     @parent.left == grandparent ? @parent.left = self : @parent.right = self
#   end
# end
#
# class Rope
#   attr_accessor :root
#
#   def initialize
#     @root = nil
#   end
#
#   def build_rope(string)
#     nodes = string.chars.map.with_index { |char, index| Node.new(char, index) }
#     nodes.each_cons(2) { |parent, child| child.parent = parent; parent.right = child }
#     @root = nodes.first
#   end
#
#   def to_s
#     result = in_order_traversal
#     result.join
#   end
#
#   def in_order_traversal
#     result = []
#     stack = []
#     current = @root
#     while current || !stack.empty?
#       while current
#         stack << current
#         current = current.left
#       end
#       current = stack.pop
#       result << current.key
#       current = current.right
#     end
#     result
#   end
#
#   def find(index)
#     node = @root&.find(index)
#     node&.splay
#     @root = node
#   end
#
#   def cut_left
#     left_rope = Rope.new
#     right_rope = Rope.new
#     left_rope.root = @root.left
#     right_rope.root = @root
#     left_rope.root&.parent = nil
#     right_rope.root.left = nil
#     [left_rope, right_rope]
#   end
#
#   def cut_right
#     left_rope = Rope.new
#     right_rope = Rope.new
#     left_rope.root = @root
#     right_rope.root = @root.right
#     left_rope.root.right = nil
#     right_rope.root&.parent = nil
#     [left_rope, right_rope]
#   end
#
#   def merge(left_rope, right_rope, at_start: false, final_merge: false)
#     return left_rope if right_rope.root.nil?
#
#     if left_rope.root.nil?
#       right_rope.root.update_index
#       return right_rope
#     end
#
#     if final_merge
#       if at_start
#         right_rope.root.right = left_rope.root
#         left_rope.root.parent = right_rope.root
#         right_rope.root.min.update_index
#         return right_rope
#       end
#       old_right = left_rope.root.right
#       left_rope.root.right = right_rope.root
#       right_rope.root.parent = left_rope.root
#       right_rope.root.right = old_right
#       old_right&.parent = right_rope.root
#     else
#       left_rope.find(Float::INFINITY)
#       left_rope.root.right = right_rope.root
#       right_rope.root.parent = left_rope.root
#     end
#     left_rope.root.update_index
#     left_rope
#   end
#
#   def reposition(i, j, k)
#     find(i)
#     left_i, right_i = cut_left
#     right_i.find(j)
#     left_j, right_j = right_i.cut_right
#     rope = merge(left_i, right_j)
#     rope.find(k - 1)
#     @root = merge(rope, left_j, at_start: k.zero?, final_merge: true).root
#   end
# end
#
# def word_after_commands(string, commands)
#   rope = Rope.new
#   rope.build_rope(string)
#   commands.each do |i, j, k|
#     rope.reposition(i, j, k)
#   end
#   rope
# end

def word_after_commands_naive(string, commands)
  commands.each do |i, j, k|
    substring = string[i..j]
    string = string[0...i] + string[(j + 1)..]
    string = if k.zero?
               substring + string
             else
               string[0...k] + substring + string[k..]
             end
  end
  string
end

string = gets.chomp
n = gets.chomp.to_i
commands = []
n.times do
  commands << gets.chomp.split.map(&:to_i)
end

puts word_after_commands_naive(string, commands)

# string = 'hello'
# commands = [
#   [0, 1, 2],
#   [2, 3, 0],
#   [1, 4, 0]
# ]
#
# puts word_after_commands(string, commands)

# string = gets.chomp
# rope = Rope.new
# rope.build_rope(string)
# puts rope
# string.length.times { |i| print i }
# puts
# while (i, j, k = gets.chomp.split.map(&:to_i))
#   rope.reposition(i, j, k)
#   puts rope
#   string.length.times { |i| print i }
#   puts
# end

# basic_tests = [
#   { string: 'hello', commands: [[0, 1, 2], [2, 3, 0], [1, 4, 0]] },
#   { string: 'abcdef', commands: [[0, 2, 3], [1, 4, 1], [2, 5, 0]] }
# ]
#
# edge_tests = [
#   { string: 'a', commands: [[0, 0, 0]] },
#   { string: 'abc', commands: [[0, 2, 0], [1, 2, 1]] }
# ]
#
# large_string = 'a' * 1000
# i = rand(0..999)
# j = rand(i..999)
# k = rand(0..(1000 - (j - i + 1)))
# large_commands = Array.new(100) { [i, j, k] }
# large_tests = [{ string: large_string, commands: large_commands }]
#
# random_tests = Array.new(100) do
#   size = rand(1..300_000)
#   string = (1..size).map { ('a'..'z').to_a[rand(26)] }.join
#   commands = Array.new(rand(1..100_000)) do
#     i = rand(0..(size - 1))
#     j = rand(i..(size - 1))
#     k = rand(0..(size - (j - i + 1)))
#     [i, j, k]
#   end
#   { string: string, commands: commands }
# end
#
# all_tests = basic_tests + edge_tests + large_tests + random_tests
#
# # Run all tests
# all_tests.each_with_index do |test, index|
#   puts "Test Case ##{index + 1}"
#   puts "String: #{test[:string]}"
#   expected = word_after_commands_naive(test[:string], test[:commands])
#   puts "Expected: #{expected}"
#   start_time = Time.now
#   result = word_after_commands(test[:string], test[:commands])
#   end_time = Time.now
#   puts "Result: #{result}"
#   puts "Time: #{end_time - start_time} seconds"
#   puts result.to_s == expected ? 'Passed' : 'Failed'
#   break unless result.to_s == expected
#
#   puts '----------------------'
#   sleep(2)
# end
