require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/empty_tile'

class Board
  
  def initialize
    @tiles = Array.new(8) { Array.new(8) {" "}} #format: [column][row]
    self.place_pieces
  end

  def display 
    # columns = "   a b c d e f g h "
    columns = "   0 1 2 3 4 5 6 7 "
    puts columns
    for row in (7).downto(0)
      puts "#{row} |" + 
      @tiles[0][row].symbol + "|" +
      @tiles[1][row].symbol + "|" +
      @tiles[2][row].symbol + "|" +
      @tiles[3][row].symbol + "|" +
      @tiles[4][row].symbol + "|" +
      @tiles[5][row].symbol + "|" +
      @tiles[6][row].symbol + "|" +
      @tiles[7][row].symbol + "|" +
      " #{row}"
    end
    puts columns
  end

  def place_pieces #update with pieces as they are made.
    @tiles[0][0] = Rook.new("white",[0,0])
    @tiles[1][0] = Knight.new("white",[1,0])
    @tiles[2][0] = Bishop.new("white",[2,0])
    @tiles[3][0] = Queen.new("white",[3,0])
    @tiles[4][0] = King.new("white",[4,0])
    @tiles[5][0] = Bishop.new("white",[5,0])
    @tiles[6][0] = Knight.new("white",[6,0])
    @tiles[7][0] = Rook.new("white",[7,0])
    @tiles[0][7] = Rook.new("black",[0,0])
    @tiles[1][7] = Knight.new("black",[1,0])
    @tiles[2][7] = Bishop.new("black",[2,0])
    @tiles[3][7] = Queen.new("black",[3,0])
    @tiles[4][7] = King.new("black",[4,0])
    @tiles[5][7] = Bishop.new("black",[5,0])
    @tiles[6][7] = Knight.new("black",[6,0])
    @tiles[7][7] = Rook.new("black",[7,0])
    for i in 0..7
      @tiles[i][1] = Pawn.new("white",[i,1])
      @tiles[i][2] = EmptyTile.new
      @tiles[i][3] = EmptyTile.new
      @tiles[i][4] = EmptyTile.new
      @tiles[i][5] = EmptyTile.new
      @tiles[i][6] = Pawn.new("black",[i,6])
    end
  end
end

board = Board.new
board.display