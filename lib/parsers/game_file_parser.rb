require_relative '../errors/bowling_errors'

module Bowling
  module Parsers
    # Parses a bowling game file and extracts player rolls
    class GameFileParser
      Roll = Struct.new(:player_name, :pins, keyword_init: true)

      def initialize(file_path)
        @file_path = file_path
      end

      # Parses the file and returns a hash of player names to their rolls
      # @return [Hash<String, Array<Integer>>] player names mapped to their roll values
      def parse
        validate_file_exists!
        validate_file_not_empty!

        rolls = parse_lines
        group_rolls_by_player(rolls)
      end

      private

      attr_reader :file_path

      def validate_file_exists!
        raise Errors::FileNotFoundError, file_path unless File.exist?(file_path)
      end

      def validate_file_not_empty!
        raise Errors::EmptyFileError if File.empty?(file_path)
      end

      def parse_lines
        File.readlines(file_path, chomp: true).map.with_index(1) do |line, line_number|
          parse_line(line, line_number)
        end
      end

      def parse_line(line, line_number)
        parts = line.split("\t")

        unless parts.length == 2
          raise Errors::InvalidFormatError,
                "Line #{line_number}: '#{line}'"
        end

        player_name, score_str = parts
        pins = parse_score(score_str, line_number)

        Roll.new(player_name: player_name.strip, pins: pins)
      end

      def parse_score(score_str, line_number)
        score_str = score_str.strip.upcase

        return 0 if score_str == 'F'

        unless score_str.match?(/^\d+$/)
          raise Errors::InvalidScoreError,
                "Line #{line_number}: '#{score_str}'"
        end

        score_str.to_i
      end

      def group_rolls_by_player(rolls)
        rolls.each_with_object({}) do |roll, hash|
          hash[roll.player_name] ||= []
          hash[roll.player_name] << roll.pins
        end
      end
    end
  end
end
