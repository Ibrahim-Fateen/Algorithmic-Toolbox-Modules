# frozen_string_literal: true

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
