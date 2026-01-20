module Bowling
  # Represents a single frame in a bowling game
  class Frame
    MAX_PINS = 10
    MAX_REGULAR_ROLLS = 2
    MAX_TENTH_FRAME_ROLLS = 3

    attr_reader :number, :rolls

    def initialize(number)
      @number = number
      @rolls = []
    end

    # Adds a roll to this frame
    # @param pins [Integer] number of pins knocked down
    # @return [Boolean] true if roll was added, false if frame is complete
    def add_roll(pins)
      return false if complete?

      @rolls << pins
      true
    end

    # @return [Boolean] true if this is a strike
    def strike?
      rolls[0] == MAX_PINS
    end

    # @return [Boolean] true if this is a spare (not a strike)
    def spare?
      !strike? && rolls.length >= 2 && rolls[0] + rolls[1] == MAX_PINS
    end

    # @return [Boolean] true if frame has all required rolls
    def complete?
      if tenth_frame?
        tenth_frame_complete?
      else
        strike? || rolls.length >= MAX_REGULAR_ROLLS
      end
    end

    # @return [Boolean] true if this is the 10th frame
    def tenth_frame?
      number == 10
    end

    # @return [Integer] base pins without bonus
    def base_pins
      rolls.sum
    end

    # Returns the first roll value
    # @return [Integer, nil]
    def first_roll
      rolls[0]
    end

    # Returns the second roll value
    # @return [Integer, nil]
    def second_roll
      rolls[1]
    end

    # Returns the third roll value (only for 10th frame)
    # @return [Integer, nil]
    def third_roll
      rolls[2]
    end

    private

    def tenth_frame_complete?
      return false if rolls.empty?

      # If strike on first roll or spare, need 3 rolls
      rolls.length >= if rolls[0] == MAX_PINS || (rolls.length >= 2 && rolls[0] + rolls[1] == MAX_PINS)
                        MAX_TENTH_FRAME_ROLLS
                      else
                        MAX_REGULAR_ROLLS
                      end
    end
  end
end
