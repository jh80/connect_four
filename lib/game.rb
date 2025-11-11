# frozen_string_literal: true

class Game
  def initialize
    #@players = [Player.new('player 1', '✩'), Player.new('player 2', '✭')] 
    @board = Board.new
  end

  def take_turn(player)
    player.get_choice

  end

  def player_input
    input = request_choice
    until @board.valid_column?(input)
      puts "Your choice was not a valid column. Choose from 1, 2, 3, 4, 5, 6, 7"
      input = request_choice
    end
    until @board.available_column?(input)
      puts "Your choice column is full, please select another"
      input = request_choice
    end
  end

  private
  def request_choice
    puts "-, enter the number of the column you would like to place your token in."
    gets.chomp
  end
end