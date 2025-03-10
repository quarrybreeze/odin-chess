class Piece

  attr_reader :color, :name
  attr_accessor :position
  
  def initialize(name, color, position)
    @name = name
    @color = color
    @position = position
    @threatend = false
  end

  def move(new_position)
    @position = new_position
  end

  def name
    @name
  end

  def color
    @color
  end

  def threatend?
    @threatend
  end

  def threaten
    @threatend = true
  end

  def evade
    @threatend = false
  end

end

# pawn = Piece.new("white",[0,2])
# p pawn