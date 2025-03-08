require_relative 'piece'

class Rook < Piece
  
  def symbol
    if @color == "white"
      "\u2656" #♖ white rook
    elsif @color == "black"
      "\u265C" #♜ black rook
    end
  end

  def valid_moves
    
  end

end