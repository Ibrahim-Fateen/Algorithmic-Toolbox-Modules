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

  find_next_mismatch = lambda do |left_t, right_t, left_p, right_p|
    if left_t > right_t
      -1
    elsif left_t == -1
      -1
    elsif left_t == right_t
      text[left_t] == search[left_p] ? -1 : left_t
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

  (0..text.size - search.size).each do |i|
    mismatch_positions = [find_next_mismatch.call(i, i + search.size - 1, 0, search.size - 1)]
    max_mismatch.times do
      position_in_text = mismatch_positions.last + 1
      break if position_in_text >= text.size

      position_in_search = position_in_text - i
      mismatch_positions << find_next_mismatch.call(position_in_text, i + search.size - 1, position_in_search, search.size - 1)
    end
    positions << i if mismatch_positions.last == -1 || mismatch_positions.size <= max_mismatch
  end

  puts "#{positions.size} #{positions.join(' ')}"
end

while (k, text, search = gets&.chomp&.split)
  max_mismatch = k.to_i
  solve(max_mismatch, text, search)
end
