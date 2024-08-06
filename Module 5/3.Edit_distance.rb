# frozen_string_literal: true


# Edit distance is defined as the minimum number of operations required to transform one string into another.
# It can also be a measure of similarity between two strings.
# The operations are: insertion, deletion, and substitution.
# operations are done on string1 to make it equal to string2

# The algorithms stores a 2d dp array to store the similarity between substring s1 to substring s2
# The base case is when one of the strings is empty, the edit distance is the length of the other string.
# The algorithm iterates through the strings and calculates the minimum number of operations to transform s1 to s2
# by comparing the cost of insertion, deletion, and substitution.
# If the last 2 elements match, then no new operation is needed.

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
      match = dp[i - 1][j - 1] + (word1[i - 1] == word2[j - 1] ? 0 : 1)
      dp[i][j] = [insertion, deletion, match].min
    end
  end
  dp[n][m]
end

puts edit_distance(gets.chomp, gets.chomp)
