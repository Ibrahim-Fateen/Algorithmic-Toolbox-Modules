# frozen_string_literal: true

def search(arr, targets)
  indicies = []
  targets.each do |target|
    left = 0
    right = arr.size - 1
    found_index = -1
    while left <= right
      mid = left + (right - left) / 2
      if arr[mid] == target
        found_index = mid
        right = mid - 1
      elsif arr[mid] < target
        left = mid + 1
      else
        right = mid - 1
      end
    end
    indicies << found_index
  end
  indicies
end

gets
arr = gets.split.map(&:to_i)
gets
targets = gets.split.map(&:to_i)
puts search(arr, targets).join(' ')
