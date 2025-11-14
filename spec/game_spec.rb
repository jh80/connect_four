# frozen_string_literal: true

require 'pry-byebug'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

describe Game do
  describe '#player_input' do
    subject(:game_input) { described_class.new }
    let (:board) {instance_double(Board,
        columns: Hash[
          '1', Array.new(6, '❍'), '2', Array.new(6, '❍'),
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'),
          '4', Array.new(6, '❍'), '5', ['✩', '✭' , '✩', '✭', '✩', '✭'],
          '6', Array.new(6, '❍'), '7', ['✩', '✭' , '✩', '✭', '✩', '✭']])}
    let(:valid_col) {'3'}
    let(:letter) {'a'}
    let(:three_dig) {'204'}  
    let(:unavail_col) {'7'}
    let(:unavail_col_middle) {'5'}
    let(:valid_col2) {'4'}
    let(:no_room_message) {'There is no room in this column, pick a different one'}
    let(:not_col_message) {'This is not a column, enter and number 1-7 with no extra spaces or characters'}
    before do
      game_input.instance_variable_set(:@board, board)
      allow(game_input).to receive(:puts).with('Please enter the number of the column you wish to place your token')
      allow(game_input).to receive(:puts).with('This is not a column, enter and number 1-7 with no extra spaces or characters')
      allow(game_input).to receive(:puts).with('There is no room in this column, pick a different one')
    end
    context 'when input is a present and available column' do
      before do
        allow(game_input).to receive(:gets).and_return(valid_col)
        allow(board).to receive(:valid_column?).with(valid_col).and_return(true)
        allow(board).to receive(:available_column?).with(valid_col).and_return(true)
      end
      it 'does not display not_col_message' do
        expect(game_input).not_to receive(:puts).with(not_col_message)
        game_input.player_input
      end
      it 'does not display no_room_message' do
        expect(game_input).not_to receive(:puts).with(no_room_message)
        game_input.player_input
      end
      it 'returns player input' do
        expect(game_input.player_input).to eql(valid_col)
      end
    end
    context 'when input is present but not available, then both' do
      before do
        allow(game_input).to receive(:gets).and_return(unavail_col, valid_col2)

        allow(board).to receive(:valid_column?).with(unavail_col).and_return(true)
        allow(board).to receive(:valid_column?).with(valid_col2).and_return(true)
        allow(board).to receive(:available_column?).with(valid_col2).and_return(true)
        allow(board).to receive(:available_column?).with(unavail_col).and_return(false)
      end
      it 'displays no_room_message' do
        expect(game_input).to receive(:puts).with(no_room_message)
        game_input.player_input
      end
      it 'does not display not_col message' do
        expect(game_input).not_to receive(:puts).with(not_col_message)
        game_input.player_input
      end
      it 'returns valid player input' do
        expect(game_input.player_input).to eql(valid_col2)
      end
    end
    
    context 'when input is not valid twice, then unavailable then, valid and available' do
      before do
        allow(game_input).to receive(:gets).and_return(letter, three_dig, unavail_col_middle, valid_col)

        allow(board).to receive(:valid_column?).with(unavail_col_middle).and_return(true)
        allow(board).to receive(:valid_column?).with(valid_col).and_return(true)
        allow(board).to receive(:valid_column?).with(letter).and_return(false)
        allow(board).to receive(:valid_column?).with(three_dig).and_return(false)
        allow(board).to receive(:available_column?).with(valid_col).and_return(true)
        allow(board).to receive(:available_column?).with(unavail_col_middle).and_return(false)
        allow(board).to receive(:available_column?).with(letter).and_return(false)
        allow(board).to receive(:available_column?).with(three_dig).and_return(false)
      end
      it 'displays not a column message twice' do
        expect(game_input).to receive(:puts).with(not_col_message).twice
        game_input.player_input
      end

      it 'displays unavailable message once' do
        expect(game_input).to receive(:puts).with(no_room_message).once
        game_input.player_input
      end

      it 'returns valid and available input' do
        expect(game_input.player_input).to eql(valid_col)
      end
    end

    context 'when input is unavailable twice, then not a column, then available and a column' do
      before do
        allow(game_input).to receive(:gets).and_return(unavail_col, unavail_col_middle, three_dig, valid_col)

        allow(board).to receive(:valid_column?).with(unavail_col).and_return(true)
        allow(board).to receive(:valid_column?).with(unavail_col_middle).and_return(true)
        allow(board).to receive(:valid_column?).with(valid_col).and_return(true)
        allow(board).to receive(:valid_column?).with(three_dig).and_return(false)
        allow(board).to receive(:available_column?).with(unavail_col).and_return(false)
        allow(board).to receive(:available_column?).with(valid_col).and_return(true)
        allow(board).to receive(:available_column?).with(unavail_col_middle).and_return(false)
        allow(board).to receive(:available_column?).with(three_dig).and_return(false)
      end
      it 'displays not a column message once' do
        expect(game_input).to receive(:puts).with(not_col_message)
        game_input.player_input
      end
      it 'displays unavailable message twice' do
        expect(game_input).to receive(:puts).with(no_room_message)
        game_input.player_input
      end
      it 'returns valid and available input' do
        expect(game_input.player_input).to eql(valid_col)
      end
    end

    context 'when input is not a column, then a column and available' do
      before do
        allow(game_input).to receive(:gets).and_return(letter, valid_col)

        allow(board).to receive(:valid_column?).with(valid_col).and_return(true)
        allow(board).to receive(:valid_column?).with(letter).and_return(false)
        allow(board).to receive(:available_column?).with(valid_col).and_return(true)
        allow(board).to receive(:available_column?).with(letter).and_return(false)
      end
      it 'displays not a column message once' do
        expect(game_input).to receive(:puts).with(not_col_message)
        game_input.player_input
      end

      it 'does not display no room message' do
        expect(game_input).not_to receive(:puts).with(no_room_message)
        game_input.player_input
      end

      it 'returns valid and available input' do
        expect(game_input.player_input).to eql(valid_col)
      end
    end
  end

  describe '#take_turn' do
    subject(:game_turn) { described_class.new }
    # let(:board) { instance_double(Board) }
    let(:player_t) { instance_double(Player) }

    before do
      allow(game_turn.instance_variable_get(:@board)).to receive(:place_choice)
      allow(game_turn.instance_variable_get(:@board)).to receive(:print_board)
      allow(game_turn).to receive(:player_input).and_return('3')
    end
    it 'place_choice is called on an instance of Board' do
      expect(game_turn.instance_variable_get(:@board)).to receive(:place_choice).once
      game_turn.take_turn(player_t)
    end
    it 'print_board is called on an instance of Board' do
      expect(game_turn.instance_variable_get(:@board)).to receive(:print_board).once
      game_turn.take_turn(player_t)
    end
  end
end