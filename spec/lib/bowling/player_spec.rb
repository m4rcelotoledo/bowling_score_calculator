require 'spec_helper'
require 'bowling/player'

RSpec.describe Bowling::Player do
  describe '#initialize' do
    it 'creates 10 frames from rolls' do
      rolls = [10] * 12
      player = described_class.new('Carl', rolls)

      expect(player.frames.length).to eq(10)
    end
  end

  describe '#total_score' do
    context 'with a perfect game' do
      it 'returns 300' do
        rolls = [10] * 12
        player = described_class.new('Carl', rolls)

        expect(player.total_score).to eq(300)
      end
    end

    context 'with all zeros' do
      it 'returns 0' do
        rolls = [0] * 20
        player = described_class.new('Carl', rolls)

        expect(player.total_score).to eq(0)
      end
    end
  end

  describe '#scores' do
    it 'returns cumulative scores for each frame' do
      rolls = [10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
      player = described_class.new('Carl', rolls)

      expected_scores = [30, 60, 90, 120, 150, 180, 210, 240, 270, 300]
      expect(player.scores).to eq(expected_scores)
    end
  end

  describe '#name' do
    it 'returns the player name' do
      player = described_class.new('Jeff', [])

      expect(player.name).to eq('Jeff')
    end
  end

  describe '#all_rolls' do
    it 'returns all rolls' do
      rolls = [3, 4, 5, 2]
      player = described_class.new('Jeff', rolls)

      expect(player.all_rolls).to eq(rolls)
    end
  end
end
