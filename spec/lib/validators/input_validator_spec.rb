require 'spec_helper'
require 'validators/input_validator'

RSpec.describe Bowling::Validators::InputValidator do
  describe '#validate!' do
    context 'with valid input' do
      it 'returns true for a perfect game' do
        players_rolls = { 'Carl' => [10] * 12 }
        validator = described_class.new(players_rolls)

        expect(validator.validate!).to be true
      end

      it 'returns true for all zeros' do
        players_rolls = { 'Carl' => [0] * 20 }
        validator = described_class.new(players_rolls)

        expect(validator.validate!).to be true
      end

      it 'returns true for all spares' do
        players_rolls = { 'Carl' => [5] * 21 }
        validator = described_class.new(players_rolls)

        expect(validator.validate!).to be true
      end

      it 'returns true for multiple players' do
        players_rolls = {
          'Jeff' => [10] * 12,
          'John' => [0] * 20
        }
        validator = described_class.new(players_rolls)

        expect(validator.validate!).to be true
      end
    end

    context 'with invalid input' do
      it 'raises error for empty players hash' do
        validator = described_class.new({})

        expect { validator.validate! }.to raise_error(Bowling::Errors::InvalidFormatError)
      end

      it 'raises error for too few rolls' do
        players_rolls = { 'Carl' => [10] * 5 }
        validator = described_class.new(players_rolls)

        expect { validator.validate! }.to raise_error(Bowling::Errors::InvalidFrameCountError)
      end

      it 'raises error for too many rolls' do
        players_rolls = { 'Carl' => [0] * 30 }
        validator = described_class.new(players_rolls)

        expect { validator.validate! }.to raise_error(Bowling::Errors::InvalidFrameCountError)
      end

      it 'raises error for negative score' do
        players_rolls = { 'Carl' => [-1] + ([0] * 19) }
        validator = described_class.new(players_rolls)

        expect { validator.validate! }.to raise_error(Bowling::Errors::InvalidScoreError)
      end

      it 'raises error for score greater than 10' do
        players_rolls = { 'Carl' => [11] + ([0] * 19) }
        validator = described_class.new(players_rolls)

        expect { validator.validate! }.to raise_error(Bowling::Errors::InvalidScoreError)
      end

      it 'raises error for invalid frame pin count' do
        players_rolls = { 'Carl' => [6, 6] + ([0] * 18) }
        validator = described_class.new(players_rolls)

        expect { validator.validate! }.to raise_error(Bowling::Errors::InvalidPinCountError)
      end
    end
  end
end
