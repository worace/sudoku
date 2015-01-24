class Sudoku < Struct.new(:board)
  #check for solution
  #check for contradiction -- board#invalid?
  #dup board
  #choose spot with fewest possibilities
  # => insert lowest of those possibilities
  # attempt to solve
  def fill_known(board)
    board.rows.each_with_index do |row, row_index|
      row.each_with_index do |spot, column_index|
        peer_possibilities = board.peer_possibilities(row_index, column_index)
        if peer_possibilities.length == 8
          #puts "spot #{row_index}, #{column_index} has peer possibilities: #{peer_possibilities}"
          #puts "solution must be #{Board::DIGITS - [peer_possibilities]}"
          spot.value = (Board::DIGITS - [peer_possibilities]).first
        end
        unless spot.solved?
          spot.rule_out(board.common_digits(row_index, column_index))
          spot.check_for_solution!
        end
      end
    end
  end

  def solution(board = self.board)
    if board.contradictory?
      puts board
      false
    elsif board.solved?
      board
    else
      fill_known(board)
      all_boards = board.easiest_spots.each_with_index.map do |spot, index|
        spot.possibilities.map do |p|
          new_board = board.copy
          puts "easy spot index #{index}"
          puts spot
          puts "value: #{p}"
          new_board.easiest_spots[index].value = p
          new_board
        end
      end.flatten
      all_boards.reject(&:contradictory?).detect do |b|
        solution(b)
      end
    end

    #while board.not_solved? do
      #board.rows.each_with_index do |row, row_index|
        #row.each_with_index do |spot, column_index|
          #unless spot.solved?
            #spot.rule_out(board.common_digits(row_index, column_index))
            #spot.check_for_solution!
          #end
        #end
      #end
    #end
    #board.to_s
  end
end

class Spot < Struct.new(:value, :possibilities, :board)
  def to_s
    "Spot with value #{value.inspect}, remaining possibilities: #{possibilities}"
  end

  def rule_out(digits)
    self.possibilities = self.possibilities - digits
  end

  def check_for_solution!
    self.value = possibilities.first if possibilities.length == 1
  end

  def grid_rep
    value.nil? ? " " : value.to_s
  end

  def inspect
    to_s
  end

  def solved?
    !value.nil?
  end
end

class Board
  DIGITS = (1..9).to_a
  SQUARE_CORNERS = [[0,0],[0,3],[0,6],
                    [3,0],[3,3],[3,6],
                    [6,0],[6,3],[6,6]]

  #"8  5 4  7\n  5 3 9  \n 9 7 1 6\n1 3   2 8\n 4     5\n2 78136 4\n 3 9 2 8\n  2 7 5  \n6  3 5  1\n"
  def initialize(puzzle_string)
    @puzzle = puzzle_string.split("\n").map(&:chars).map do |row_ary|
      row_ary.map do |value|
        if value == " "
          Spot.new(nil, DIGITS.dup, self)
        else
          Spot.new(value.to_i, [value.to_i], self)
        end
      end
    end
  end

  def contradictory?
    units.any? do |u|
      vals = u.map(&:value).compact
      vals.uniq.length < vals.length
    end
  end

  def units
    rows + columns + squares
  end

  def squares
    SQUARE_CORNERS.map { |coords| common_square(*coords) }
  end

  def easiest_spot
    easiest_spots.first
  end

  def easiest_spots
    spots.reject(&:solved?).sort_by { |s| s.possibilities.count }
  end

  def spots
    @puzzle.flatten
  end

  def rows
    @puzzle
  end

  def columns
    @puzzle.transpose
  end

  def peer_possibilities(row, col)
    common_spots(row, col).flat_map(&:possibilities).uniq.sort
  end

  def common_digits(row, col)
    common_spots(row, col).map(&:value).compact.uniq.sort
  end

  def common_spots(row, col)
    ((rows[row] + columns[col] + common_square(row, col)))
  end

  def common_square(row, col)
    @puzzle[row/3*3,3].map { |s| s[col/3*3,3] }.flatten
  end

  def solved?
    spots.all?(&:solved?) && !contradictory?
  end

  def not_solved?
    !solved?
  end

  def to_s
    @puzzle.map { |r| r.map(&:grid_rep).join("") }.join("\n")
  end

  def copy
    Board.new(to_s)
  end
end

