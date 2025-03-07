class Piece

  attr_reader :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

end

# pawn = Piece.new("white",[0,2])
# p pawn