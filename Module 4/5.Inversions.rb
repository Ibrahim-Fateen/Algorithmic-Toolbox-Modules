# frozen_string_literal: true

# Inversions are defined as the number of pairs (i, j) such that i < j and arr[i] > arr[j].
# [1, 3, 5, 2, 4, 6] has 3 inversions: (3, 2), (5, 2), and (5, 4).
# "This is not the same as the number of swaps required to sort the array."

# It was done using merge sort
# I modified the merge method to count the inversion pairs.
# The inversion pairs are the number of elements in the left array
# that are greater than an element in the right array that is placed before it.

# say the left array is [1, 3, 5] and the right array is [2, 4, 6]
# When merging them, 2 is less than 3 & 5, and 4 is less than 5, resulting in 3 inversion pairs.

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
