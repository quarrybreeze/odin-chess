require_relative 'piece'

class King < Piece

  def symbol
    if @color == "white"
      "\u2654" #♔ white king
    elsif @color == "black"
      "\u265A" #♚ black king
    end
  end

  def valid_moves
    
  end
  
end