# frozen_string_literal: true

m1 = 10**9 + 7
m2 = 10**9 + 9
x = rand(1..10**9)

def precompute_hashes(string, m1, m2, x)
  h1 = [0]
  h2 = [0]
  (1..string.size).each do |i|
    h1[i] = (x * h1[i - 1] + string[i - 1].ord) % m1
    h2[i] = (x * h2[i - 1] + string[i - 1].ord) % m2
  end
  [h1, h2]
end

def solution(string, queries, m1, m2, x)
  h1, h2 = precompute_hashes(string, m1, m2, x)
  queries.map do |a, b, l|
    h1_a = (h1[a + l] - x.pow(l, m1) * h1[a]) % m1
    h2_a = (h2[a + l] - x.pow(l, m2) * h2[a]) % m2
    h1_b = (h1[b + l] - x.pow(l, m1) * h1[b]) % m1
    h2_b = (h2[b + l] - x.pow(l, m2) * h2[b]) % m2
    [h1_a, h2_a] == [h1_b, h2_b]
  end
end

string = gets.chomp
n = gets.to_i
queries = []
n.times do
  queries << gets.chomp.split.map(&:to_i)
end

solution(string, queries, m1, m2, x).each { |equal| puts equal ? 'Yes' : 'No' }

# Mostly implemented as explained in the problem statement
