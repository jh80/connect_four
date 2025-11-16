# frozen_string_literal: true

#require 'pry-byebug'

class Board
  attr_reader :blank_mark, :columns

  def initialize
    @blank_mark = "❍"
    @columns = Hash['1', Array.new(6, @blank_mark), '2', Array.new(6, @blank_mark), '3', Array.new(6, @blank_mark), '4', Array.new(6, @blank_mark), '5', Array.new(6, @blank_mark), '6', Array.new(6, @blank_mark), '7', Array.new(6, @blank_mark)]
  end
  def valid_column?(choice)
    valid_cols = self.columns.keys
    return true if valid_cols.include?(choice)
    return false
  end

  def available_column?(choice)
    return columns[choice][5] == blank_mark unless columns[choice].nil?
  end

  def approved_choice?(choice)
    return false unless valid_column?(choice)
    return false unless available_column?(choice)
    true
  end

  def place_choice(choice, player)
    for i in (0..5)
      if columns[choice][i] == '❍'
        columns[choice][i] = player.mark
        break
      end
    end
  end

  def winner?(player)
    return true if vertical_win?(player)
    return true if horizontal_win?(player)
    return true if diagonal_win?(player)
    false
  end

  def filled?
    columns.each_value do |column|
      return false if column[5] == blank_mark
    end
    true
  end

  def print_board
    i = 6
    while i >= 0 do
      @columns.each do |column_id, column|
        print column[i]
        print ' ' unless column_id == '7' 
      end
      puts ''
      i -= 1
    end
    @columns.each do |column_id, column|
      print column_id
      print ' ' unless column_id == '7'
    end
    puts ''
  end

  private

  def vertical_win?(player)
    columns.each do |col_num, col_slots|
      count = 0
      for i in (0..5) 
        col_slots[i] == player.mark ? count += 1 : count = 0
        return true if count == 4
      end
    end
    return false
  end

  def horizontal_win?(player)
    for i in (0..5)
      count = 0
      columns.each_value do |column|
        column[i] == player.mark ? count +=1 : count = 0
        return true if count == 4
      end
    end
    return false
  end

  def diagonal_win?(player)
    # Search for 4 consecutive player marks going diagonal up L and R from each slot
    for i in (0..5)
      columns.each do |col_id, column|
        return true if cont_diag_from_here?(col_id.to_i, i, -1, player.mark) # Search diagonal going left
        return true if cont_diag_from_here?(col_id.to_i, i, 1, player.mark) # Search diagonal going right
      end 
    end
    return false
  end


  def cont_diag_from_here?(col, i, x_move, mark)
    count = 0
    until i > 5 || col < 1 || col > 7 do
      if columns[col.to_s][i] == mark
        count += 1
        return true if count == 4
      else
        return false
      end
      i += 1
      col += x_move
    end
    false
  end
end