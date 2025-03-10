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
      @board.jump?(element,coordinates) == false   #logic to avoid jumps
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
      if @players[0].color == "white"
        @board.generate_threat_black
      else
        @board.generate_threat_white
      end
      
      if self.my_king.threatend?
        puts "You are checked and need to parry. Please move another piece."
        @board.move(coordinates,specific_piece)
        if @players[0].color == "white"
          @board.generate_threat_black
        else
          @board.generate_threat_white
        end
        self.player_turn
      end
    elsif matching_pieces.length == 0 #if invalid move, loop
      p "The #{name}, cannot move there. Please choose a valid move"
      self.player_turn
    else
      current_tile = matching_pieces.first.position
      @board.move(current_tile,coordinates)
      if @players[0].color == "white"
        @board.generate_threat_black
      else
        @board.generate_threat_white
      end
      
      if self.my_king.threatend?
        puts "You are checked and need to parry. Please move another piece."
        @board.move(coordinates,current_tile)
        if @players[0].color == "white"
          @board.generate_threat_black
        else
          @board.generate_threat_white
        end
        self.player_turn
      end
    end
  end

  private

  def my_king
    array_of_pieces = @board.tiles.flatten(2)
    my_king = array_of_pieces.select {|element|
    element.color == @players[0].color &&
    element.name == "king"
    }
    my_king = my_king.first
  end

  def check?
    check = false
    opposite_color = @players[1].color
    array_of_pieces = @board.tiles.flatten(2)
    king = array_of_pieces.select { |element|
        element.color == opposite_color &&
        element.name == "king"
    }
    if king.first.threatend?
      check = true
    end
    return check
  end

  def checkmate?
    checkmate = false
    check = self.check?
    if check
      player_color = @players[0].color
      opposite_color = @players[1].color
      array_of_pieces = @board.tiles.flatten(2)

      king = array_of_pieces.select { |element|
          element.color == opposite_color &&
          element.name == "king"
      }
      king = king.first
      king_moves = king.valid_moves.select { |coord| 
      @board.pick_tile(coord.first,coord.last).symbol == " " &&
      if player_color == "white"
        @board.pick_tile(coord.first,coord.last).threatend_by_white? == false
      else
        @board.pick_tile(coord.first,coord.last).threatend_by_black? == false
      end
      }
      if king_moves.length == 0
        checkmate = true
      end
    end

    if checkmate
      puts "Checkmate. Game over."
      @gameover = true
    elsif check
      puts "Check"
    end
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
      if @players[0].color == "white"
        @board.generate_threat_white
      else
        @board.generate_threat_black
      end
      self.king?
      # self.check?
      self.checkmate?
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
