# frozen_string_literal: true

class Node
  attr_accessor :value, :next, :prev

  def initialize(value)
    @value = value
    @next = nil
    @prev = nil
  end
end

def hash(string, m)
  x = 263
  p = 1_000_000_007
  sum = 0
  string.each_char.with_index do |char, i|
    sum += char.ord * x**i
  end
  sum % p % m
end

def process_queries(m, queries)
  hash_table = Array.new(m)

  find = lambda do |string|
    index = hash(string, m)
    node = hash_table[index]
    found = false
    while node
      if node.value == string
        found = true
        break
      end
      node = node.next
    end
    found
  end

  add = lambda do |string|
    index = hash(string, m)
    if hash_table[index].nil?
      hash_table[index] = Node.new(string)
    else
      unless find.call(string)
        node = Node.new(string)
        node.next = hash_table[index]
        node.next.prev = node
        hash_table[index] = node
      end
    end
  end

  del = lambda do |string|
    index = hash(string, m)
    node = hash_table[index]
    while node
      if node.value == string
        if node.prev.nil?
          hash_table[index] = node.next
          node.next.prev = nil if node.next
        else
          node.prev.next = node.next
          node.next.prev = node.prev if node.next
        end
        break
      end
      node = node.next
    end
  end

  check = lambda do |index|
    node = hash_table[index]
    while node
      print "#{node.value} "
      node = node.next
    end
    puts
  end

  queries.each do |query|
    case query[0]
    when 'add'
      add.call(query[1])
    when 'del'
      del.call(query[1])
    when 'find'
      find.call(query[1]) ? puts('yes') : puts('no')
    when 'check'
      check.call(query[1].to_i)
    end
  end
end

m = gets.to_i
n = gets.to_i
queries = []
n.times do
  queries << gets.split
end
process_queries(m, queries)
