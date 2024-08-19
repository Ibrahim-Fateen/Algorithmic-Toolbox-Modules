# frozen_string_literal: true

gets
nums = gets.split.map(&:to_i)
window_size = gets.to_i

def solution(nums, window_size)
  maxes = []
  deque = []
  nums.each_with_index do |num, i|
    deque.shift while !deque.empty? && deque.first < i - window_size + 1
    deque.pop while !deque.empty? && nums[deque.last] < num
    deque << i
    maxes << nums[deque.first] if i >= window_size - 1
  end
  maxes.join(' ')
end

puts solution(nums, window_size)
