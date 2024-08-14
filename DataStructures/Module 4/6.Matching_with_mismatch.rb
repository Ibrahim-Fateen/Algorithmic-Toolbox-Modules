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

def solve(max_mismatch, text, search)
  m1 = 10**9 + 7
  m2 = 10**9 + 9
  m3 = 10**9 + 21
  x = rand(1..10**9)
  t_hash1, t_hash2, t_hash3 = precompute_hashes(text, m1, m2, m3, x)
  p_hash1, p_hash2, p_hash3 = precompute_hashes(search, m1, m2, m3, x)
  positions = []
  mismatches = 0

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

  update_mismatches = lambda do |left_t, right_t, left_p, right_p|
    if left_t == right_t
      mismatches += text[left_t] == search[left_p] ? 0 : 1
    elsif left_t < right_t
      mid = left_p + (right_p - left_p) / 2
      mismatches += 1 if text[left_t + mid - left_p] != search[mid]
      unless mismatches > max_mismatch
        unless equal_hashes.call(left_t, left_t + mid - left_p - 1, left_p, mid - 1)
          update_mismatches.call(left_t, left_t + mid - left_p - 1, left_p, mid - 1)
        end
      end
      unless mismatches > max_mismatch
        unless equal_hashes.call(left_t + mid - left_p + 1, right_t, mid + 1, right_p)
          update_mismatches.call(left_t + mid - left_p + 1, right_t, mid + 1, right_p)
        end
      end
    end
  end

  (0..text.size - search.size).each do |i|
    mismatches = 0
    update_mismatches.call(i, i + search.size - 1, 0, search.size - 1)
    positions << i if mismatches <= max_mismatch
  end

  puts "#{positions.size} #{positions.join(' ')}"
end

while (k, text, search = gets&.chomp&.split)
  max_mismatch = k.to_i
  solve(max_mismatch, text, search)
end

# solve(1, 'ababab', 'baaa')
# solve(2, 'xabcabc', 'ccc')
# solve(3, 'aaa', 'xxx')
