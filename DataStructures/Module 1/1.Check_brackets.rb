# frozen_string_literal: true

def check_brackets(string)
  stack = []
  string.each_char.with_index do |char, i|
    if char == '(' || char == '[' || char == '{'
      stack.push([char, i])
    elsif char == ')' || char == ']' || char == '}'
      return i + 1 if stack.empty?

      last = stack.pop
      return i + 1 if (last[0] == '(' && char != ')') || (last[0] == '[' && char != ']') || (last[0] == '{' && char != '}')
    end
  end
  return stack[0][1] + 1 unless stack.empty?

  'Success'
end

puts check_brackets(gets.chomp)
