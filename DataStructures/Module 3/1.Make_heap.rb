# frozen_string_literal: true

def make_heap(n, arr)
  swaps = []

  sift_down = lambda do |i|
    min_index = i
    left = 2 * i + 1
    right = 2 * i + 2

    if left < n && arr[left] < arr[min_index]
      min_index = left
    end

    if right < n && arr[right] < arr[min_index]
      min_index = right
    end

    if i != min_index
      arr[i], arr[min_index] = arr[min_index], arr[i]
      swaps << [i, min_index]
      sift_down.call(min_index)
    end
  end

  (n / 2).downto(0) do |i|
    sift_down.call(i)
  end
  swaps
end

n = gets.chomp.to_i
arr = gets.chomp.split.map(&:to_i)
swaps = make_heap(n, arr)
puts swaps.size
swaps.each { |swap| puts swap.join(' ') }
