# frozen_string_literal: true

# The goal is to find the minimum number of points to cover all segments
# A greedy approach would be to choose the rightmost point of the first segment
# Then remove all segments that contain this point
# Repeat until all segments are covered

# This works because the rightmost point of the first segment will always be
# the rightmost point of the last segment in the set of segments that contain it
# So we can remove all segments that contain this point and repeat the process
# until all segments are covered.

def optimal_points(segments)
  points = []
  segments = segments.sort_by { |s| s[1] }
  while segments.any?
    point = segments.first[1]
    segments.reject! { |s| s[0] <= point && s[1] >= point }
    points << point
  end
  points
end

n = gets.to_i
segments = []
n.times do
  l, r = gets.split.map(&:to_i)
  segments << [l, r]
end
points = optimal_points(segments)
puts points.size
puts points.join(' ')
