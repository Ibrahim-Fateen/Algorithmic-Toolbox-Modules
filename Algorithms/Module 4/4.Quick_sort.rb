# frozen_string_literal: true

# Implementation of quick_sort
# This implementation handles the case when duplicates are present in the array
# At every step, we choose a pivot, partition the array into 3 parts, and recursively sort the left and right parts
# From 0..m1-1, all elements are less than the pivot
# From m1..m2, all elements are equal to the pivot
# From m2+1..n-1, all elements are greater than the pivot

def quick_sort(arr, l, r)
  while l < r
    m1, m2 = partition3(arr, l, r)
    if m1 - l < r - m2
      quick_sort(arr, l, m1 - 1)
      l = m2 + 1
    else
      quick_sort(arr, m2 + 1, r)
      r = m1 - 1
    end
  end
end

def partition3(arr, l, r)
  # left = arr[l]
  # right = arr[r]
  # mid = arr[(l + r) / 2]
  # x = [left, right, mid].sort[1]
  x = arr[l]
  m1 = l
  m2 = l
  (l + 1..r).each do |i|
    if arr[i] < x
      m1 += 1
      m2 += 1
      arr[m1], arr[i] = arr[i], arr[m1]
      arr[m2], arr[i] = arr[i], arr[m2] if m1 != m2
    elsif arr[i] == x
      m2 += 1
      arr[m2], arr[i] = arr[i], arr[m2]
    end
  end
  arr[l], arr[m1] = arr[m1], arr[l]
  # puts "arr: #{arr}"
  # puts "x: #{x}"
  # puts "m1: #{m1}"
  # puts "m2: #{m2}"
  [m1, m2]
end

gets
arr = gets.split.map(&:to_i)
quick_sort(arr, 0, arr.size - 1)
puts arr.join(' ')
