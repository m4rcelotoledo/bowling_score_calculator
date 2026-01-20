require_relative '../errors/bowling_errors'

module Bowling
  module Validators
    # Validates bowling game input data
    class InputValidator
      MINIMUM_ROLLS = 12  # All strikes (10 frames + 2 bonus)
      MAXIMUM_ROLLS = 21  # Alternating spare pattern (20 regular + 1 bonus)
      MAX_PINS = 10

      def initialize(players_rolls)
        @players_rolls = players_rolls
      end

      # Validates all player data
      # @raise [Bowling::Errors::BowlingError] if validation fails
      # @return [true] if validation passes
      def validate!
        validate_has_players!

        players_rolls.each do |player_name, rolls|
          validate_player_rolls!(player_name, rolls)
        end

        true
      end

      private

      attr_reader :players_rolls

      def validate_has_players!
        raise Errors::InvalidFormatError, 'No players found in input' if players_rolls.empty?
      end

      def validate_player_rolls!(player_name, rolls)
        validate_roll_count!(player_name, rolls)
        validate_score_values!(rolls)
        validate_frame_pins!(player_name, rolls)
      end

      def validate_roll_count!(player_name, rolls)
        count = rolls.length

        return if count.between?(MINIMUM_ROLLS, MAXIMUM_ROLLS)

        raise Errors::InvalidFrameCountError.new(player_name, count)
      end

      def validate_score_values!(rolls)
        rolls.each do |pins|
          raise Errors::InvalidScoreError, pins unless valid_pin_count?(pins)
        end
      end

      def valid_pin_count?(pins)
        pins.is_a?(Integer) && pins >= 0 && pins <= MAX_PINS
      end

      def validate_frame_pins!(player_name, rolls)
        frame = 1
        roll_index = 0

        while frame <= 10 && roll_index < rolls.length
          if frame < 10
            validate_regular_frame!(player_name, rolls, roll_index, frame)
            roll_index += rolls[roll_index] == MAX_PINS ? 1 : 2
          else
            expected_rolls = calculate_tenth_frame_rolls(rolls, roll_index)
            validate_tenth_frame_count!(player_name, rolls, roll_index, expected_rolls)
            validate_tenth_frame_pins!(rolls, roll_index)
            break
          end
          frame += 1
        end
      end

      def validate_regular_frame!(_player_name, rolls, roll_index, frame)
        first_roll = rolls[roll_index]
        return if first_roll == MAX_PINS # Strike

        second_roll = rolls[roll_index + 1]
        return unless second_roll

        total = first_roll + second_roll
        return if total <= MAX_PINS

        raise Errors::InvalidPinCountError.new(frame, total)
      end

      def calculate_tenth_frame_rolls(rolls, roll_index)
        remaining = rolls[roll_index..]
        return 2 if remaining.nil? || remaining.length < 2

        first = remaining[0]
        second = remaining[1]

        # Strike on first roll OR spare = 3 rolls allowed
        if first == MAX_PINS || first + second == MAX_PINS
          3
        else
          2
        end
      end

      def validate_tenth_frame_count!(player_name, rolls, roll_index, expected_rolls)
        actual_rolls = rolls[roll_index..].length

        return if actual_rolls == expected_rolls

        raise Errors::InvalidFrameCountError.new(player_name, rolls.length)
      end

      def validate_tenth_frame_pins!(rolls, roll_index)
        remaining = rolls[roll_index..]
        return if remaining.nil? || remaining.empty?

        first = remaining[0] || 0
        second = remaining[1] || 0

        # If first roll is NOT a strike, first + second must be <= 10
        return if first == MAX_PINS
        return if first + second <= MAX_PINS

        raise Errors::InvalidPinCountError.new(10, first + second)
      end
    end
  end
end
