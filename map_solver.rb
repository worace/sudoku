class MapSolver
  COL_HEADS = (1..9).to_a.map(&:to_s)
  ROW_HEADS = ("A".."I").to_a

  attr_reader :grid
  attr_accessor :values

  def initialize(grid="")
    @grid = grid
    @values = parse_grid
  end

  def solve(values = self.values)
    if values == false
      false
    elsif solved?(values)
      values
    else
      easiest = easiest_position(values)
      values[easiest].each do |val|
        solution = solve(assign(val, easiest, values.dup))
        if solution != false
          return solution
        end
      end
      false
    end
  end

  def some(enum, &block)
    enum.each do |obj|
      val = yield(obj)
      if val != false
        return val
      end
    end
    false
  end

  def assign(value, position, values = self.values)
    #eliminate values besides the solution from the position's values
    non_sols = values[position] - [value]
    if non_sols.all? { |val| eliminate([val], position, values) }
      values
    else
      false
    end
  end

  def eliminate(elim_vals, position, values = self.values)
    return elim_vals unless (values[position] & elim_vals).any?
    values[position] = (values[position] - elim_vals)
    if values[position].empty?
      #eliminated all possibilities; return false to indicate invalid
      false
    elsif values[position].length == 1
      done = peers(position).all? do |peer|
        eliminate(values[position], peer, values)
      end
      done
    else
      true
    end
  end

  def easiest_position(values)
    easiest,_ = values.select { |pos, vals| vals.length > 1 }.min_by { |pos, vals| vals.length }
    easiest
  end

  def solved?(values = self.values)
    values.all? { |k,v| v.length == 1 }
  end

  def parse_grid
    chars = grid.split("") - ["\n"]
    possibilities_list = chars.map do |char|
                           char == " " ? COL_HEADS : [char]
                         end
    Hash[positions.zip(possibilities_list)]
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
