require_relative 'board'
require_relative 'computer'
require_relative 'player'

class Game
  
  def initialize
    @board = Board.new
    @players = []
    @gameover = false
    self.play_game
  end

  def display
    @board.display
  end

  def make_move (name,coordinates)
    current_player = @players[0].color
    x_coord = coordinates.first
    y_coord = coordinates.last

    matching_pieces = []

    array_of_pieces = @board.tiles.flatten(2)
    matching_pieces = array_of_pieces.select { |element|
      element.color == current_player &&
      element.name == name &&
      element.valid_moves.include?(coordinates)
    }
    # this is where i should add logic for pawn attacks and collissions


    target_tile = @board.pick_tile(coordinates.first,coordinates.last)
    target_tile_color = @board.pick_tile(coordinates.first,coordinates.last).color

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
      p "error, not a valid move, please try again"
      self.player_turn
    else
      current_tile = matching_pieces.first.position
      @board.move(current_tile,coordinates)
    end
  end

  private

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
