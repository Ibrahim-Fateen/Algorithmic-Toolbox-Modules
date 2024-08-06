# frozen_string_literal: true

n = gets.chomp.to_i
arr = gets.chomp.split(' ').map(&:to_i)
max1 = arr.max
arr.delete_at(arr.index(max1))
max2 = arr.max
puts max1 * max2
