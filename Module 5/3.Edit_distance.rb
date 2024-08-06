# frozen_string_literal: true

def edit_distance(word1, word2)
  n = word1.size
  m = word2.size
  dp = Array.new(n + 1) { Array.new(m + 1) }
  (0..n).each { |i| dp[i][0] = i }
  (0..m).each { |j| dp[0][j] = j }
  (1..n).each do |i|
    (1..m).each do |j|
      insertion = dp[i][j - 1] + 1
      deletion = dp[i - 1][j] + 1
      mismatch = dp[i - 1][j - 1] + 1
      match = dp[i - 1][j - 1]
      match += 1 if word1[i - 1] != word2[j - 1]
      dp[i][j] = [insertion, deletion, mismatch, match].min
    end
  end
  dp[n][m]
end

puts edit_distance(gets.chomp, gets.chomp)
