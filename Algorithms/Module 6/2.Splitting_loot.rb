# frozen_string_literal: true

# The problem I found the most challenging.

# We needed to know if the given values could be split equally into 3 groups.

# To solve this, we needed to know what the target, or the sum of each group, should be.
# A 3d dp array was created, where the first dimension represented the number of values used,
# the second and third dimensions represented the sum of the first and second groups, respectively.
# The value of dp[i][j][k] was true if the first i values could be split into two groups with sums j and k.

# If the last value of the dp array was true, then the values could be split into three groups.

def can_split?(values)
  total = values.sum
  return false if total % 3 != 0

  target = total / 3
  values.sort_by!(&:-@)
  return false if values[0] > target

  dp = Array.new(values.size + 1) { Array.new(target + 1) { Array.new(target + 1, false) } }
  dp[0][0][0] = true

  values.each_with_index do |value, i|
    (0..target).each do |j|
      (0..target).each do |k|
        next unless dp[i][j][k]

        dp[i + 1][j][k] = true
        dp[i + 1][j + value][k] = true if j + value <= target
        dp[i + 1][j][k + value] = true if k + value <= target
      end
    end
  end
  dp[-1][target][target]
end

# gets
# values = gets.split.map(&:to_i)
values = [1, 1, 2, 4, 4]
puts can_split?(values) ? 1 : 0
