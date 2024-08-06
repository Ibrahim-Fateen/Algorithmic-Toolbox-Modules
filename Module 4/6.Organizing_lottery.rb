# frozen_string_literal: true

def count_segments(segments, points)
  sorted_left = segments.sort_by { |segment| segment[0] }
  sorted_right = segments.sort_by { |segment| segment[1] }
  points.map do |point|
    left_less_than_point = count_left_less_than_point(sorted_left, point)
    right_less_than_point = count_right_less_than_point(sorted_right, point)
    left_less_than_point - right_less_than_point
  end
end

def count_left_less_than_point(sorted_left, point)
  left = 0
  right = sorted_left.size - 1
  while left <= right
    mid = left + (right - left) / 2
    if sorted_left[mid][0] <= point
      left = mid + 1
    else
      right = mid - 1
    end
  end
  left
end

def count_right_less_than_point(sorted_right, point)
  left = 0
  right = sorted_right.size - 1
  while left <= right
    mid = left + (right - left) / 2
    if sorted_right[mid][1] < point
      left = mid + 1
    else
      right = mid - 1
    end
  end
  left
end

n, = gets.split.map(&:to_i)
segments = []
n.times do
  l, r = gets.split.map(&:to_i)
  segments << [l, r]
end

points = gets.split.map(&:to_i)

puts count_segments(segments, points).join(' ')
