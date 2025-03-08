require_relative 'piece'

class Queen < Piece
  
  def symbol
    if @color == "white"
      "\u2655" #♕ white queen
    elsif @color == "black"
      "\u265B" #♛ black queen
    end
  end

  def valid_moves
    
  end

end