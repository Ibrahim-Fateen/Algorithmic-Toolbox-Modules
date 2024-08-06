# frozen_string_literal: true

# This was just a matter of adding a third dimension to the dp array.

def lcs_3(first, second, third)
  n = first.size
  m = second.size
  l = third.size
  dp = Array.new(n + 1) { Array.new(m + 1) { Array.new(l + 1, 0) } }
  (1..n).each do |i|
    (1..m).each do |j|
      (1..l).each do |k|
        dp[i][j][k] = if first[i - 1] == second[j - 1] && second[j - 1] == third[k - 1]
                        dp[i - 1][j - 1][k - 1] + 1
                      else
                        [dp[i - 1][j][k], dp[i][j - 1][k], dp[i][j][k - 1]].compact.max
                      end
      end
    end
  end
  dp[n][m][l]
end

gets
first = gets.split.map(&:to_i)
gets
second = gets.split.map(&:to_i)
gets
third = gets.split.map(&:to_i)
puts lcs_3(first, second, third)
