# frozen_string_literal: true

class Table
  attr_accessor :rows, :parent, :rank
  def initialize(rows)
    @rows = rows
    @parent = self
    @rank = 0
  end

  def union(table)
    root1 = find_root
    root2 = table.find_root
    return if root1 == root2

    if root1.rank > root2.rank
      root2.parent = root1
      root1.rows += root2.rows
      root2.rows = 0
    else
      root1.parent = root2
      root2.rank += 1 if root1.rank == root2.rank
      root2.rows += root1.rows
      root1.rows = 0
    end
  end

  def find_root
    return self if parent == self

    self.parent = parent.find_root
  end
end

def merge_tables(rows, merge_queries)
  max_size = rows.max
  tables = rows.map { |row| Table.new(row) }
  merge_queries.each do |query|
    destination, source = query
    tables[destination - 1].union(tables[source - 1])
    max_size = tables[destination - 1].find_root.rows if tables[destination - 1].find_root.rows > max_size
    puts max_size
  end
end

_, m = gets.chomp.split.map(&:to_i)
rows = gets.chomp.split.map(&:to_i)
merge_queries = []
m.times { merge_queries << gets.chomp.split.map(&:to_i) }

merge_tables(rows, merge_queries)
