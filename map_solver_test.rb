gem 'minitest', '~> 5.2'
gem 'pry'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
require "./map_solver"

def sudoku_for(puzzle_path)
end

describe MapSolver do
  before do
    @solver = MapSolver.new
    @grid = File.read("./sample_puzzle_1.txt")
  end

  describe "#positions" do
    it "produces a crossed array of all the letters and squares" do
      positions = ["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9", "H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9", "I1", "I2", "I3", "I4", "I5", "I6", "I7", "I8", "I9"]
      assert_equal positions, @solver.positions
      assert_equal 81, @solver.positions.count
    end
  end

  describe "#rows" do
    it "generates positions 1-9 for each row" do
      rows = [["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9"], ["B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9"], ["C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9"], ["D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9"], ["E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9"], ["F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9"], ["G1", "G2", "G3", "G4", "G5", "G6", "G7", "G8", "G9"], ["H1", "H2", "H3", "H4", "H5", "H6", "H7", "H8", "H9"], ["I1", "I2", "I3", "I4", "I5", "I6", "I7", "I8", "I9"]]
      assert_equal rows, MapSolver.new.rows
    end
  end

  describe "#cols" do
    it "generates positions A-I for each col" do
      cols = [["A1", "B1", "C1", "D1", "E1", "F1", "G1", "H1", "I1"], ["A2", "B2", "C2", "D2", "E2", "F2", "G2", "H2", "I2"], ["A3", "B3", "C3", "D3", "E3", "F3", "G3", "H3", "I3"], ["A4", "B4", "C4", "D4", "E4", "F4", "G4", "H4", "I4"], ["A5", "B5", "C5", "D5", "E5", "F5", "G5", "H5", "I5"], ["A6", "B6", "C6", "D6", "E6", "F6", "G6", "H6", "I6"], ["A7", "B7", "C7", "D7", "E7", "F7", "G7", "H7", "I7"], ["A8", "B8", "C8", "D8", "E8", "F8", "G8", "H8", "I8"], ["A9", "B9", "C9", "D9", "E9", "F9", "G9", "H9", "I9"]]
      assert_equal cols, MapSolver.new.cols
    end
  end

  describe "#squares" do
    it "generates 3x3 unit for each square" do
      squares = [["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"], ["A4", "A5", "A6", "B4", "B5", "B6", "C4", "C5", "C6"], ["A7", "A8", "A9", "B7", "B8", "B9", "C7", "C8", "C9"], ["D1", "D2", "D3", "E1", "E2", "E3", "F1", "F2", "F3"], ["D4", "D5", "D6", "E4", "E5", "E6", "F4", "F5", "F6"], ["D7", "D8", "D9", "E7", "E8", "E9", "F7", "F8", "F9"], ["G1", "G2", "G3", "H1", "H2", "H3", "I1", "I2", "I3"], ["G4", "G5", "G6", "H4", "H5", "H6", "I4", "I5", "I6"], ["G7", "G8", "G9", "H7", "H8", "H9", "I7", "I8", "I9"]]
      assert_equal squares, MapSolver.new.squares
      assert_equal 9, MapSolver.new.squares.count
    end
  end

  describe "#units" do
    it "gives array of 27 units" do
      assert_equal 27, MapSolver.new.units.count
    end

    it "includes all rows, cols, and squares" do
      solver = MapSolver.new
      assert_equal 0, (solver.squares - solver.units).count
      assert_equal 0, (solver.rows - solver.units).count
      assert_equal 0, (solver.cols - solver.units).count
    end
  end

  describe "#member_units" do
    it "finds the square row and col to which a spot belongs" do
      assert_equal [@solver.rows.first, @solver.cols.first, @solver.squares.first], @solver.member_units("A1")
      assert_equal [@solver.rows.last, @solver.cols.last, @solver.squares.last], @solver.member_units("I9")
    end
  end

  describe "#peers" do
    it "finds all the positions that share a unit with the given position" do
      a1_peers = [@solver.rows.first, @solver.cols.first, @solver.squares.first].flatten - ["A1"]
      assert_equal a1_peers, @solver.peers("A1")
      assert @solver.peers("A1").include?("B1")
      assert @solver.peers("A1").include?("C1")
      assert @solver.peers("A1").include?("A2")
      assert @solver.peers("A1").include?("C3")
      assert @solver.peers("A1").include?("B3")
      assert @solver.peers("A1").include?("A3")
    end
  end

  describe "#initialize" do
    it "takes a grid string" do
      assert_equal @grid, MapSolver.new(@grid).grid
    end
  end

  describe "#values" do
    before do
      @solver = MapSolver.new(@grid)
    end

    it "gives remaining possible values for provided position (solved position has 1 possible value)" do
      assert_equal "8", @solver.values["A1"]
      assert_equal MapSolver::COL_HEADS, @solver.values["A2"]
      assert_equal MapSolver::COL_HEADS, @solver.values["B1"]
    end
  end

  describe "#eliminate" do
    it "removes provided value from values for provided position" do
      solver = MapSolver.new(@grid)
      assert_equal MapSolver::COL_HEADS, solver.values["A2"]
      solver.eliminate("A2", "3")
      solver.eliminate("A2", "7")
      assert_equal ["1","2","4","5","6","8","9"], solver.values["A2"]
    end
  end

  describe "#filled?" do
    it "is false if any positions have more than one possible value" do
      refute MapSolver.new(@grid).filled?
    end

    it "is true if all positions are filled with a single value" do
      assert MapSolver.new(@grid.gsub(" ", "1")).filled?
    end
  end
end


 #A1 A2 A3| A4 A5 A6| A7 A8 A9    4 . . |. . . |8 . 5     4 1 7 |3 6 9 |8 2 5 
 #B1 B2 B3| B4 B5 B6| B7 B8 B9    . 3 . |. . . |. . .     6 3 2 |1 5 8 |9 4 7
 #C1 C2 C3| C4 C5 C6| C7 C8 C9    . . . |7 . . |. . .     9 5 8 |7 2 4 |3 1 6 
#---------+---------+---------    ------+------+------    ------+------+------
 #D1 D2 D3| D4 D5 D6| D7 D8 D9    . 2 . |. . . |. 6 .     8 2 5 |4 3 7 |1 6 9 
 #E1 E2 E3| E4 E5 E6| E7 E8 E9    . . . |. 8 . |4 . .     7 9 1 |5 8 6 |4 3 2 
 #F1 F2 F3| F4 F5 F6| F7 F8 F9    . . . |. 1 . |. . .     3 4 6 |9 1 2 |7 5 8 
#---------+---------+---------    ------+------+------    ------+------+------
 #G1 G2 G3| G4 G5 G6| G7 G8 G9    . . . |6 . 3 |. 7 .     2 8 9 |6 4 3 |5 7 1 
 #H1 H2 H3| H4 H5 H6| H7 H8 H9    5 . . |2 . . |. . .     5 7 3 |2 9 1 |6 8 4 
 #I1 I2 I3| I4 I5 I6| I7 I8 I9    1 . 4 |. . . |. . .     1 6 4 |8 7 5 |2 9 3 
