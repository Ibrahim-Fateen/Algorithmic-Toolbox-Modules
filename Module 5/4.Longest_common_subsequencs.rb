# frozen_string_literal: true

# This solves the problem of finding the longest subsequence between two sequences.
# The subsequences do not need to be contiguous.
# The algorithm uses dynamic programming to store the length of the longest common subsequence at each step.
# If the elements at the current step are equal, the length of the longest common subsequence is the length of the previous subsequence plus 1.
# If the elements are different, the length of the longest common subsequence is the maximum of the previous subsequences.

def common_subsequence_length(first, second)
  n = first.size
  m = second.size
  dp = Array.new(n + 1) { Array.new(m + 1) }
  (0..n).each { |i| dp[i][0] = 0 }
  (0..m).each { |j| dp[0][j] = 0 }
  (1..n).each do |i|
    (1..m).each do |j|
      dp[i][j] = if first[i - 1] == second[j - 1]
                   dp[i - 1][j - 1] + 1
                 else
                   [dp[i - 1][j], dp[i][j - 1]].max
                 end
    end
  end
  dp[n][m]
end

gets
first = gets.split.map(&:to_i)
gets
second = gets.split.map(&:to_i)
puts common_subsequence_length(first, second)
