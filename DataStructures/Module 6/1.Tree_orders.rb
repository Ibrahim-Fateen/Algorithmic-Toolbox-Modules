# frozen_string_literal: true

n = gets.to_i
tree = Array.new(n) { [] }
n.times do |i|
  tree[i] = gets.split.map(&:to_i)
end

def in_order(tree)
  stack = []
  current = 0
  while current != -1 || !stack.empty?
    while current != -1
      stack.push(current)
      current = tree[current][1]
    end
    current = stack.pop
    print "#{tree[current][0]} "
    current = tree[current][2]
  end
  puts
end

def pre_order(tree)
  stack = []
  current = 0
  while current != -1 || !stack.empty?
    while current != -1
      print "#{tree[current][0]} "
      stack.push(current)
      current = tree[current][1]
    end
    current = stack.pop
    current = tree[current][2]
  end
  puts
end

def post_order(tree)
  stack = []
  current = 0
  checked_left = Array.new(tree.size, false)
  checked_right = Array.new(tree.size, false)

  stack.push(current)
  until stack.empty?
    current = stack.pop
    if current != -1
      if !checked_left[current]
        stack.push(current)
        checked_left[current] = true
        stack.push(tree[current][1])
      elsif !checked_right[current]
        stack.push(current)
        checked_right[current] = true
        stack.push(tree[current][2])
      else
        print "#{tree[current][0]} "
      end
    end
  end
  puts
end

in_order(tree)
pre_order(tree)
post_order(tree)
