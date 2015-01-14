class Sudoku < Struct.new(:board)
    #[
      #[1,2,3],
      #[4,5,6],
      #[7,8,9]
    #]
  def solution
    while board.not_solved? do
      board.rows.each_with_index do |row, row_index|
        puts "checking row  #{row_index}"
        row.each_with_index do |spot, column_index|
          puts "checking spot #{row_index}, #{column_index}"
          if (spot == " ") && board.common_digits(row_index, column_index).count == 8
            puts "i think we have a solution for spot row: #{row_index}, col: #{column_index}"
            puts "common digits are: #{board.common_digits(row_index, column_index)}"
            solution = ((1..9).to_a.map(&:to_s) - board.common_digits(row_index, column_index)).first
            puts "solution would be: #{solution}"
            board.rows[row_index][column_index] = solution
          end
        end
      end
    end
  end
end

class Board
  #"8  5 4  7\n  5 3 9  \n 9 7 1 6\n1 3   2 8\n 4     5\n2 78136 4\n 3 9 2 8\n  2 7 5  \n6  3 5  1\n"
  def initialize(puzzle_string)
    @puzzle = puzzle_string.split("\n").map(&:chars)
  end

  def rows
    @puzzle
  end

  def columns
    @puzzle.transpose
  end

  def common_digits(row, col)
    ((rows[row] + columns[col]) - [" "]).uniq.sort
  end

  def solved?
    !@puzzle.flatten.include?(" ")
  end

  def not_solved?
    !solved?
  end
end
