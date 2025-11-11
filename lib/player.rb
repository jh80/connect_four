# frozen_string_literal: true

class Player
  attr_reader :mark

  def initialize(name, mark)
    @name = name
    @mark = mark
  end

  # Delete this if I put player_input in game
  # 
  # def player_input(board)
    
  # end
  # private
  # def request_choice
  #   puts "#{@name}, enter the number of the column you would like to place your token in."
  #   gets.chomp
  # end
end