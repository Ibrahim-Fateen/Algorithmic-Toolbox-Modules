# frozen_string_literal: true

# Greedy solution
# The best decision at each step is to go to the farthest reachable station given the current fuel
# If there is no station in the reachable range, then the destination is unreachable
def least_refills(destination, tank, stations)
  current_location = 0
  refills = 0
  while current_location + tank < destination
    max_reach = current_location + tank
    possible_stations = stations.select { |s| s > current_location && s <= max_reach }
    next_station = possible_stations.max
    return -1 if next_station.nil?

    current_location = next_station
    refills += 1
  end
  refills
end

d = gets.to_i
m = gets.to_i
_ = gets.to_i
stations = gets.split.map(&:to_i)

puts least_refills(d, m, stations)
