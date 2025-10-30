# frozen_string_literal: true

require_relative '../lib/player'
require_relative '../lib/board'

describe Board do
  subject(:board) {described_class.new}

  describe '#approved_choice?' do
    context 'when player pick valid and available' do
      before do
        allow(board).to receive(:valid_column?).and_return(true)
        allow(board).to receive(:available_column?).and_return(true)
      end
      it 'returns true' do
        expect(player.approved_choice?(4)).to be true
      end
    end

    context 'when player pick is a number 1 - 7 and not available' do
      
    end

    context 'when player pick is not a number' do
      
    end

    context 'when player pick is above 7' do
      
    end

    context 'when player pick is below 7' do
      
    end
  end


end