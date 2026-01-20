require 'spec_helper'
require 'bowling/frame'
require 'bowling/score_calculator'

RSpec.describe Bowling::ScoreCalculator do
  def create_frames(rolls_array)
    frames = []
    roll_index = 0

    10.times do |i|
      frame = Bowling::Frame.new(i + 1)
      frames << frame

      while roll_index < rolls_array.length && !frame.complete?
        frame.add_roll(rolls_array[roll_index])
        roll_index += 1
      end
    end

    frames
  end

  describe '#calculate' do
    context 'with a perfect game (all strikes)' do
      it 'returns 300' do
        rolls = [10] * 12
        frames = create_frames(rolls)
        calculator = described_class.new(frames)

        scores = calculator.calculate

        expect(scores.last).to eq(300)
      end
    end

    context 'with all zeros' do
      it 'returns 0' do
        rolls = [0] * 20
        frames = create_frames(rolls)
        calculator = described_class.new(frames)

        scores = calculator.calculate

        expect(scores.last).to eq(0)
      end
    end

    context 'with all spares (5 pins each roll)' do
      it 'returns 150' do
        rolls = [5] * 21
        frames = create_frames(rolls)
        calculator = described_class.new(frames)

        scores = calculator.calculate

        expect(scores.last).to eq(150)
      end
    end

    context 'with a strike followed by normal rolls' do
      it 'calculates strike bonus correctly' do
        rolls = [10, 3, 4] + ([0] * 16)
        frames = create_frames(rolls)
        calculator = described_class.new(frames)

        scores = calculator.calculate

        # Frame 1: 10 + 3 + 4 = 17
        # Frame 2: 3 + 4 = 7
        # Total first two frames: 24
        expect(scores[0]).to eq(17)
        expect(scores[1]).to eq(24)
      end
    end

    context 'with a spare followed by normal rolls' do
      it 'calculates spare bonus correctly' do
        rolls = [7, 3, 5, 2] + ([0] * 16)
        frames = create_frames(rolls)
        calculator = described_class.new(frames)

        scores = calculator.calculate

        # Frame 1: 7 + 3 + 5 = 15
        # Frame 2: 5 + 2 = 7
        # Total first two frames: 22
        expect(scores[0]).to eq(15)
        expect(scores[1]).to eq(22)
      end
    end

    context 'with consecutive strikes' do
      it 'calculates double strike bonus correctly' do
        rolls = [10, 10, 3, 4] + ([0] * 14)
        frames = create_frames(rolls)
        calculator = described_class.new(frames)

        scores = calculator.calculate

        # Frame 1: 10 + 10 + 3 = 23
        # Frame 2: 10 + 3 + 4 = 17
        # Frame 3: 3 + 4 = 7
        expect(scores[0]).to eq(23)
        expect(scores[1]).to eq(40)
        expect(scores[2]).to eq(47)
      end
    end
  end
end
