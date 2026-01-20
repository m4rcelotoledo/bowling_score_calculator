module Bowling
  # Calculates bowling scores with strike and spare bonuses
  class ScoreCalculator
    MAX_PINS = 10
    TOTAL_FRAMES = 10

    def initialize(frames)
      @frames = frames
    end

    # Calculates cumulative scores for each frame
    # @return [Array<Integer>] cumulative scores for each frame
    def calculate
      cumulative = 0
      scores = []

      frames.each_with_index do |frame, index|
        frame_score = calculate_frame_score(frame, index)
        cumulative += frame_score
        scores << cumulative
      end

      scores
    end

    private

    attr_reader :frames

    def calculate_frame_score(frame, index)
      if frame.tenth_frame?
        frame.base_pins
      elsif frame.strike?
        MAX_PINS + strike_bonus(index)
      elsif frame.spare?
        MAX_PINS + spare_bonus(index)
      else
        frame.base_pins
      end
    end

    def strike_bonus(frame_index)
      # Get next two rolls after this strike
      next_rolls = get_next_rolls(frame_index, 2)
      next_rolls.sum
    end

    def spare_bonus(frame_index)
      # Get next one roll after this spare
      next_rolls = get_next_rolls(frame_index, 1)
      next_rolls.sum
    end

    def get_next_rolls(frame_index, count)
      rolls = []
      remaining_frames = frames[(frame_index + 1)..]

      remaining_frames.each do |frame|
        frame.rolls.each do |pins|
          rolls << pins
          return rolls if rolls.length >= count
        end
      end

      rolls
    end
  end
end
