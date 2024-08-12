# frozen_string_literal: true

class WorkerThread
  attr_accessor :index, :next_free
  def initialize(index, next_free)
    @index = index
    @next_free = next_free
  end
end

def solution(n_threads, job_times)
  # n_threads = 2
  # job_times = [1, 2, 3, 4, 5]
  results = []
  heap = []

  heap_push = lambda do |worker_thread|
    heap.append(worker_thread)
    i = heap.size - 1
    while i.positive?
      parent = (i - 1) / 2
      if heap[parent].next_free > heap[i].next_free || (heap[parent].next_free == heap[i].next_free && heap[parent].index > heap[i].index)
        heap[parent], heap[i] = heap[i], heap[parent]
        i = parent
      else
        break
      end
    end
  end

  min_thread = lambda do |parent, left_child, right_child|
    if left_child < heap.size && (heap[left_child].next_free < heap[parent].next_free || (heap[left_child].next_free == heap[parent].next_free && heap[left_child].index < heap[parent].index))
      min = left_child
    else
      min = parent
    end
    if right_child < heap.size && (heap[right_child].next_free < heap[min].next_free || (heap[right_child].next_free == heap[min].next_free && heap[right_child].index < heap[min].index))
      min = right_child
    end
    min
  end

  sift_down = lambda do |i|
    min_index = min_thread.call(i, 2 * i + 1, 2 * i + 2)
    if i != min_index
      heap[i], heap[min_index] = heap[min_index], heap[i]
      sift_down.call(min_index)
    end
  end


  job_times.each do |job|
    if heap.size < n_threads
      worker_thread = WorkerThread.new(heap.size, job)
      results.push([worker_thread.index, 0])
      heap_push.call(worker_thread)
    else
      next_thread = heap[0]
      results.push([next_thread.index, next_thread.next_free])
      heap[0].next_free += job
      sift_down.call(0)
    end
  end
  results
end

n, = gets.chomp.split.map(&:to_i)
job_times = gets.chomp.split.map(&:to_i)
solution(n, job_times).each { |job| puts job.join(' ') }

# solution.each { |job| puts job.join(' ') }
