# frozen_string_literal: true

require_relative './game'
require_relative './player'
require_relative './board'

class Game
  def initialize
    @board = Board.new
    @players = [ Player.new('player 1', '✩'), Player.new('player 2', '✭') ]
    @messages = {
      intro_instructions: "Let\'s play connect four!
      Choose a column number 1-7 to drop your player token.
      Your token will take the lowest available slot in that column.
      Your goal is to get four of your tokens in a row (vertically, 
      horizontally, or diagonally) before your opponent.

      Let\'s begin!",
      winner_announcement: 'has won! Congratulations!'
    }
  end

  def player_input(player)
    puts player.name + ', please enter the number of the column you wish to place your token'
    loop do
      choice = gets.chomp
      is_column = @board.valid_column?(choice)
      is_avail = @board.available_column?(choice)
      return choice if is_column && is_avail
      if !is_column
        puts 'This is not a column, enter and number 1-7 with no extra spaces or characters'
      else
        puts 'There is no room in this column, pick a different one' 
      end
    end
  end

  def take_turn(player)
    choice = player_input(player)
    @board.place_choice(choice, player)
    @board.print_board
  end

  def rotate_turns_til_winner(players)
    loop do
      players.each do |player|
        take_turn(player)
        return player if @board.winner?(player)
      end 
    end
  end
    
  def play
    puts @messages[:intro_instructions]
    @board.print_board
    winner = rotate_turns_til_winner(@players)
    puts "\n#{winner.name} #{@messages[:winner_announcement]}"
  end
end