# frozen_string_literal: true

require 'pry-byebug'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

describe Game do
  describe '#player_input' do
    subject(:game_input) { described_class.new }
    let(:player1) { instance_double(Player, name: 'player 1', mark: '✩')}
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
    let(:no_room_message) {game_input.instance_variable_get(:@messages)[:no_room_message]}
    let(:not_col_message) {game_input.instance_variable_get(:@messages)[:not_col_message]}
    before do
      game_input.instance_variable_set(:@board, board)
      allow(game_input).to receive(:puts).with(player1.name + game_input.instance_variable_get(:@messages)[:turn_intro])
      allow(game_input).to receive(:puts).with(not_col_message)
      allow(game_input).to receive(:puts).with(no_room_message)
    end
    context 'when input is a present and available column' do
      before do
        allow(game_input).to receive(:gets).and_return(valid_col)
        allow(board).to receive(:valid_column?).with(valid_col).and_return(true)
        allow(board).to receive(:available_column?).with(valid_col).and_return(true)
      end
      it 'does not display not_col_message' do
        expect(game_input).not_to receive(:puts).with(not_col_message)
        game_input.player_input(player1)
      end
      it 'does not display no_room_message' do
        expect(game_input).not_to receive(:puts).with(no_room_message)
        game_input.player_input(player1)
      end
      it 'returns player input' do
        expect(game_input.player_input(player1)).to eql(valid_col)
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
        game_input.player_input(player1)
      end
      it 'does not display not_col message' do
        expect(game_input).not_to receive(:puts).with(not_col_message)
        game_input.player_input(player1)
      end
      it 'returns valid player input' do
        expect(game_input.player_input(player1)).to eql(valid_col2)
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
        game_input.player_input(player1)
      end

      it 'displays unavailable message once' do
        expect(game_input).to receive(:puts).with(no_room_message).once
        game_input.player_input(player1)
      end

      it 'returns valid and available input' do
        expect(game_input.player_input(player1)).to eql(valid_col)
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
        game_input.player_input(player1)
      end
      it 'displays unavailable message twice' do
        expect(game_input).to receive(:puts).with(no_room_message)
        game_input.player_input(player1)
      end
      it 'returns valid and available input' do
        expect(game_input.player_input(player1)).to eql(valid_col)
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
        game_input.player_input(player1)
      end

      it 'does not display no room message' do
        expect(game_input).not_to receive(:puts).with(no_room_message)
        game_input.player_input(player1)
      end

      it 'returns valid and available input' do
        expect(game_input.player_input(player1)).to eql(valid_col)
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

  describe '#rotate_turns_til_winner' do
    subject(:game_rotate) { described_class.new }
    let(:player1) {instance_double(Player)}
    let(:player2) {instance_double(Player)}
    let(:players) { [player1, player2] }

    before do
      allow(game_rotate).to receive(:take_turn).with(player1)
      allow(game_rotate).to receive(:take_turn).with(player2)
    end

    context 'when there is a winner' do
      before do
        allow(game_rotate.instance_variable_get(:@board)).to receive(:winner?).and_return(false, false, false, false, false, false, true)
      end

      context 'when player2 took 3 turns and player1 took for 4 turns and wins' do
        it 'calls take_turn 7 times' do
          expect(game_rotate).to receive(:take_turn).exactly(7).times
          game_rotate.rotate_turns_til_winner(players)
        end
        it 'calls take_turn with player1 4 times' do
          expect(game_rotate).to receive(:take_turn).with(player1).exactly(4).times
          game_rotate.rotate_turns_til_winner(players)
        end
        it 'calls take_turn with player2 3 times' do
          expect(game_rotate).to receive(:take_turn).with(player2).exactly(3).times
          game_rotate.rotate_turns_til_winner(players)
        end

        it 'return winner' do
          expect(game_rotate.rotate_turns_til_winner(players)).to eql(player1)
        end
      end      
    end

    context 'when board is full and no one has won' do
      it 'returns false' do
        allow(game_rotate.instance_variable_get(:@board)).to receive(:winner?).and_return(false)
        allow(game_rotate.instance_variable_get(:@board)).to receive(:filled?).and_return(true)
        expect(game_rotate.rotate_turns_til_winner(players)).to eql(false)
      end
    end
  end
  describe '#play' do
    subject(:game_play) { described_class.new }
    let(:player1) { instance_double(Player, name: 'player 1')}
    let(:board) { instance_double(Board)}
    before do
      allow(game_play).to receive(:puts)
      allow(game_play).to receive(:print)
      allow(board).to receive(:print_board)
      game_play.instance_variable_set(:@players, [player1, nil])
      game_play.instance_variable_set(:@board, board)
    end
    context 'when player 1 wins' do
      before do
        allow(game_play).to receive(:rotate_turns_til_winner).and_return(player1)
        allow(player1).to receive(:name).and_return('player 1')
      end
      it 'sends message to @players[0] to get name' do
        expect(player1).to receive(:name).once
        game_play.play
      end

      it 'send message to @board to print' do
        expect(board).to receive(:print_board).once
        game_play.play
      end    
      
      it 'does not display full board message' do
        expect(game_play).not_to receive(:puts).with(game_play.instance_variable_get(:@messages)[:no_winner_message])
        game_play.play
      end

      it 'does display winner message' do
        expect(game_play).to receive(:puts).with( "\n#{player1.name} #{game_play.instance_variable_get(:@messages)[:winner_announcement]}" )
        game_play.play
      end
    end

    context 'when game board is full' do
      before do
        allow(game_play).to receive(:rotate_turns_til_winner).and_return(false)
      end
      it 'ends game and displays message that board is full' do
        expect(game_play).to receive(:puts).with(game_play.instance_variable_get(:@messages)[:no_winner_message])
        game_play.play
      end
    end
  end
end