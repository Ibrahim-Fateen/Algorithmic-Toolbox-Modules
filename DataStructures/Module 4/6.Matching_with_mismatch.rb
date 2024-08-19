# frozen_string_literal: true

def precompute_hashes(string, m1, m2, m3, x)
  h1 = [0]
  h2 = [0]
  h3 = [0]
  (1..string.size).each do |i|
    h1[i] = (x * h1[i - 1] + string[i - 1].ord) % m1
    h2[i] = (x * h2[i - 1] + string[i - 1].ord) % m2
    h3[i] = (x * h3[i - 1] + string[i - 1].ord) % m3
  end
  [h1, h2, h3]
end

def solve(max_mismatch, text, pattern)
  m1 = 10**9 + 7
  m2 = 10**9 + 9
  m3 = 10**9 + 21
  x = rand(1..10**9)
  t_hash1, t_hash2, t_hash3 = precompute_hashes(text, m1, m2, m3, x) # O(|T|) runtime
  p_hash1, p_hash2, p_hash3 = precompute_hashes(pattern, m1, m2, m3, x) # O(|P|) runtime
  positions = []

  equal_hashes = lambda do |left_t, right_t, left_p, right_p|
    (t_hash1[right_t + 1] - x.pow(right_t - left_t + 1,
                                  m1) * t_hash1[left_t]) % m1 == (p_hash1[right_p + 1] - x.pow(right_p - left_p + 1,
                                                                                               m1) * p_hash1[left_p]) % m1 &&
      (t_hash2[right_t + 1] - x.pow(right_t - left_t + 1,
                                    m2) * t_hash2[left_t]) % m2 == (p_hash2[right_p + 1] - x.pow(right_p - left_p + 1,
                                                                                                 m2) * p_hash2[left_p]) % m2 &&
      (t_hash3[right_t + 1] - x.pow(right_t - left_t + 1,
                                    m3) * t_hash3[left_t]) % m3 == (p_hash3[right_p + 1] - x.pow(right_p - left_p + 1,
                                                                                                 m3) * p_hash3[left_p]) % m3
  end
  # O(1) runtime
  # Slow O(1) ???

  find_next_mismatch = lambda do |left_t, right_t, left_p, right_p|
    if left_t > right_t
      -1
    elsif left_t == -1
      -1
    elsif left_t == right_t
      text[left_t] == pattern[left_p] ? -1 : left_t
    elsif equal_hashes.call(left_t, right_t, left_p, right_p)
      -1
    else
      mid = left_p + (right_p - left_p) / 2
      # left substring is text[left_t..left_t + mid - left_p]
      # right substring is text[left_t + mid - left_p + 1..right_t]
      if equal_hashes.call(left_t, left_t + mid - left_p, left_p, mid)
        find_next_mismatch.call(left_t + mid - left_p + 1, right_t, mid + 1, right_p)
      else
        find_next_mismatch.call(left_t, left_t + mid - left_p, left_p, mid)
      end
    end
  end
  # O(log|P|) runtime

  # Total runtime is O(|T| * k * log|P|)
  # Maximum runtime on the order of 10^7
  (0..text.size - pattern.size).each do |i|
    # Runtime at each index "i" for "k" mismatches is O(k * log|P|)
    mismatch_positions = [find_next_mismatch.call(i, i + pattern.size - 1, 0, pattern.size - 1)]
    max_mismatch.times do
      position_in_text = mismatch_positions.last + 1
      break if position_in_text >= text.size || mismatch_positions.last == -1

      position_in_pattern = position_in_text - i
      mismatch_positions << find_next_mismatch.call(position_in_text, i + pattern.size - 1, position_in_pattern, pattern.size - 1)
    end
    positions << i if mismatch_positions.last == -1 || mismatch_positions.size <= max_mismatch
  end

  puts "#{positions.size} #{positions.join(' ')}"
end

while (k, text, search = gets&.chomp&.split)
  max_mismatch = k.to_i
  solve(max_mismatch, text, search)
end

# start_time = Time.now
# 50_000.times { solve(2, 'abcd', 'ab') } # total size of T doesn't exceed 200_000, P doesn't exceed 100_000
# # Takes on average 0.43 seconds to finish, time limit is 10.
#
# 5_000.times { solve(2, 'abcd' * 10, 'ab' * 10) } # total size of T doesn't exceed 200_000, P doesn't exceed 100_000
# # Takes on average 0.8 seconds to finish, time limit is 10.
#
# 500.times { solve(2, 'abcd' * 100, 'ab' * 100) } # total size of T doesn't exceed 200_000, P doesn't exceed 100_000
# # Takes on average 1.2 seconds to finish, time limit is 10.
#
# 50.times { solve(2, 'abcd' * 1_000, 'ab' * 1_000) } # total size of T doesn't exceed 200_000, P doesn't exceed 100_000
# # Takes on average 1.7 seconds to finish, time limit is 10.
#
# 5.times { solve(2, 'abcd' * 10_000, 'ab' * 10_000) } # total size of T doesn't exceed 200_000, P doesn't exceed 100_000
# # Takes on average 2.3 seconds to finish, time limit is 10.
#
# 2.times { solve(2, 'abcd' * 50_000, 'ab' * 50_000) } # total size of T doesn't exceed 200_000, P doesn't exceed 100_000
# # Takes on average 5.5 seconds to finish, time limit is 10.
#
# solve(5, 'a' * 200_000, 'b' * 100_000) # total size of T doesn't exceed 200_000, P doesn't exceed 100_000
# # Takes on average 5.3 seconds to finish, time limit is 10.
# end_time = Time.now
# puts "Time: #{end_time - start_time} seconds"
