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
    columns = "   a b c d e f g h "
    puts columns
    for row in (7).downto(0)
      puts "#{row+1} |" + 
      @tiles[0][row].symbol + "|" +
      @tiles[1][row].symbol + "|" +
      @tiles[2][row].symbol + "|" +
      @tiles[3][row].symbol + "|" +
      @tiles[4][row].symbol + "|" +
      @tiles[5][row].symbol + "|" +
      @tiles[6][row].symbol + "|" +
      @tiles[7][row].symbol + "|" +
      " #{row+1}"
    end
    puts columns
  end

  def place_pieces #update with pieces as they are made.
    for i in 0..7
      @tiles[i][0] = EmptyTile.new
      @tiles[i][1] = Pawn.new("white",[i,1])
      @tiles[i][2] = EmptyTile.new
      @tiles[i][3] = EmptyTile.new
      @tiles[i][4] = EmptyTile.new
      @tiles[i][5] = EmptyTile.new
      @tiles[i][6] = Pawn.new("black",[i,6])
      @tiles[i][7] = EmptyTile.new
    end
  end

end

board = Board.new
board.display