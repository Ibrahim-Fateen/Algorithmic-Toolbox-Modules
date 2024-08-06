# frozen_string_literal: true

def get_cheatcode(options, n)
  dp = Array.new(n + 1) { Array.new(n + 1, false) }
  dp[0][0] = false

  (0..n).each do |i|
    (0..n).each do |j|
      options.each do |option|
        next if dp[i][j]

        dp[i][j] = true if i - option[0] >= 0 && j - option[1] >= 0 && !dp[i - option[0]][j - option[1]]
      end
    end
  end
  dp
end

two_rocks_options = [[1, 0], [0, 1], [1, 1]]
three_rocks_options = [[1, 0], [0, 1], [1, 1], [2, 1], [1, 2], [2, 0], [0, 2], [3, 0], [0, 3]]

puts 'Two Rocks Game Cheatcode'
puts '   0 1 2 3 4 5 6 7 8 9 10'
cheatcode = get_cheatcode(two_rocks_options, 10)
cheatcode.each_with_index do |row, i|
  print "#{i}  " if i < 10
  print "#{i} " if i >= 10
  row.each do |cell|
    print cell ? 'W ' : 'L '
  end
  puts
end

puts '-' * 20
puts
puts 'Three Rocks Game Cheatcode'
puts '   0 1 2 3 4 5 6 7 8 9 10'
cheatcode = get_cheatcode(three_rocks_options, 10)
cheatcode.each_with_index do |row, i|
  print "#{i}  " if i < 10
  print "#{i} " if i >= 10
  row.each do |cell|
    print cell ? 'W ' : 'L '
  end
  puts
end
