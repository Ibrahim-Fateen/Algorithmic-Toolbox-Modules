# frozen_string_literal: true

def binary_search(a, targets)
  indicies = []
  targets.each do |target|
    left = 0
    right = a.size - 1
    while left <= right
      mid = left + (right - left) / 2
      if a[mid] == target
        indicies << mid
        break
      elsif a[mid] < target
        left = mid + 1
      else
        right = mid - 1
      end
    end
    indicies << -1 if left > right
  end
  indicies
end

_ = gets
k = gets.split.map(&:to_i)
_ = gets
q = gets.split.map(&:to_i)
puts binary_search(k, q).join(' ')

