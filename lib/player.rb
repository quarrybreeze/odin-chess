class Player

  attr_accessor :color
  
  def initialize(color = nil)
    @color = color
  end

  def choose_color
    loop do
      puts "Choose color: white/black"
      input = gets.downcase.chomp

      if input == "white" || input == "black"
        @color = input
        break
      else
        puts "Color must be either white or black. Please try again."
      end
    end
  end

end