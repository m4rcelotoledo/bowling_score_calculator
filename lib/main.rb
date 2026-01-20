require_relative 'errors/bowling_errors'
require_relative 'parsers/game_file_parser'
require_relative 'validators/input_validator'
require_relative 'bowling/game'
require_relative 'formatters/scoreboard_formatter'

module Bowling
  # Main CLI application for bowling score calculator
  class Main
    def initialize(file_path)
      @file_path = file_path
    end

    # Runs the bowling score calculation and prints the scoreboard
    # @return [String] the formatted scoreboard
    def run
      players_rolls = parse_file
      validate_input(players_rolls)
      game = create_game(players_rolls)
      format_scoreboard(game)
    end

    # Class method for running from command line
    def self.run(args = ARGV)
      if args.empty?
        puts 'Usage: ruby lib/main.rb <input_file>'
        puts 'Example: ruby lib/main.rb spec/fixtures/positive/scores.txt'
        exit(1)
      end

      file_path = args[0]
      main = new(file_path)
      output = main.run
      puts output
      output
    rescue Errors::BowlingError => e
      puts "Error: #{e.message}"
      exit(1)
    end

    private

    attr_reader :file_path

    def parse_file
      parser = Parsers::GameFileParser.new(file_path)
      parser.parse
    end

    def validate_input(players_rolls)
      validator = Validators::InputValidator.new(players_rolls)
      validator.validate!
    end

    def create_game(players_rolls)
      Game.new(players_rolls)
    end

    def format_scoreboard(game)
      formatter = Formatters::ScoreboardFormatter.new(game)
      formatter.format
    end
  end
end

# Run if executed directly
Bowling::Main.run if __FILE__ == $PROGRAM_NAME
