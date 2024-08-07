# frozen_string_literal: true

# def hole_permutation(mice, holes)
#   time_to_hide = Array.new(mice.size) { Array.new(holes.size) }
#   mice.each_with_index do |mouse, i|
#     holes.each_with_index do |hole, j|
#       time_to_hide[i][j] = (mouse - hole).abs
#     end
#   end
#   used = Array.new(holes.size, false)
#
#   # minimize the maximum time taken by any mouse to hide in a hole
#   # and return where each mouse hides
#   time_to_hide.map do |mouse|
#     min_time = Float::INFINITY
#     min_index = nil
#     mouse.each_with_index do |time, i|
#       next if used[i]
#
#       if time < min_time
#         min_time = time
#         min_index = i
#       end
#     end
#     used[min_index] = true
#     min_index
#   end
# end

def solution(mice, holes)
  # given an array of mice indices, and array of holes indices
  # find where each mouse hides, to minimize the time to hide, given that each hole can only hide one mouse
  # mice = [2, 8, 0], holes = [3, 4, 6]
  # mice[0] hides in holes[1], mice[1] hides in holes[2], mice[2] hides in holes[0]
  # return [1, 2, 0]

end

puts solution([2, 8, 0], [3, 4, 6])
