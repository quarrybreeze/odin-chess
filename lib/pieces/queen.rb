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
    valid_moves = []
    for i in 1..7
      #up
      valid_moves << [@position.first+i,@position.last]
      #down
      valid_moves << [@position.first-i,@position.last]
      #left
      valid_moves << [@position.first,@position.last-i]
      #right
      valid_moves << [@position.first,@position.last+i]
      #upleft
      valid_moves << [@position.first+i,@position.last-i]
      #upright
      valid_moves << [@position.first+i,@position.last+i]
      #downleft
      valid_moves << [@position.first-i,@position.last-i]
      #downright
      valid_moves << [@position.first-i,@position.last+i]
    end
    #remove out of bounds moves
    valid_moves = valid_moves.select {|element| 
      element.first >= 0 &&
      element.first < 8 &&
      element.last >= 0 &&
      element.last < 8 }
    return valid_moves
  end

end