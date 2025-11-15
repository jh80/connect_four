# frozen_string_literal: true

class Game
  def initialize
    @board = Board.new
  end

  def player_input
    puts 'Please enter the number of the column you wish to place your token'
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
    choice = player_input
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
end