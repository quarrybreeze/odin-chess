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
    valid_moves = []
    for i in 1..7
      #upleft
      valid_moves << [@position.first+i,@position.last-i]
      #upright
      valid_moves << [@position.first+i,@position.last+i]
      #downleft
      valid_moves << [@position.first-i,@position.last-i]
      #downright
      valid_moves << [@position.first-i,@position.last+i]
    end
    valid_moves = valid_moves.select {|element| 
      element.first >= 0 &&
      element.first < 8 &&
      element.last >= 0 &&
      element.last < 8 }
    return valid_moves
  end

end

# bishop = Bishop.new("white",[2,0])
# p bishop.valid_moves