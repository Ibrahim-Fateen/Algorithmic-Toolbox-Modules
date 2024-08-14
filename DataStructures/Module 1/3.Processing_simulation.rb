# frozen_string_literal: true

def simulate_processing(buffer_size, packets)
  buffer = []
  next_free = 0
  packets.each do |arrival_time, processing_time|
    if buffer.size < buffer_size
      start_time = [next_free, arrival_time].max
      next_free = start_time + processing_time
      buffer << next_free
      puts start_time
    elsif buffer.first > arrival_time
      puts(-1)
    else
      buffer.shift
      start_time = [next_free, arrival_time].max
      next_free = start_time + processing_time
      buffer << next_free
      puts start_time
    end
  end
end

buffer_size, n = gets.split.map(&:to_i)
packets = []
n.times do
  packets << gets.split.map(&:to_i)
end

simulate_processing(buffer_size, packets)
