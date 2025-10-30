# frozen_string_literal: true

class Board
  attr_reader :blank_mark, :columns

  def initialize
    @blank_mark = "❍"
    @columns = Hash['1', Array.new(6, @blank_mark), '2', Array.new(6, @blank_mark), '3', Array.new(6, @blank_mark), '4', Array.new(6, @blank_mark), '5', Array.new(6, @blank_mark), '6', Array.new(6, @blank_mark), '7', Array.new(6, @blank_mark)]
  end
  def valid_column?(choice)
    valid_cols = ['1', '2', '3', '4', '5', '6', '7']
    return true if valid_cols.include?(choice)
    return false
  end

  def available_column?(choice)
    return columns[choice][5] == blank_mark
  end

  def approved_choice?(choice)
    return false unless valid_column?(choice)
    return false unless available_column?(choice)
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
end