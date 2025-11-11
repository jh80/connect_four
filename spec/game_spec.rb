# frozen_string_literal: true

require 'pry-byebug'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

describe Game do
  subject(:game) {described_class.new}
  let(:player1) {instance_double(Player, mark: '✩')}
  #let(:player2) {instance_double(Player, mark: '✭')}
  let(:board) {instance_double(Board, columns: Hash['1', Array.new(6, @blank_mark), '2', Array.new(6, @blank_mark), '3', Array.new(6, @blank_mark), '4', Array.new(6, @blank_mark), '5', Array.new(6, @blank_mark), '6', Array.new(6, @blank_mark), '7', ['✭', '✩' , '✩', '✭', '✭', '❍']])}
  correction_message = "Your choice was not a valid column. Choose from 1, 2, 3, 4, 5, 6, 7"

  before do
    #allow(Board).to receive(:new).and_return(board)
    #allow(Player).to receive(:new).and_return(player1, player2)
    allow(game).to receive(:@board).and_return(board)
  end
  describe '#player_input' do
    before do
      allow(game).to receive(:puts)
    end
    context 'when board is empty' do
      context 'when input is valid and available column' do
        it 'stops loop and does not display correction message' do
          correction_message = "Your choice was not a valid column. Choose from 1, 2, 3, 4, 5, 6, 7"
          valid_input = '5'
          allow(game).to receive(:gets).and_return(valid_input)
          expect(game).not_to receive(:puts).with(correction_message)
          game.player_input
        end
      end

      context 'when user inputs an invalid choice once, then a valid choice' do
        before do
          letter = 'b'
          valid_input = '3'
          allow(game).to receive(:gets).and_return(letter, valid_input)
        end

        it 'completes loop once, then displays correction message once' do
          correction_message = "Your choice was not a valid column. Choose from 1, 2, 3, 4, 5, 6, 7"
          expect(game).to receive(:puts).with(correction_message).once
          game.player_input
        end
      end
      
      context 'when user enters in three invalid responses before a valid one' do 
        before do
          non_col_num1 = '0'
          non_col_num2 = '38'
          valid_input = '7'
          allow(game).to receive(:gets).and_return(non_col_num1, non_col_num2, valid_input)
          #allow(game).to receive(:puts)
        end

        it 'displays correction message twice' do
          correction_message = "Your choice was not a valid column. Choose from 1, 2, 3, 4, 5, 6, 7"
          expect(game).to receive(:puts).with(correction_message).twice
          game.player_input
        end
      end
    end



    context 'when a column is full' do
      subject(:game_full_col) {described_class.new}
      let(:board_full_col) do 
          instance_double(Board, columns: Hash[
          '1', Array.new(6, '❍'), '2', Array.new(6, '❍'), 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', ['✭', '✩' , '✩', '✭', '✭', '❍']]) 
      end

      # !!!!!!!! should this be a let variable?
      full_column = '7'

      context 'when user enters an unavailable column then valid column' do
        it 'displays correction message once' do
          correction_message_f = "Your choice column is full, please select another"
          valid_column = '5'
          allow(game).to receive(:gets).and_return(full_column, valid_column)
          expect(game).to receive(:puts).with(correction_message_f).once
          game.player_input
        end
      end

      context 'when user enter an unavailable, then invalid, then valid column' do
        before do
          allow(game).to receive(:gets).and_return()
        end
      end

      context 'when user enters an invalid, then unavailable, then valid column' do
        before do
          allow(game).to receive(:gets).and_return()
        end
      end
    end
  end
end