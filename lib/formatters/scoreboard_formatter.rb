module Bowling
  module Formatters
    # Formats a bowling game scoreboard for console output
    class ScoreboardFormatter
      MAX_PINS = 10
      TOTAL_FRAMES = 10
      TAB = "\t".freeze

      def initialize(game)
        @game = game
      end

      # Formats the complete scoreboard
      # @return [String]
      def format
        lines = [frame_header]

        game.players.each do |player|
          lines << player.name
          lines << format_pinfalls(player)
          lines << format_scores(player)
        end

        lines.join("\n")
      end

      private

      attr_reader :game

      def frame_header
        header = 'Frame'
        TOTAL_FRAMES.times { |i| header += "#{TAB}#{TAB}#{i + 1}" }
        header
      end

      def format_pinfalls(player)
        line = 'Pinfalls'

        player.frames.each do |frame|
          line += if frame.tenth_frame?
                    format_tenth_frame_pinfalls(frame)
                  else
                    format_regular_frame_pinfalls(frame)
                  end
        end

        line
      end

      def format_regular_frame_pinfalls(frame)
        if frame.strike?
          "#{TAB}#{TAB}X"
        elsif frame.spare?
          "#{TAB}#{format_pin(frame.first_roll)}#{TAB}/"
        else
          "#{TAB}#{format_pin(frame.first_roll)}#{TAB}#{format_pin(frame.second_roll)}"
        end
      end

      def format_tenth_frame_pinfalls(frame)
        rolls = frame.rolls
        [
          format_tenth_first_roll(rolls),
          format_tenth_second_roll(rolls),
          format_tenth_third_roll(rolls)
        ].compact.join
      end

      def format_tenth_first_roll(rolls)
        rolls[0] == MAX_PINS ? "#{TAB}X" : "#{TAB}#{format_pin(rolls[0])}"
      end

      def format_tenth_second_roll(rolls)
        return nil unless rolls[1]

        if strike_after_strike?(rolls)
          "#{TAB}X"
        elsif spare_in_tenth?(rolls)
          "#{TAB}/"
        elsif rolls[1] == MAX_PINS
          "#{TAB}X"
        else
          "#{TAB}#{format_pin(rolls[1])}"
        end
      end

      def format_tenth_third_roll(rolls)
        return nil unless rolls[2]

        if rolls[2] == MAX_PINS
          "#{TAB}X"
        elsif spare_on_third?(rolls)
          "#{TAB}/"
        else
          "#{TAB}#{format_pin(rolls[2])}"
        end
      end

      def strike_after_strike?(rolls)
        rolls[0] == MAX_PINS && rolls[1] == MAX_PINS
      end

      def spare_in_tenth?(rolls)
        rolls[0] != MAX_PINS && rolls[0] + rolls[1] == MAX_PINS
      end

      def spare_on_third?(rolls)
        rolls[1] != MAX_PINS && rolls[1] + rolls[2] == MAX_PINS
      end

      def format_pin(pins)
        return '' if pins.nil?
        return 'F' if pins.zero?

        pins.to_s
      end

      def format_scores(player)
        line = 'Score'

        player.scores.each do |score|
          line += "#{TAB}#{TAB}#{score}"
        end

        line
      end
    end
  end
end
