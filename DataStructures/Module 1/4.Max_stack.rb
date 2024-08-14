# frozen_string_literal: true

class Node
  attr_accessor :value, :next

  def initialize(value)
    @value = value
    @next = nil
  end
end

class Stack
  attr_accessor :head

  def initialize
    @head = nil
  end

  def push(value)
    max = @head.nil? ? value : [@head.value, value].max
    node = Node.new(max)
    node.next = @head
    @head = node
  end

  def pop
    return if @head.nil?

    value = @head.value
    @head = @head.next
    value
  end
end

n = gets.to_i
queries = []
n.times do
  queries << gets.chomp.split
end

stack = Stack.new
queries.each do |query|
  case query[0]
  when 'push'
    stack.push(query[1].to_i)
  when 'pop'
    stack.pop
  when 'max'
    puts stack.head.value
  end
end
