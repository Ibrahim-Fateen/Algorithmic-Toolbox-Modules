# frozen_string_literal: true

m1 = 10**9 + 7
m2 = 10**9 + 9
x = rand(1..10**9)

def solution(string1, string2, m1, m2, x)

  min_size = [string1.size, string2.size].min
  left = 0
  right = min_size
  a = 0
  b = 0
  while left < right
    substring_size = (left + right + 1) / 2
    update, _a, _b = common_hashes_position(string1, string2, substring_size, m1, m2, x)
    a, b = _a, _b if update
    if common_substring?(_a, _b, substring_size, string1, string2)
      left = substring_size
    else
      right = substring_size - 1
    end
  end
  puts "#{a} #{b} #{left}"
end

def common_substring?(a, b, substring_size, string1, string2)
  string1[a, substring_size] == string2[b, substring_size]
end

def common_hashes_position(string1, string2, substring_size, m1, m2, x)
  string1_hashes_1, string1_hashes_2 = precompute_hashes(string1, m1, m2, x)
  string2_hashes_1, string2_hashes_2 = precompute_hashes(string2, m1, m2, x)

  # look for position a in string1 and position b in string2 such that the hashes of the substrings of size substring_size
  # starting at a in string1 and b in string2 are equal
  (0..string1.size - substring_size).each do |a|
    (0..string2.size - substring_size).each do |b|
      next unless (string1_hashes_1[a + substring_size] - x.pow(substring_size, m1) * string1_hashes_1[a]) % m1 == (string2_hashes_1[b + substring_size] - x.pow(substring_size, m1) * string2_hashes_1[b]) % m1 &&
                  (string1_hashes_2[a + substring_size] - x.pow(substring_size, m2) * string1_hashes_2[a]) % m2 == (string2_hashes_2[b + substring_size] - x.pow(substring_size, m2) * string2_hashes_2[b]) % m2

      return [true, a, b]
    end
  end
  [false, -1, -1]
end

def precompute_hashes(string, m1, m2, x)
  h1 = [0]
  h2 = [0]
  (1..string.size).each do |i|
    h1[i] = (x * h1[i - 1] + string[i - 1].ord) % m1
    h2[i] = (x * h2[i - 1] + string[i - 1].ord) % m2
  end
  [h1, h2]
end

# binary search for the maximum length of a common substring starting from half of the shortest string
while (line = gets)
  string1, string2 = line.chomp.split
  solution(string1, string2, m1, m2, x)
end


# Wrong answer, issue might be "binary search", "common hashes" method or temp variables "(a_, b_)"

# test
# baababbbbabaababaa babbabaababaabbaabaa
# baaababbbbaa aababaabaaaabbaabaa
# bbababbbbbbaaabbbb bbbababbbaaaaaa
# aabaabbbabbaaaaba aabaababaaababababab
# babababaaaaababaab bbbabbaababb
# babbbabbabb abbaabaaab
# abaaabbbbbababbaabb bbbbbaaabbb
# baaaaaababbbbbbaaaa aababbbbbabaaaab
# abaaabaabbaa aaabbbaaaabb
# bbaabbabaaabbbbb aaabbbbbbbbb
# bbbabbbababbba baaabbaaabb
# baaaaaaaab bbababbbaba
# aaabaaabaabbaba bbbaabbbabbabbab
#
