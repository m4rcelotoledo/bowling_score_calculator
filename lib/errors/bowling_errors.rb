module Bowling
  module Errors
    # Base error class for all bowling-related errors
    class BowlingError < StandardError; end

    # Raised when a score value is invalid (negative, > 10, or non-numeric)
    class InvalidScoreError < BowlingError
      def initialize(value)
        super("Invalid score value: '#{value}'. Score must be 0-10 or 'F' for foul.")
      end
    end

    # Raised when the input file format is incorrect
    class InvalidFormatError < BowlingError
      def initialize(line = nil)
        message = if line
                    "Invalid format on line: '#{line}'. Expected format: 'PlayerName<tab>Score'"
                  else
                    'Invalid file format. Expected tab-separated values with player name and score.'
                  end
        super(message)
      end
    end

    # Raised when a player has an invalid number of rolls
    class InvalidFrameCountError < BowlingError
      def initialize(player_name, roll_count)
        super("Invalid number of rolls for player '#{player_name}': #{roll_count}. " \
              'A complete game requires 12-21 rolls depending on strikes and spares.')
      end
    end

    # Raised when the input file is empty
    class EmptyFileError < BowlingError
      def initialize
        super('Input file is empty.')
      end
    end

    # Raised when the input file does not exist
    class FileNotFoundError < BowlingError
      def initialize(path)
        super("File not found: '#{path}'")
      end
    end

    # Raised when frame pins exceed 10 (except 10th frame)
    class InvalidPinCountError < BowlingError
      def initialize(frame_number, total_pins)
        super("Invalid pin count in frame #{frame_number}: #{total_pins} pins. " \
              'Maximum is 10 pins per frame (except bonus rolls in 10th frame).')
      end
    end
  end
end
