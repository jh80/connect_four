# frozen_string_literal: true

class Player
  attr_reader :mark, :name

  def initialize(name, mark)
    @name = name
    @mark = mark
  end
end