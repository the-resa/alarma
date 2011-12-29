# Extend Array with a twod array
class Array
  def self.new_2d(column, row)
    a = Array.new(column)
    a.map! { Array.new(row)}

    return a
  end
end