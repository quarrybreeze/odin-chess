require_relative 'piece'

class Bishop < Piece
  
  def symbol
    if @color == "white"
      "\u2657" #♗ white bishop
    elsif @color == "black"
      "\u265D" #♝ black bishop
    end
  end

  def valid_moves
    
  end


end