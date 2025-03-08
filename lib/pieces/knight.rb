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
    valid_moves = []
    valid_moves << [@position.first+1,@position.last+2]
    valid_moves << [@position.first-1,@position.last+2]
    valid_moves << [@position.first+1,@position.last-2]
    valid_moves << [@position.first-1,@position.last-2]
    valid_moves << [@position.first+2,@position.last+1]
    valid_moves << [@position.first-2,@position.last+1]
    valid_moves << [@position.first+2,@position.last-1]
    valid_moves << [@position.first-2,@position.last-1]
    valid_moves = valid_moves.select {|element| 
    element.first >= 0 &&
    element.first < 8 &&
    element.last >= 0 &&
    element.last < 8 }
  return valid_moves
  end
end