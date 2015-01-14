gem 'minitest', '~> 5.2'
gem 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require "./sudoku"
require 'pry'

describe Sudoku do
  before do
    @puzzle_string = File.read("./sample_puzzle.txt")
    @solution_string = File.read("./sample_solution.txt")
    @board = Board.new(@puzzle_string)
    @sudoku = Sudoku.new(@board)
  end

  it "takes a board" do
    assert Sudoku.new(@board).board.is_a?(Board)
  end

  it "solves" do
    skip
    assert_equal @solution_string, @sudoku.solution
  end
end

describe Board do
  before do
    @puzzle_string = File.read("./sample_puzzle.txt")
    @board = Board.new(@puzzle_string)
  end

  it "has 9 rows" do
    assert_equal 9, @board.rows.count
  end

  it "has 9 columns" do
    assert_equal 9, @board.columns.count
  end

  it "finds common digits for a spot" do
    #row 0, col 1
    #[3,4,5,7,8,9]
    assert_equal ["3","4","5","7","8","9"], @board.common_digits(0,1)
  end

  it "includes square in common digits" do
    common = %w(4 5 6 7 8 9)
    assert_equal common, @board.common_digits(0,7)
  end

  it "is not solved to start" do
    refute @board.solved?
  end

  it "is solved for the solution" do
    solved_board = Board.new(File.read("./sample_solution.txt"))
    assert solved_board.solved?
  end
end

# go through every blank spot
# check the common digits (among row, col, square) for that spot
#   - if there are 8 common digits
#     - 1 possible solution, fill it in
#
#   - else -- skip it until the next pass


