class MapSolver
  COL_HEADS = (1..9).to_a.map(&:to_s)
  ROW_HEADS = ("A".."I").to_a

  attr_reader :grid, :values

  def initialize(grid="")
    @grid = grid
    @values = parse_grid
  end

  def parse_grid
    chars = grid.split("") - ["\n"]
    possibilities_list = chars.map do |char|
                           char == " " ? COL_HEADS : [char]
                         end
    Hash[positions.zip(possibilities_list)]
  end

#def assign(values, s, d):
    #"""Eliminate all the other values (except d) from values[s] and propagate.
    #Return values, except return False if a contradiction is detected."""
    #other_values = values[s].replace(d, '')
    #if all(eliminate(values, s, d2) for d2 in other_values):
        #return values
    #else:
        #return False
  def assign(position, solution)
    #eliminate values besides the solution from the position's values
    #non_sols = values[position] - [solution]
    #if non_sols.all? { |value| eliminate([value], position) }
      #values
    #else
      #false
    #end
  end

  def eliminate(values, position)
    return values unless (self.values[position] & values).any?
    self.values[position] = (self.values[position] - values)
    if self.values[position].empty?
      #eliminated all possibilities; return false to indicate invalid
      false
    elsif self.values[position].length == 1
      done = peers(position).all? do |peer|
        eliminate(self.values[position], peer)
      end
      done
    else
      true
    end
  end

  def filled?
    positions.all? { |p| values[p].length == 1 }
  end

  def positions
    ("A".."I").to_a.product((1..9).to_a).map { |a| a.join("") }
  end

  def member_units(position)
    member_units_index.fetch(position, [])
  end

  def peers(position)
    member_units(position).flatten - [position]
  end

  def units
    rows + cols + squares
  end

  def rows
    ROW_HEADS.map { |r| COL_HEADS.map { |c| r + c } }
  end

  def cols
    COL_HEADS.map { |c| ROW_HEADS.map { |r| r + c } }
  end

  def squares
    ROW_HEADS.to_a.each_slice(3).to_a.product(COL_HEADS.each_slice(3).to_a).map { |a,b| a.product(b) }.map { |unit| unit.map { |elems| elems.join("") } }
  end

  private

  def member_units_index
    @member_units_index ||= positions.reduce({}) do |index, position|
                              index[position] = units.select { |u| u.include?(position) }
                              index
                            end
  end
end
