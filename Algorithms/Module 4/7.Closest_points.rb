# frozen_string_literal: true

# The solution to this problem was given in the problem statement, this was just a matter of implementation.

def closest_points(points)
  n = points.size
  return Float::INFINITY if n == 1
  return distance(points[0], points[1]) if n == 2

  s1 = points[0...n / 2]
  s2 = points[n / 2..]
  d1 = closest_points(s1)
  d2 = closest_points(s2)
  d = [d1, d2].min
  left_d_strip = s1.select { |point| (points[n / 2][0] - point[0]).abs < d }
  right_d_strip = s2.select { |point| (point[0] - points[n / 2][0]).abs < d }
  left_d_strip.sort_by! { |point| point[1] }
  right_d_strip.sort_by! { |point| point[1] }
  left_d_strip.each_with_index do |point1, i|
    right_d_strip.each_with_index do |point2, j|
      break if (i - j).abs > 7

      d_ = distance(point1, point2)
      d = [d, d_].min
    end
  end
  d
end

def distance(point1, point2)
  Math.sqrt((point1[0] - point2[0])**2 + (point1[1] - point2[1])**2)
end

n = gets.chomp.to_i
points = []
n.times do
  x, y = gets.chomp.split.map(&:to_i)
  points << [x, y]
end
points.sort_by! { |point| point[0] }

puts closest_points(points)
