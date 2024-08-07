# frozen_string_literal: true

# Solved as explained in lectures.
# By keeping track of the maximum and minimum values that can be obtained from each subexpression
# we can, at each step, find the minimum and maximum values that can be obtained from the current expression
# by using the corresponding operation and the minimum and maximum values of the subexpressions.

def max_expression(s)
  n = (s.size + 1) / 2
  dp_max = Array.new(n) { Array.new(n, 0) }
  dp_min = Array.new(n) { Array.new(n, 0) }
  n.times do |i|
    dp_max[i][i] = s[i * 2].to_i
    dp_min[i][i] = s[i * 2].to_i
  end
  (1...n).each do |len|
    (0...n - len).each do |i|
      j = i + len
      min_value = Float::INFINITY
      max_value = -Float::INFINITY
      (i...j).each do |k|
        op = s[k * 2 + 1]
        a = eval("#{dp_max[i][k]}#{op}#{dp_max[k + 1][j]}")
        b = eval("#{dp_max[i][k]}#{op}#{dp_min[k + 1][j]}")
        c = eval("#{dp_min[i][k]}#{op}#{dp_max[k + 1][j]}")
        d = eval("#{dp_min[i][k]}#{op}#{dp_min[k + 1][j]}")
        min_value = [min_value, a, b, c, d].min
        max_value = [max_value, a, b, c, d].max
      end
      dp_max[i][j] = max_value
      dp_min[i][j] = min_value
    end
  end
  dp_max[0][n - 1]
end

s = gets.chomp
puts max_expression(s)
