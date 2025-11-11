# frozen_string_literal: true

require 'pry-byebug'
require_relative '../lib/game'
require_relative '../lib/player'
require_relative '../lib/board'

describe Game do
  subject(:game) {described_class.new}
  let(:player) {instance_double(Player, mark: '✩')}
  let(:board) {instance_double(Board)}
  correction_message = "Your choice was not a valid column. Choose from 1, 2, 3, 4, 5, 6, 7"

  describe '#player_input' do
    before do
      allow(game).to receive(:puts)
    end
    context 'when board it empty' do
      before do
        allow(board).to receive(:columns).and_return(Hash['1', Array.new(6, @blank_mark), '2', Array.new(6, @blank_mark), '3', Array.new(6, @blank_mark), '4', Array.new(6, @blank_mark), '5', Array.new(6, @blank_mark), '6', Array.new(6, @blank_mark), '7', Array.new(6, @blank_mark)])
      end
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
  end
end