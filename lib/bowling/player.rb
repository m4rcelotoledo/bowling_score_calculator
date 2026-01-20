require_relative 'frame'
require_relative 'score_calculator'

module Bowling
  # Represents a player in a bowling game
  class Player
    TOTAL_FRAMES = 10

    attr_reader :name, :frames

    def initialize(name, rolls = [])
      @name = name
      @frames = []
      @rolls = rolls
      distribute_rolls_to_frames
    end

    # Returns the cumulative scores for each frame
    # @return [Array<Integer>]
    def scores
      @scores ||= ScoreCalculator.new(frames).calculate
    end

    # Returns the final total score
    # @return [Integer]
    def total_score
      scores.last || 0
    end

    # Returns all rolls as a flat array
    # @return [Array<Integer>]
    def all_rolls
      @rolls.dup
    end

    private

    def distribute_rolls_to_frames
      roll_index = 0

      TOTAL_FRAMES.times do |frame_number|
        frame = Frame.new(frame_number + 1)
        @frames << frame

        while roll_index < @rolls.length && !frame.complete?
          frame.add_roll(@rolls[roll_index])
          roll_index += 1
        end
      end
    end
  end
end
