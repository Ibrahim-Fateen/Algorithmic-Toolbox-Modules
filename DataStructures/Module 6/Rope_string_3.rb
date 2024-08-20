# frozen_string_literal: true

def word_after_commands(string, commands)
  commands.each do |command|
    i, j, k = command
    substring = string[i..j]
    string = string[0...i] + string[(j + 1)..-1]
    string = if k.zero?
               substring + string
             else
               string[0...k] + substring + string[k..-1]
             end
  end
  string
end

string = gets.chomp
n = gets.chomp.to_i
commands = []
n.times do
  commands << gets.chomp.split.map(&:to_i)
end

puts word_after_commands(string, commands)
