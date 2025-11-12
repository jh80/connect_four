# frozen_string_literal: true

require 'pry-byebug'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

describe Game do
  describe '#player_input' do
    subject(:game_input) { described_class.new }
    context 'when input is a present and available column' do
      let (:board) {instance_double(Board)}
      # columns: Hash[
      #   '1', Array.new(6, '❍'), '2', Array.new(6, '❍'),
      #   '3', Array.new(6, '❍'), '4', Array.new(6, '❍'),
      #   '4', Array.new(6, '❍'), '5', ['✩', '✭' , '✩', '✭', '✩', '✭'],
      #   '6', Array.new(6, '❍'), '7', ['✩', '✭' , '✩', '✭', '✩', '✭']])}
      before do
        # I used an instance variable (@) for this variable so I could use in in a later it block 'returns player input'
        game_input.instance_variable_set(:@board, board)
        @valid_col = '3'
        allow(game_input).to receive(:gets).and_return(@valid_col)
        allow(board)
      end
      it 'does not display not_col_message' do
        not_col_message = 'This is not a column, enter and number 1-7 with no extra spaces or characters'
        expect(game_input).not_to receive(:puts).with(not_col_message)
        game_input.player_input
      end
      it 'does not display no_room_message' do
        no_room_message = 'There is no room in this column, pick a different one'
        expect(game_input).not_to receive(:puts).with(no_room_message)
        game_input.player_input
      end
      it 'returns player input' do
        expect(game_input.player_input).to eql(@valid_col)
      end
    end
    context 'when input is present but not available, then both' do
      
    end
  end
end