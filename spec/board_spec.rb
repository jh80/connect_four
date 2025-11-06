# frozen_string_literal: true

require 'pry-byebug'
require_relative '../lib/board'
require_relative '../lib/player'

describe Board do
  subject(:board) { described_class.new }
  let(:player1) { instance_double(Player, mark: '✩') }
  let(:player2) { instance_double(Player, mark: '✭')}

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
      xit 'returns false / or an error' do
        expect(board.available_column?('ha')).to be false
      end
    end
  end

  describe '#place_choice' do
    context 'when choice is an empty column' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', Array.new(6, '❍'), '2', ['✩', '✩' , '✩', '✩', '✩', '✩'], 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', Array.new(6, '❍')])
      end
      it 'changes the bottom slot in choice column' do
        choice = '3'
        expect { board.place_choice(choice, player1) }.to change {board.columns[choice][0]}.from('❍').to('✩')
      end

      it 'does not change above bottom slot in choice column' do
        choice = '3'
        expect { board.place_choice(choice, player1) }.not_to change {board.columns[choice][1..5]}
      end

      it 'mark matches player mark' do
        choice = '3'
        board.place_choice(choice, player1)
        expect(board.columns[choice][0]).to eq(player1.mark)
      end
    end

    context 'when choice is a half full column' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', Array.new(6, '❍'), '2', ['✩', '✩' , '✩', '❍', '❍', '❍'], 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', Array.new(6, '❍')])
      end

      it 'changes the 4th slot in choice column' do
        choice = '2'
        expect { board.place_choice(choice, player2) }.to change{ board.columns[choice][3] }.from('❍').to('✭')
      end

      it 'does not change slots less than 4th slot of choice column' do
        choice = '2'
        expect { board.place_choice(choice, player2) }.not_to change{ board.columns[choice][0...3] }
      end

      it 'does not change slots more than 4th slot of choice column' do
        choice = '2'
        expect { board.place_choice(choice, player2) }.not_to change { board.columns[choice][4..5] }
      end
    end

    context 'when choice is one from full column (with mixed tiles)' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', Array.new(6, '❍'), '2', Array.new(6, '❍'), 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', ['✭', '✩' , '✩', '✭', '✭', '❍']])
      end

      it 'changes the last slot in the column' do
        choice = '7'
        expect { board.place_choice(choice, player2) }.to change{ board.columns[choice][5] }.from('❍').to('✭')
      end

      it 'does not change slots below the last slot' do
        choice = '7'
        expect { board.place_choice(choice, player2) }.not_to change{ board.columns[choice][0...5] }
      end
    end

    context 'when choice is a full column' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', Array.new(6, '❍'), '2', Array.new(6, '❍'), 
          '3', Array.new(6, '❍'), '4', Array.new(6, '❍'), 
          '5', Array.new(6, '❍'), '6', Array.new(6, '❍'), 
          '7', ['✭', '✩' , '✩', '✭', '✭', '✩']])
      end
      
      it 'does not change any slots' do
        choice = '7'
        expect { board.place_choice(choice, player2) }.not_to change { board.columns[choice] }
      end
    end
  end

  describe '#winner?' do
    context 'when there is no winner' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', ['✭', '✩' , '✩', '✭', '✭', '✩'], '2', Array.new(6, '❍'), 
          '3', ['✭', '✩' , '✩', '✭', '✭', '✩'], '4', Array.new(6, '❍'), 
          '5', ['✭', '✩' , '✩', '✭', '✭', '✩'], '6', Array.new(6, '❍'), 
          '7', ['✭', '✩' , '✩', '✭', '✭', '✩']])
      end

      context 'when checking player 1' do
        it 'returns false' do
          expect(board.winner?(player1)).to eq(false)
        end
      end
      context 'when checking player 2' do
        it 'returns false' do
          expect(board.winner?(player2)).to eq(false)
        end
      end
    end

    context 'when player 2 wins horizontaly' do
      context 'via bottom row' do
        before do
          allow(board).to receive(:columns).and_return(Hash[
            '1', ['✭', '✩' , '✩', '✩', '✭', '❍'], '2', ['✭', '❍' , '❍', '❍', '❍', '❍'], 
            '3', ['✭', '❍' , '❍', '❍', '❍', '❍'], '4', ['✭', '❍' , '❍', '❍', '❍', '❍'], 
            '5', ['✩', '❍' , '❍', '❍', '❍', '❍'], '6', ['❍', '❍' , '❍', '❍', '❍', '❍'], 
            '7', ['✩', '❍' , '❍', '❍', '❍', '❍']])
        end

        context 'when checking player 2' do
          it 'returns true' do 
            expect(board.winner?(player2)).to eq(true)
          end
        end
        context 'when checking player 1' do
          it 'returns false' do
            expect(board.winner?(player1)).to eq(false)
          end
        end
      end
      context 'via third row' do
        before do
          allow(board).to receive(:columns).and_return(Hash[
            '1', ['✭', '✭' , '✩', '❍', '❍', '❍'], '2', ['✭', '✭' , '✩', '❍', '❍', '❍'], 
            '3', ['✭', '✩' , '✭', '❍', '❍', '❍'], '4', ['✩', '✩' , '✭', '❍', '❍', '❍'], 
            '5', ['✩', '✩' , '✭', '❍', '❍', '❍'], '6', ['✭', '✭' , '✭', '❍', '❍', '❍'], 
            '7', ['✩', '✭' , '❍', '❍', '❍', '❍']])
        end

        context 'when checking player 2' do
          it 'returns true' do 
            expect(board.winner?(player2)).to eq(true)
          end
        end
        context 'when checking player 1' do
          it 'returns false' do
            expect(board.winner?(player1)).to eq(false)
          end
        end
      end
    end

    context 'when player 1 wins vertically' do
      before do
        allow(board).to receive(:columns).and_return(Hash[
          '1', ['✭', '✩' , '✩', '✩', '✩', '❍'], '2', ['✭', '✭' , '❍', '❍', '❍', '❍'], 
          '3', ['✭', '❍' , '❍', '❍', '❍', '❍'], '4', ['❍', '❍' , '❍', '❍', '❍', '❍'], 
          '5', ['✩', '❍' , '❍', '❍', '❍', '❍'], '6', ['❍', '❍' , '❍', '❍', '❍', '❍'], 
          '7', ['✩', '✭' , '❍', '❍', '❍', '❍']])
      end

      context 'when checking for player 1' do
        it 'returns true' do
          expect(board.winner?(player1)).to eq(true)
        end
      end
      context 'when checking for player 2' do
        it 'returns false' do
          expect(board.winner?(player2)).to eq(false)
        end
      end
    end

    context 'when player 2 wins diagonally' do
      context 'via from left traveling right from bottom row' do
        before do
          allow(board).to receive(:columns).and_return(Hash[
            '1', ['✭', '✩' , '✩', '❍', '❍', '❍'], '2', ['✭', '✭' , '✩', '❍', '❍', '❍'], 
            '3', ['✩', '✩' , '✭', '❍', '❍', '❍'], '4', ['✩', '✭' , '✭', '✭', '❍', '❍'], 
            '5', ['❍', '❍' , '❍', '❍', '❍', '❍'], '6', ['❍', '❍' , '❍', '❍', '❍', '❍'], 
            '7', ['❍', '❍' , '❍', '❍', '❍', '❍']])
        end

        context 'when checking player 2' do
          it 'returns true' do
            expect(board.winner?(player2)).to eq(true)
          end
        end
        context 'when checking player 1' do
          it 'returns false' do
            expect(board.winner?(player1)).to eq(false)
          end
        end
      end
      context 'via staring second row traveling left' do
        before do
          allow(board).to receive(:columns).and_return(Hash[
            '1', ['✭', '✩' , '✩', '❍', '❍', '❍'], '2', ['✭', '✭' , '✩', '✩', '❍', '❍'], 
            '3', ['✩', '✩' , '✭', '❍', '❍', '❍'], '4', ['✩', '✭' , '✭', '✩', '✭', '❍'], 
            '5', ['✩', '✩' , '✩', '✭', '❍', '❍'], '6', ['✭', '✩' , '✭', '❍', '❍', '❍'], 
            '7', ['✭', '✭' , '❍', '❍', '❍', '❍']])
        end

        context 'when checking player 2' do
          it 'returns true' do
            expect(board.winner?(player2)).to eq(true)
          end
        end
        context 'when checking player 1' do
          it 'returns false' do
            expect(board.winner?(player1)).to eq(false)
          end
        end
      end
    end
  end
end