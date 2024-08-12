# frozen_string_literal: true

def phonebook_manager(queries)
  phonebook = {}
  results = []
  queries.each do |query|
    case query[0]
    when 'add'
      phonebook[query[1].to_i] = query[2]
    when 'del'
      phonebook.delete(query[1].to_i)
    when 'find'
      results << (phonebook[query[1].to_i] || 'not found')
    end
  end
  results
end

n = gets.chomp.to_i
queries = []
n.times do
  queries << gets.chomp.split
end

phonebook_manager(queries).each { |x| puts x }
