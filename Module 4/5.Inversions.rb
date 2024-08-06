# frozen_string_literal: true

def merge_sort(arr)
  return arr, 0 if arr.size < 2

  mid = arr.size / 2
  left, left_inversions = merge_sort(arr[0...mid])
  right, right_inversions = merge_sort(arr[mid..])

  sorted_arr, merge_inversions = merge(left, right)
  [sorted_arr, merge_inversions + left_inversions + right_inversions]
end

def merge(left, right)
  merged = []
  i = 0
  j = 0
  inversions = 0

  while i < left.size && j < right.size
    if left[i] <= right[j]
      merged << left[i]
      i += 1
    else
      merged << right[j]
      inversions += left.size - i
      j += 1
    end
  end

  [merged + left[i..] + right[j..], inversions]
end

gets
arr = gets.split.map(&:to_i)
_, inversions = merge_sort(arr)
puts inversions
