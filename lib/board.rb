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

  def generate_threat_white
    all_objects = @tiles.flatten(2)
    
    white_objects = all_objects.select {|object| object.color == "white"}
    black_objects = all_objects.select {|object| object.color == "black"}
    open_tiles = all_objects - white_objects - black_objects


    #reset white threat
    black_objects.each do |object|
      object.evade
    end

    open_tiles.each do |object|
      object.evade_white
    end

    #generate threat by white
    coord_threatened_by_white = []
    white_objects.each do |white_piece|
      valid_moves = white_piece.valid_moves
      valid_moves = valid_moves.select { |move|
        self.jump?(white_piece,move) == false &&
        @tiles[move.first][move.last].color != "white" &&
        (white_piece.name != "pawn" ||
        white_piece.position.first == move.first+1 ||
        white_piece.position.first == move.first+1)
      } 
      coord_threatened_by_white << valid_moves
    end
    coord_threatened_by_white = coord_threatened_by_white.flatten(1).uniq
    coord_threatened_by_white.each do |coord|
      if @tiles[coord.first][coord.last].symbol == " "
        @tiles[coord.first][coord.last].threaten_by_white
      else
        @tiles[coord.first][coord.last].threaten
      end
    end
    # open_tiles_threatened_by_white = open_tiles.select {|tile| tile.threatend_by_white?}
    # black_pieces_threatened = black_objects.select {|piece| piece.threatend?}
    # puts "Open tiles threatened by white: #{open_tiles_threatened_by_white}"
    # puts "Black pieces threatened by white: #{black_pieces_threatened}"
    # puts "Coords threatened by white: #{coord_threatened_by_white}"
  end

  def generate_threat_black
    all_objects = @tiles.flatten(2)
    
    white_objects = all_objects.select {|object| object.color == "white"}
    black_objects = all_objects.select {|object| object.color == "black"}
    open_tiles = all_objects - white_objects - black_objects


    #reset black threat
    white_objects.each do |object|
      object.evade
    end

    open_tiles.each do |object|
      object.evade_black
    end

    #generate threat by white
    coord_threatened_by_black = []
    black_objects.each do |black_piece|
      valid_moves = black_piece.valid_moves
      valid_moves = valid_moves.select { |move|
        self.jump?(black_piece,move) == false &&
        @tiles[move.first][move.last].color != "black" &&
        (black_piece.name != "pawn" ||
        black_piece.position.first == move.first+1 ||
        black_piece.position.first == move.first+1)
      } 
      coord_threatened_by_black << valid_moves
    end
    coord_threatened_by_black = coord_threatened_by_black.flatten(1).uniq
    coord_threatened_by_black.each do |coord|
      if @tiles[coord.first][coord.last].symbol == " "
        @tiles[coord.first][coord.last].threaten_by_black
      else
        @tiles[coord.first][coord.last].threaten
      end
    end
    # open_tiles_threatened_by_black = open_tiles.select {|tile| tile.threatend_by_black?}
    # white_pieces_threatened = white_objects.select {|piece| piece.threatend?}
    # puts "Open tiles threatened by black: #{open_tiles_threatened_by_black}"
    # puts "White pieces threatened by black: #{white_pieces_threatened}"
    # puts "Coords threatened by white: #{coord_threatened_by_black}"
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

  def jump?(object,target)
    jump = false
    tile_queue = []

    start_x = object.position.first
    start_y = object.position.last
    target_x = target.first
    target_y = target.last

    if (start_y == target_y && #right
      target_x > start_x)
      # p "right"
      for x in start_x..target_x
        tile_queue << [x, start_y]
      end
    elsif (start_y == target_y && #left
          target_x < start_x)
          # p "left"
      for x in target_x..start_x
        tile_queue << [x, start_y]
      end
    elsif (start_x == target_x && #up
          target_y > start_y)
          # p "up"
      for y in start_y..target_y
        tile_queue << [start_x, y]
      end
    elsif (start_x == target_x && #down
          target_y < start_y)
          # p "down"
      for y in target_y..start_y
        tile_queue << [start_x, y]
      end
    elsif (start_y < target_y && #upright
        start_x < target_x)
        diag_y = start_y
      # p "upright"
      for x in start_x..target_x
        tile_queue << [x,diag_y]
        diag_y += 1
      end
    elsif (start_y < target_y && #upleft
      start_x > target_x)
      # p "upleft"
      diag_x = start_x
      for y in start_y..target_y
        tile_queue << [diag_x,y]
        diag_x -= 1
      end
    elsif (start_y > target_y && #downright
      start_x < target_x)
      diag_y = start_y
      # p "downright"
      for x in start_x..target_x
        tile_queue << [x,diag_y]
        diag_y -= 1
      end
    elsif (start_y > target_y && #downleft
      start_x > target_x)
      diag_x = target_x
      # p "downleft"
      for y in target_y..start_y
        tile_queue << [diag_x,y]
        diag_x += 1
      end
    end

    tile_queue.pop
    tile_queue.shift

    occupied_tiles = tile_queue.select { |element| 
    @tiles[element.first][element.last].symbol != " " 
    }

    if occupied_tiles.length > 0
      jump = true
    end

    if object.name == "knight"
      jump = false
    end

    return jump
  end

  def move(from,to)
    old_x = from.first
    old_y = from.last
    next_x = to.first
    next_y = to.last

    piece_to_move = @tiles[old_x][old_y]
    piece_to_move.move([next_x,next_y])
    @tiles[next_x][next_y] = piece_to_move
    @tiles[old_x][old_y] = EmptyTile.new(from)
  end

  def place_pieces
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
      @tiles[i][2] = EmptyTile.new([i,2])
      @tiles[i][3] = EmptyTile.new([i,3])
      @tiles[i][4] = EmptyTile.new([i,4])
      @tiles[i][5] = EmptyTile.new([i,5])
      @tiles[i][6] = Pawn.new("pawn","black",[i,6])
    end
  end
end

# board = Board.new
# p board.jump?(board.pick_tile(0,1),[0,3])
# board.generate_threat
# board.display
# board.move([0,1],[0,3])
# board.display