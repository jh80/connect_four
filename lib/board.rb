# frozen_string_literal: true

class Board
  def valid_column?(choice)
    valid_cols = ['1', '2', '3', '4', '5', '6', '7']
    return true if valid_cols.include?(choice)
    return false
  end

  def available_column?
    
  end

  def approved_choice?(choice)
    return false unless valid_column?(choice)
    return false unless available_column?
    true
  end
end