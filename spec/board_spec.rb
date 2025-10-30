# frozen_string_literal: true

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
        expect(board.approved_choice?('4')).to be true
      end
    end
    
    context 'when player pick is valid number and not available' do
      before do
        allow(board).to receive(:valid_column?).and_return(true)
        allow(board).to receive(:available_column?).and_return(false)
      end

      it 'returns true' do
        expect(board.approved_choice?('6')).to be false
      end 
    end

    context 'when player pick is not a valid column' do
      before do
        allow(board).to receive(:valid_column?).and_return(false)
        allow(board).to receive(:available_column?).and_return(true)
      end

      it 'returns false' do
        expect(board.approved_choice?('a')).to be false
      end
    end
  end

  describe '#valid_column?' do
    context 'when choice is a valid number' do
      it 'returns true' do
        valid_input = '2'
        expect(board.valid_column?(valid_input)).to be true
      end
    end

    context 'when choice is a letter' do
      it 'returns false' do
        not_num_input = 'a'
        expect(board.valid_column?(not_num_input)).to be false
      end
    end

    context 'when choice is a symbol' do
      it 'returns false' do
        not_num_input = '/'
        expect(board.valid_column?(not_num_input)).to be false
      end
    end

    context 'when choice is invalid and more than one character' do
      it 'returns false' do
        not_num_input = '4jkd'
        expect(board.valid_column?(not_num_input)).to be false
      end
    end

    context 'when choice is a number, but not a valid column' do
      it 'returns false' do
        not_num_input = '730'
        expect(board.valid_column?(not_num_input)).to be false
      end
    end
  end

  describe '#available_column?' do
    before do
      allow(board).to receive(:blank_mark).and_return('❍')
    end
    context 'when a column is empty' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', Array.new(6, '❍'), '2', Array.new(6, '❍'), 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', Array.new(6, '❍')])
      end
      it 'returns true' do
        expect(board.available_column?('5')).to be true
      end
    end

    context 'when a column is half full' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', Array.new(6, '❍'), '2', Array.new(6, '❍'), 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', ['✩', '✩' , '✩', '❍', '❍', '❍']])
      end
      it 'returns true' do
        expect(board.available_column?('7')).to be true
      end
    end

    context 'when a column is full' do
      before do
        # Testing column '2', and column '2' is full
        allow(board).to receive(:columns).and_return(Hash[
          '1', Array.new(6, '❍'), '2', ['✩', '✩' , '✩', '✩', '✩', '✩'], 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', Array.new(6, '❍')])     
      end
      it 'returns false' do
        expect(board.available_column?('2')).to be false
      end
    end

    context 'when entered column is not a viable column' do
      it 'returns false / or an error' do
        expect(board.available_column?('ha')).to be false
      end
    end
  end
end