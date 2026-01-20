require 'spec_helper'
require 'bowling/game'
require 'formatters/scoreboard_formatter'

RSpec.describe Bowling::Formatters::ScoreboardFormatter do
  describe '#format' do
    it 'includes frame header' do
      players_rolls = { 'Carl' => [10] * 12 }
      game = Bowling::Game.new(players_rolls)
      formatter = described_class.new(game)

      output = formatter.format

      expect(output).to include('Frame')
      expect(output).to include('1')
      expect(output).to include('10')
    end

    it 'includes player name' do
      players_rolls = { 'Carl' => [10] * 12 }
      game = Bowling::Game.new(players_rolls)
      formatter = described_class.new(game)

      output = formatter.format

      expect(output).to include('Carl')
    end

    it 'includes pinfalls line' do
      players_rolls = { 'Carl' => [10] * 12 }
      game = Bowling::Game.new(players_rolls)
      formatter = described_class.new(game)

      output = formatter.format

      expect(output).to include('Pinfalls')
    end

    it 'includes score line' do
      players_rolls = { 'Carl' => [10] * 12 }
      game = Bowling::Game.new(players_rolls)
      formatter = described_class.new(game)

      output = formatter.format

      expect(output).to include('Score')
    end

    context 'with a perfect game' do
      it 'shows X for all strikes' do
        players_rolls = { 'Carl' => [10] * 12 }
        game = Bowling::Game.new(players_rolls)
        formatter = described_class.new(game)

        output = formatter.format

        # Count X occurrences (should be 12 for perfect game)
        expect(output.scan('X').length).to eq(12)
      end

      it 'shows 300 as final score' do
        players_rolls = { 'Carl' => [10] * 12 }
        game = Bowling::Game.new(players_rolls)
        formatter = described_class.new(game)

        output = formatter.format

        expect(output).to include('300')
      end
    end

    context 'with spares' do
      it 'shows / for spares' do
        players_rolls = { 'Carl' => [5] * 21 }
        game = Bowling::Game.new(players_rolls)
        formatter = described_class.new(game)

        output = formatter.format

        expect(output).to include('/')
      end
    end

    context 'with fouls' do
      it 'shows F for zero pins' do
        players_rolls = { 'Carl' => [0] * 20 }
        game = Bowling::Game.new(players_rolls)
        formatter = described_class.new(game)

        output = formatter.format

        expect(output).to include('F')
      end
    end

    context 'with multiple players' do
      it 'shows both players' do
        players_rolls = {
          'Jeff' => [10] * 12,
          'John' => [5] * 21
        }
        game = Bowling::Game.new(players_rolls)
        formatter = described_class.new(game)

        output = formatter.format

        expect(output).to include('Jeff')
        expect(output).to include('John')
      end
    end
  end
end
