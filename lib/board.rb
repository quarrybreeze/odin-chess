require_relative 'pieces/bishop'
require_relative 'pieces/king'
require_relative 'pieces/knight'
require_relative 'pieces/pawn'
require_relative 'pieces/queen'
require_relative 'pieces/rook'
require_relative 'pieces/empty_tile'

class Board
  
  attr_accessor :tiles

  def initialize
    @tiles = Array.new(8) { Array.new(8) {" "}} #format: [column][row]
    self.place_pieces
    self.display
  end

  def pick_tile(x,y)
    @tiles[x][y]
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

  def move(from,to)
    old_x = from.first
    old_y = from.last
    next_x = to.first
    next_y = to.last

    piece_to_move = @tiles[old_x][old_y]
    piece_to_move.move([next_x,next_y])
    @tiles[next_x][next_y] = piece_to_move
    @tiles[old_x][old_y] = EmptyTile.new
  end

  def place_pieces #update with pieces as they are made.
    @tiles[0][0] = Rook.new("rook","white",[0,0])
    @tiles[1][0] = Knight.new("knight","white",[1,0])
    @tiles[2][0] = Bishop.new("bishop","white",[2,0])
    @tiles[3][0] = Queen.new("queen","white",[3,0])
    @tiles[4][0] = King.new("king","white",[4,0])
    @tiles[5][0] = Bishop.new("bishop","white",[5,0])
    @tiles[6][0] = Knight.new("knight","white",[6,0])
    @tiles[7][0] = Rook.new("rook","white",[7,0])
    @tiles[0][7] = Rook.new("rook","black",[0,7])
    @tiles[1][7] = Knight.new("knight","black",[1,7])
    @tiles[2][7] = Bishop.new("bishop","black",[2,7])
    @tiles[3][7] = Queen.new("queen","black",[3,7])
    @tiles[4][7] = King.new("king","black",[4,7])
    @tiles[5][7] = Bishop.new("bishop","black",[5,7])
    @tiles[6][7] = Knight.new("knight","black",[6,7])
    @tiles[7][7] = Rook.new("rook","black",[7,7])
    for i in 0..7
      @tiles[i][1] = Pawn.new("pawn","white",[i,1])
      @tiles[i][2] = EmptyTile.new
      @tiles[i][3] = EmptyTile.new
      @tiles[i][4] = EmptyTile.new
      @tiles[i][5] = EmptyTile.new
      @tiles[i][6] = Pawn.new("pawn","black",[i,6])
    end
  end
end

# board = Board.new
# board.display
# board.move([0,1],[0,3])
# board.display