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
    valid_moves = []
    for i in 1..1
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

# king = King.new("white",[3,3])
# p king.valid_moves