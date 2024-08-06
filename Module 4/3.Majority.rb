# frozen_string_literal: true

def majority_element?(arr)
  arr.sort!
  count = 1
  (1...arr.size).each do |i|
    count = arr[i] == arr[i - 1] ? count + 1 : 1
    return true if count > arr.size / 2
  end
  false
end

gets
arr = gets.split.map(&:to_i)
puts majority_element?(arr) ? 1 : 0
