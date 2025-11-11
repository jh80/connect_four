# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'

describe Player do
  # I might actually be putting player_input in game...?
  # 
  # subject(:player) {described_class.new('player1', '✩')}
  # let(:board) {instance_double(Board, columns: Hash['1', Array.new(6, @blank_mark), '2', Array.new(6, @blank_mark), '3', Array.new(6, @blank_mark), '4', Array.new(6, @blank_mark), '5', Array.new(6, @blank_mark), '6', Array.new(6, @blank_mark), '7', Array.new(6, @blank_mark)])}
  # describe '#player_input' do
  #   context 'when input is allowed' do
  #     before do
  #       valid_input = '5'
  #       allow(player_input).to receive(:gets).and_return(valid_input)
  #     end

  #     it 'stops loop and does not display correction message' do
  #       correction_message = "Your choice was not a valid column. Choose from 1, 2, 3, 4, 5, 6, 7"
  #       expect(player.player_input).not_to receive(:puts).with(correction_message)
  #       player.player_input
  #     end
  #   end

  #   context 'when user inputs an invalid choice once, then a valid choice' do
  #     before do
        
  #     end
  #     xit 'completes loop once, then' do
    
  #   end
  #   end
    

  #   xit 'loop runs only once' do
      
  #   end
  # end
end