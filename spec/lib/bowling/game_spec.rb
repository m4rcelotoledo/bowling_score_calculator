require 'spec_helper'
require 'bowling/game'

RSpec.describe Bowling::Game do
  describe '#initialize' do
    it 'creates players from the rolls hash' do
      players_rolls = {
        'Jeff' => [10] * 12,
        'John' => [5] * 21
      }

      game = described_class.new(players_rolls)

      expect(game.players.length).to eq(2)
    end
  end

  describe '#player_names' do
    it 'returns all player names' do
      players_rolls = {
        'Jeff' => [10] * 12,
        'John' => [5] * 21
      }

      game = described_class.new(players_rolls)

      expect(game.player_names).to eq(%w[Jeff John])
    end
  end

  describe '#find_player' do
    it 'returns the player by name' do
      players_rolls = {
        'Jeff' => [10] * 12,
        'John' => [5] * 21
      }

      game = described_class.new(players_rolls)
      player = game.find_player('Jeff')

      expect(player.name).to eq('Jeff')
    end

    it 'returns nil if player not found' do
      players_rolls = { 'Jeff' => [10] * 12 }

      game = described_class.new(players_rolls)

      expect(game.find_player('Unknown')).to be_nil
    end
  end
end
