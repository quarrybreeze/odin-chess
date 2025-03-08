require_relative 'piece'

class Knight < Piece
    
  def symbol
    if @color == "white"
      "\u2658" #♘ white knight
    elsif @color == "black"
      "\u265E" #♞ black knight
    end
  end

  def valid_moves
    
  end
end