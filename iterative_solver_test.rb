gem 'minitest', '~> 5.2'
gem 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require "./iterative_solver"
require 'pry'
require "timeout"

def sudoku_for(puzzle_path)
  puzzle = File.read(puzzle_path)
  board = Board.new(puzzle)
  IterativeSolver.new(board)
end

describe IterativeSolver do
  before do
    @puzzle_string = File.read("./sample_puzzle_1.txt")
    @solution_string = File.read("./sample_solution_1.txt").chomp
    @board = Board.new(@puzzle_string)
    @sudoku = IterativeSolver.new(@board)
  end

  it "takes a board" do
    assert IterativeSolver.new(@board).board.is_a?(Board)
  end

  it "solves" do
    assert_equal @solution_string, @sudoku.solution
  end

  it "solves #2" do
    sudoku_for("./sample_puzzle_2.txt").solution.inspect
  end

  it "tells me which puzzles are solveable" do
    skip
    #sample_puzzles/puzzle_0.txt
    #sample_puzzles/puzzle_11.txt
    #sample_puzzles/puzzle_16.txt
    #sample_puzzles/puzzle_35.txt
    #sample_puzzles/puzzle_39.txt
    #sample_puzzles/puzzle_19.txt
    #sample_puzzles/puzzle_37.txt
    #sample_puzzles/puzzle_18.txt
    #sample_puzzles/puzzle_7.txt
    #sample_puzzles/puzzle_4.txt
    #sample_puzzles/puzzle_15.txt
    #sample_puzzles/puzzle_33.txt
    solved = Dir.glob("sample_puzzles/*.txt").shuffle.map do |file|
      sudoku = sudoku_for("./#{file}")
      begin
        Timeout::timeout(1) {
          puts "attempting to solve puzzle #{file}"
          sudoku.solution
          puts "Solved a puzzle!"
          file
        }
      rescue Timeout::Error
        nil
      end
    end.compact
    puts solved
  end

  it "solves for a bunch" do
    skip
    Dir.glob("sample_puzzles/*.txt").shuffle.each do |file|
      sudoku = sudoku_for("./#{file}")
      begin
        Timeout::timeout(4) {
          puts "attempting to solve puzzle #{file}"
          sudoku.solution
          puts "Solved a puzzle!"
        }
      rescue Timeout::Error
        puts "puzzle #{file} failed to solve in time"
        puts "starting point was:"
        puts "***********************"
        puts Board.new(File.read("./#{file}")).to_s
        puts "***********************"
        puts "progress on #{file} so far is:"
        puts sudoku.board.to_s
        raise "failed on #{file}"
      end
    end
  end
end

describe Board do
  before do
    @puzzle_string = File.read("./sample_puzzle_1.txt")
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
    assert_equal ["3","4","5","7","8","9"].map(&:to_i), @board.common_digits(0,1)
  end

  it "finds common square digits for a spot" do
    #5 4
    # 3 
    #7 1
    assert_equal [5, nil, 4, nil, 3, nil, 7, nil, 1], @board.common_square(0,5).map(&:value)
  end

  it "includes square in common digits" do
    common = [4, 5, 6, 7, 8, 9]
    assert_equal common, @board.common_digits(0,7)
  end

  it "is not solved to start" do
    refute @board.solved?
  end

  it "is solved for the solution" do
    solved_board = Board.new(File.read("./sample_solution_1.txt"))
    assert solved_board.solved?
  end

  it "finds unique peer possibilities for a given row and column" do
    #(every digit is represented as a possibility for at least 1 peer)
    assert_equal [1,2,3,4,5,6,7,8,9], @board.peer_possibilities(1,1)
  end

  describe "#copy" do
    it "can deep copy itself" do
      copy = @board.copy
      assert (copy.spots.map(&:object_id) & @board.spots.map(&:object_id)).empty?
      assert_equal copy.spots.map(&:value), @board.spots.map(&:value)
    end
  end
end

# go through every blank spot
# check the common digits (among row, col, square) for that spot
#   - if there are 8 common digits
#     - 1 possible solution, fill it in
#
#   - else -- skip it until the next pass


