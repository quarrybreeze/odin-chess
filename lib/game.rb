require_relative 'board'
require_relative 'computer'
require_relative 'player'

class Game
  
  def initialize
    @board = Board.new
    @players = []
    @gameover = false
    self.play_game
    # p self.jump?(@board.pick_tile(2,0),[0,2])
  end

  def display
    @board.display
  end

  def king?
    array_of_pieces = @board.tiles.flatten(2)
    alive_kings = array_of_pieces.select { |tiles| tiles.name == "king"}

    if alive_kings.length < 2
      puts "King down."
      puts "Winner is #{alive_kings.first.color}"
      @gameover = true
    end
  end

  def make_move (name,coordinates)
    current_player = @players[0].color
    x_coord = coordinates.first
    y_coord = coordinates.last
    target_tile = @board.pick_tile(x_coord,y_coord)
    target_tile_color = @board.pick_tile(x_coord,y_coord).color

    matching_pieces = []

    array_of_pieces = @board.tiles.flatten(2)
    matching_pieces = array_of_pieces.select { |element|
      element.color == current_player &&
      element.name == name &&
      element.valid_moves.include?(coordinates) &&
      self.jump?(element,coordinates) == false   #logic to avoid jumps
    }

    #logic to avoid pawns moving diagonally without attacking
    if name == "pawn" && target_tile.symbol == " "
      matching_pieces = matching_pieces.select { |element| 
      element.position.first == x_coord
    }
    elsif name == "pawn" && target_tile.symbol != " " 
      matching_pieces = matching_pieces.select { |element| 
      element.position.first == x_coord+1 ||
      element.position.first == x_coord-1
    }
    end
    
    if target_tile_color == current_player #avoid friendly fire
      puts "You cannot attack your own pieces, try again"
      self.player_turn
    elsif matching_pieces.length > 1 #if multiple pieces match the move, prompt user to choose which piece they meant
      puts "Which #{name}? Choose one from the following:"
      matching_pieces.each do |piece|
        p piece.position
      end
      specific_piece = gets.chomp.split(",").map(&:to_i)
      @board.move(specific_piece,coordinates)
    elsif matching_pieces.length == 0 #if invalid move, loop
      p "The #{name}, cannot move there. Please choose a valid move"
      self.player_turn
    else
      current_tile = matching_pieces.first.position
      @board.move(current_tile,coordinates)
    end
  end

  private


  def check?
    check = false
    checkmate = false

    player_color = @players[0].color
    opposite_color = @players[1].color
    array_of_pieces = @board.tiles.flatten(2)

    #get king position
    king = array_of_pieces.select { |element|
    element.color == opposite_color &&
    element.name == "king"
    }
    king_piece = king.first
    king_position = king_piece.position
    
    coordinates = []
    for row in 0..7
      for column in 0..7
        coordinates << [row,column]
      end
    end





    #is the king in check?
    king_attackers = array_of_pieces.select { |element|
    element.color == player_color &&
    element.valid_moves.include?(king_position) &&
    self.jump?(element,king_position) == false  &&    #logic to avoid jumps
    (element.name != "pawn" ||                        #logic to include only pawns that are diagonal from king
    element.position.first == king_position.first+1 ||
    element.position.first == king_position.first-1)
    }

    #is the king in checkmate?
    king_moves = king_piece.valid_moves
    king_moves = king_moves.select { |element| 
    @board.pick_tile(element.first,element.last).symbol == " " ||
    @board.pick_tile(element.first,element.last).color == player_color
    }

    unsafe_moves = []

    king_moves.each do |move|
      is_attacked = array_of_pieces.any? do |element|
        next if element.is_a?(EmptyTile)
        element.color != opposite_color &&  # Enemy pieces only
        element.valid_moves.include?(move) &&
        self.jump?(element, move) == false &&     # Ensure no jumping
        (element.name != "pawn" ||        # Special pawn attack logic
        element.position.first == move.first + 1 ||
        element.position.first == move.first - 1)
      end
      if is_attacked
        unsafe_moves << move
      end
    end
    # p unsafe_moves
    # p king_moves
    safe_moves = king_moves - unsafe_moves

    # p "King's safe moves: #{safe_moves}"

    if king_attackers.length > 0
      check = true
    end

    if check == true && safe_moves.length == 0
      checkmate = true
      @gameover = true
    end

    if checkmate == true
      puts "Checkmate"
    elsif check == true
      puts "Check"
    end
    
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
    @board.pick_tile(element.first,element.last).symbol != " " 
    }

    if occupied_tiles.length > 0
      jump = true
    end

    if object.name == "knight"
      jump = false
    end

    return jump
  end

  def player_turn
    current_player = @players[0].color
    puts "Current move: #{current_player}"
    puts "Provide a move in the format: {piece} to X,Y"
    input = gets.chomp
    split_input = input.split(" to ")
    name = split_input.first.downcase
    coordinates = split_input.last.split(",").map(&:to_i)
    # p name
    # p coordinates
    self.make_move(name,coordinates)
    self.display
  end


  


  def play_game
    self.create_player
    self.create_computer
    self.white_first
    while @gameover == false
      self.player_turn
      self.king?
      self.check?
      self.switch_player
    end

  end

  def create_player
    player = Player.new
    player.choose_color
    @players << player
  end

  def create_computer
    if @players[0].color == "white"
      computer = Player.new("black")
    elsif @players[0].color == "black"
      computer = Player.new("white")
    end
    @players << computer
  end

  def white_first
    if @players[0].color == "black"
      @players = @players.rotate
    end
  end

  def switch_player
    @players = @players.rotate
  end

end

game = Game.new
# game.display
# game.make_move("pawn",[0,3])
# game.display
