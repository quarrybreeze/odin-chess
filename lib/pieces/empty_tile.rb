class EmptyTile
  
  def initialize(position)
    @symbol = " "
    @color = nil
    @name = nil
    @position = position
    @theatend_by_black = false
    @threatend_by_white = false
  end

  def symbol
    @symbol
  end

  def color
    @color
  end

  def name
    @name
  end

  def threatend_by_black?
    @threatend_by_black
  end

  def threatend_by_white?
    @threatend_by_white
  end

  def threaten_by_black
    @threatend_by_black = true
  end

  def threaten_by_white
    @threatend_by_white = true
  end

  def evade_black
    @threatend_by_black = false
  end

  def evade_white
    @threatend_by_white = false
  end

end