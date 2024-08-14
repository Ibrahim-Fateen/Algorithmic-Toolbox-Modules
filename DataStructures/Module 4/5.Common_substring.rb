# frozen_string_literal: true

m1 = 10**9 + 7
m2 = 10**9 + 9
m3 = 10**9 + 21
x = rand(1..10**9)

# O((|S| * |T| + k + |T| + |S|) * log(minsize))
def solution(string1, string2, m1, m2, m3, x)
  min_size = [string1.size, string2.size].min
  left = 0
  right = min_size
  correct_i = 0
  correct_j = 0
  while left < right
    substring_size = (left + right + 1) / 2
    a, b = common_hashes_position(string1, string2, substring_size, m1, m2, m3, x) # O(|S| * |T|)
    if common_substring?(a, b, substring_size, string1, string2) # O(substring_size)
      left = substring_size
      correct_i = a
      correct_j = b
    else
      right = substring_size - 1
    end
  end
  puts "#{correct_i} #{correct_j} #{left}"
end

# O(k)
def common_substring?(a, b, substring_size, string1, string2) # O(k)
  a >= 0 && b >= 0 && string1[a, substring_size] == string2[b, substring_size]
end

# O(|S|) + O(|T|) + O(|S| * |T|) = O(|S| * |T|)
def common_hashes_position(string1, string2, substring_size, m1, m2, m3, x) # O(|S| * |T|)
  string1_hashes1, string1_hashes2, string1_hashes3 = precompute_hashes(string1, m1, m2, m3, x)
  string2_hashes1, string2_hashes2, string2_hashes3 = precompute_hashes(string2, m1, m2, m3, x)

  hashes1_table = {}
  hashes2_table = {}
  hashes3_table = {}

  (0..string1.size - substring_size).each do |i|
    hashes1_table[(string1_hashes1[i + substring_size] - x.pow(substring_size, m1) * string1_hashes1[i]) % m1] = i
    hashes2_table[(string1_hashes2[i + substring_size] - x.pow(substring_size, m2) * string1_hashes2[i]) % m2] = i
    hashes3_table[(string1_hashes3[i + substring_size] - x.pow(substring_size, m3) * string1_hashes3[i]) % m3] = i
  end

  (0..string2.size - substring_size).each do |i|
    if hashes1_table.key?((string2_hashes1[i + substring_size] - x.pow(substring_size,
                                                                       m1) * string2_hashes1[i]) % m1) &&
       hashes2_table.key?((string2_hashes2[i + substring_size] - x.pow(substring_size,
                                                                       m2) * string2_hashes2[i]) % m2) &&
       hashes3_table.key?((string2_hashes3[i + substring_size] - x.pow(substring_size, m3) * string2_hashes3[i]) % m3)
      return [hashes1_table[(string2_hashes1[i + substring_size] - x.pow(substring_size) * string2_hashes1[i]) % m1],
              i]
    end
  end

  # look for position a in string1 and position b in string2 such that the hashes of the substrings of size substring_size
  # starting at a in string1 and b in string2 are equal
  # (0..string1.size - substring_size).each do |a|
  #   (0..string2.size - substring_size).each do |b|
  #     next unless (string1_hashes1[a + substring_size] - x.pow(substring_size, m1) * string1_hashes1[a]) % m1 == (string2_hashes1[b + substring_size] - x.pow(substring_size, m1) * string2_hashes1[b]) % m1 &&
  #                 (string1_hashes2[a + substring_size] - x.pow(substring_size, m2) * string1_hashes2[a]) % m2 == (string2_hashes2[b + substring_size] - x.pow(substring_size, m2) * string2_hashes2[b]) % m2 &&
  #                 (string1_hashes3[a + substring_size] - x.pow(substring_size, m3) * string1_hashes3[a]) % m3 == (string2_hashes3[b + substring_size] - x.pow(substring_size, m3) * string2_hashes3[b]) % m3
  #
  #     return [a, b]
  #   end
  # end
  [-1, -1]
end

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

# binary search for the maximum length of a common substring starting from half of the shortest string
while (string1, string2 = gets&.chomp&.split)
  solution(string1, string2, m1, m2, m3, x)
end

# solution('baababbbbabaababaa', 'babbabaababaabbaabaa', m1, m2, m3, x)
# solution('cool', 'toolbox', m1, m2, m3, x)

# Wrong answer, issue might be "binary search", "common hashes" method or temp variables "(a_, b_)"
# Issue was common_substring? method, returning true if a was -1
