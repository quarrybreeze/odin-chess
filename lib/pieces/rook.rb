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

# rook = Rook.new("white",[0,0])
# p rook.valid_moves