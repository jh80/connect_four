# frozen_string_literal: true

class Board
  def valid_column?
    
  end

  def available_column?
    
  end

  def approved_choice?(choice)
    return false unless valid_column?
    return false unless available_column?
    true
  end
end