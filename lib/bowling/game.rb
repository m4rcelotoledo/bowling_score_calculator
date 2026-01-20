require_relative 'player'

module Bowling
  # Represents a complete bowling game with multiple players
  class Game
    attr_reader :players

    def initialize(players_rolls)
      @players = build_players(players_rolls)
    end

    # Returns all player names in order
    # @return [Array<String>]
    def player_names
      players.map(&:name)
    end

    # Finds a player by name
    # @param name [String]
    # @return [Player, nil]
    def find_player(name)
      players.find { |p| p.name == name }
    end

    private

    def build_players(players_rolls)
      players_rolls.map do |name, rolls|
        Player.new(name, rolls)
      end
    end
  end
end
