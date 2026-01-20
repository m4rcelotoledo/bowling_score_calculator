require 'spec_helper'
require 'bowling/frame'

RSpec.describe Bowling::Frame do
  describe '#strike?' do
    context 'when first roll knocks all 10 pins' do
      it 'returns true' do
        frame = described_class.new(1)
        frame.add_roll(10)

        expect(frame).to be_strike
      end
    end

    context 'when first roll does not knock all pins' do
      it 'returns false' do
        frame = described_class.new(1)
        frame.add_roll(7)

        expect(frame).not_to be_strike
      end
    end
  end

  describe '#spare?' do
    context 'when two rolls knock all 10 pins' do
      it 'returns true' do
        frame = described_class.new(1)
        frame.add_roll(7)
        frame.add_roll(3)

        expect(frame).to be_spare
      end
    end

    context 'when strike' do
      it 'returns false' do
        frame = described_class.new(1)
        frame.add_roll(10)

        expect(frame).not_to be_spare
      end
    end

    context 'when two rolls do not knock all pins' do
      it 'returns false' do
        frame = described_class.new(1)
        frame.add_roll(3)
        frame.add_roll(4)

        expect(frame).not_to be_spare
      end
    end
  end

  describe '#complete?' do
    context 'for regular frame (1-9)' do
      it 'returns true after a strike' do
        frame = described_class.new(1)
        frame.add_roll(10)

        expect(frame).to be_complete
      end

      it 'returns true after two rolls' do
        frame = described_class.new(1)
        frame.add_roll(3)
        frame.add_roll(4)

        expect(frame).to be_complete
      end

      it 'returns false after one non-strike roll' do
        frame = described_class.new(1)
        frame.add_roll(5)

        expect(frame).not_to be_complete
      end
    end

    context 'for 10th frame' do
      it 'returns true after 3 rolls when strike on first roll' do
        frame = described_class.new(10)
        frame.add_roll(10)
        frame.add_roll(10)
        frame.add_roll(10)

        expect(frame).to be_complete
      end

      it 'returns true after 3 rolls when spare' do
        frame = described_class.new(10)
        frame.add_roll(7)
        frame.add_roll(3)
        frame.add_roll(5)

        expect(frame).to be_complete
      end

      it 'returns true after 2 rolls when no strike or spare' do
        frame = described_class.new(10)
        frame.add_roll(3)
        frame.add_roll(4)

        expect(frame).to be_complete
      end

      it 'returns false after 2 rolls when strike on first roll' do
        frame = described_class.new(10)
        frame.add_roll(10)
        frame.add_roll(5)

        expect(frame).not_to be_complete
      end
    end
  end

  describe '#base_pins' do
    it 'returns the sum of all rolls' do
      frame = described_class.new(1)
      frame.add_roll(3)
      frame.add_roll(4)

      expect(frame.base_pins).to eq(7)
    end
  end

  describe '#add_roll' do
    it 'adds a roll to the frame' do
      frame = described_class.new(1)
      frame.add_roll(5)

      expect(frame.rolls).to eq([5])
    end

    it 'returns false when frame is complete' do
      frame = described_class.new(1)
      frame.add_roll(10)

      expect(frame.add_roll(5)).to be false
    end
  end
end
