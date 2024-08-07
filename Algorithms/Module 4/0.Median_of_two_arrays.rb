# frozen_string_literal: true

def solution(nums1, nums2)
  n = nums1.size
  m = nums2.size
  correct_square = []
  # Assume same size

  mid1 = n / 2
  mid2 = m / 2
  factor = 0.5
  loop do
    factor /= 2
    # break if mid1 # out of bounds

    if nums1[mid1] >= nums2[mid2]
      if nums1[mid1 - 1] >= nums2[mid2 + 1]
        correct_square = [[mid1, mid1 + 1], [mid2 - 1, mid2]]
        break
      else
        mid1 -= n * factor
        mid2 += m * factor
      end
    else
      if nums2[mid2 - 1] >= nums1[mid1 + 1]
        correct_square = [[mid1 - 1, mid1], [mid2, mid2 + 1]]
        break
      else
        mid1 += n * factor
        mid2 -= m * factor
      end
    end
  end

  # median of correct square
  if (n + m).even?
    [nums1[correct_square[0][0]], nums2[correct_square[1][0]].max].to_f
  else
    [[nums1[correct_square[0][0]], nums2[correct_square[1][0]].max].to_f,
     [nums1[correct_square[0][1]], nums2[correct_square[1][1]].min].to_f].sum
  end
end

puts solution([1, 2, 5, 6, 7, 8, 10, 27], [3, 4, 9, 20, 25, 26, 30, 80])
