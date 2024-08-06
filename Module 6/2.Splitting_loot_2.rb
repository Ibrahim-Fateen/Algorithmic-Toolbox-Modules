# frozen_string_literal: true

# Another solution to the problem, "with help from youtube"

# The solution here is done by constructing each group one by one.
# When constructing a group, only the values not used in previous groups are considered.
# A group finishes constructing when its sum is equal to the target sum.

def can_split?(values, k_partitions)
  used = Array.new(values.size, false)
  total = values.sum
  target = total / k_partitions
  return false if total % k_partitions != 0 || values.max > target

  backtrack = lambda do |start, current_sum, current_k|
    return true if current_k == k_partitions - 1

    return backtrack.call(0, 0, current_k + 1) if current_sum == target

    (start...values.size).each do |i|
      next if used[i] || current_sum + values[i] > target

      used[i] = true
      return true if backtrack.call(i + 1, current_sum + values[i], current_k)

      used[i] = false
    end
    false
  end

  values.sort_by!(&:-@)
  backtrack.call(0, 0, 0)
end

gets
values = gets.split.map(&:to_i)
# values = [1, 1, 2, 4, 4]
puts can_split?(values, 3) ? 1 : 0
