require_relative 'piece'

class Pawn < Piece

  def symbol
    if @color == "white"
      "\u2659" #♙ white pawn
    elsif @color == "black"
      "\u265F" #♟ black pawn
    end
  end
  
  def valid_moves
    valid_moves = []
    if @color == "white"
      #moving forward
      if @position.last == 1 
        valid_moves << [@position.first,@position.last+2]
      else
        valid_moves << [@position.first,@position.last+1]
      end
      #attacking diagonal
      valid_moves << [@position.first+1,@position.last+1]
      valid_moves << [@position.first-1,@position.last+1]
    elsif @color == "black"
      #moving forward
      if @position.last == 6 
        valid_moves << [@position.first,@position.last-2]
      else
        valid_moves << [@position.first,@position.last-1]
      end
      #attacking diagonal
      valid_moves << [@position.first+1,@position.last-1]
      valid_moves << [@position.first-1,@position.last-1]
    end
    valid_moves = valid_moves.select {|element| 
    element.first >= 0 &&
    element.first < 8 &&
    element.last >= 0 &&
    element.last < 8 }
    return valid_moves
  end

end

# pawn = Pawn.new("black",[0,6])
# p pawn
# p pawn.valid_moves
# p pawn.symbol
#U+2659