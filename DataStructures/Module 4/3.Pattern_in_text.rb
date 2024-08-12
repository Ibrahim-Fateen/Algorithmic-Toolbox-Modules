# frozen_string_literal: true

X = 263
P = 1_000_000_007

def poly_hash(s)
  hash = 0
  (s.length - 1).downto(0) { |i| hash = (hash * X + s[i].ord) % P } # Needs to be in reverse order
  hash
end

# puts poly_hash('Test') # 535097971

def precompute_hashes(text, length)
  hashes = Array.new(text.length - length + 1)
  hashes[text.length - length] = poly_hash(text[text.length - length..])
  # puts "hashes[#{text.length - length}]: #{hashes[text.length - length]}"
  # puts "Substring: #{text[text.length - length..]}"
  (text.length - length - 1).downto(0) do |i|
    hashes[i] = (X * hashes[i + 1] + text[i].ord - text[i + length].ord * X**length) % P
    # puts hashes[i] == poly_hash(text[i, length]) #### ???? #### found problem, poly hash needs to be in reverse order
    # hashes[i] = poly_hash(text[i, length])
    # puts "hashes[#{i}]: #{hashes[i]}"
    # puts "Substring: #{text[i, length]}"
  end
  hashes
end

def pattern_in_text(pattern, text)
  hashes = precompute_hashes(text, pattern.length)
  pattern_hash = poly_hash(pattern)
  results = []
  (0..text.length - pattern.length).each do |i|
    results << i if pattern_hash == hashes[i] && text[i, pattern.length] == pattern
  end
  results
end

pattern = gets.chomp
text = gets.chomp
puts pattern_in_text(pattern, text).join(' ')

# time limit exceeded :(
