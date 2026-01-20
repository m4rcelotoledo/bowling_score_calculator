require 'spec_helper'
require 'main'

RSpec.describe Bowling::Main do
  describe '#run' do
    context 'when input file is valid' do
      context 'with two players' do
        it 'prints the game scoreboard to stdout' do
          main = described_class.new(file_fixture('scores.txt').to_s)
          output = main.run

          expect(output).to include('Jeff')
          expect(output).to include('John')
          expect(output).to include('Frame')
          expect(output).to include('Pinfalls')
          expect(output).to include('Score')

          # Verify Jeff's final score (167)
          expect(output).to include('167')

          # Verify John's final score (151)
          expect(output).to include('151')
        end

        it 'shows strikes as X' do
          main = described_class.new(file_fixture('scores.txt').to_s)
          output = main.run

          expect(output).to include('X')
        end

        it 'shows spares as /' do
          main = described_class.new(file_fixture('scores.txt').to_s)
          output = main.run

          expect(output).to include('/')
        end

        it 'shows fouls as F' do
          main = described_class.new(file_fixture('scores.txt').to_s)
          output = main.run

          expect(output).to include('F')
        end
      end

      context 'with strikes in all throwings (perfect game)' do
        it 'prints a perfect game scoreboard with 300 points' do
          main = described_class.new(file_fixture('perfect.txt').to_s)
          output = main.run

          expect(output).to include('Carl')
          expect(output).to include('300')

          # Should have 12 X's for a perfect game
          expect(output.scan('X').length).to eq(12)
        end

        it 'shows cumulative scores correctly' do
          main = described_class.new(file_fixture('perfect.txt').to_s)
          output = main.run

          # Perfect game cumulative scores
          expect(output).to include('30')
          expect(output).to include('60')
          expect(output).to include('90')
          expect(output).to include('120')
          expect(output).to include('150')
          expect(output).to include('180')
          expect(output).to include('210')
          expect(output).to include('240')
          expect(output).to include('270')
          expect(output).to include('300')
        end
      end

      context 'with fouls in all throwings' do
        it 'prints the game scoreboard with zero score' do
          # Create a temp file with all fouls
          require 'tempfile'

          temp_file = Tempfile.new(['all_fouls', '.txt'])
          begin
            12.times { temp_file.puts "Carl\tF" }
            temp_file.close

            main = described_class.new(temp_file.path)
            output = main.run

            expect(output).to include('Carl')
            # All frames should show 0 score (displayed as F in pinfalls)
            expect(output).to include('F')

            # Final score should be 0
            lines = output.split("\n")
            score_line = lines.find { |l| l.start_with?('Score') }
            scores = score_line.split("\t").reject(&:empty?).drop(1).map(&:to_i)
            expect(scores.last).to eq(0)
          ensure
            temp_file.unlink
          end
        end
      end
    end

    context 'when input file is invalid' do
      context 'with invalid characters present (free text)' do
        it 'raises the corresponding error message' do
          main = described_class.new(file_fixture('free-text.txt').to_s)

          expect { main.run }.to raise_error(Bowling::Errors::InvalidFormatError)
        end
      end

      context 'with invalid score (non-numeric)' do
        it 'raises the corresponding error message' do
          main = described_class.new(file_fixture('invalid-score.txt').to_s)

          expect { main.run }.to raise_error(Bowling::Errors::InvalidScoreError)
        end
      end

      context 'with negative score' do
        it 'raises the corresponding error message' do
          main = described_class.new(file_fixture('negative.txt').to_s)

          expect { main.run }.to raise_error(Bowling::Errors::InvalidScoreError)
        end
      end

      context 'with invalid number of throwings (extra score)' do
        it 'raises the corresponding error message' do
          main = described_class.new(file_fixture('extra-score.txt').to_s)

          expect { main.run }.to raise_error(Bowling::Errors::InvalidFrameCountError)
        end
      end

      context 'with empty file' do
        it 'raises the corresponding error message' do
          main = described_class.new(file_fixture('empty.txt').to_s)

          expect { main.run }.to raise_error(Bowling::Errors::EmptyFileError)
        end
      end

      context 'with non-existent file' do
        it 'raises the corresponding error message' do
          main = described_class.new('non_existent_file.txt')

          expect { main.run }.to raise_error(Bowling::Errors::FileNotFoundError)
        end
      end
    end
  end

  describe '.run' do
    it 'outputs scoreboard to stdout' do
      expect do
        described_class.run([file_fixture('perfect.txt').to_s])
      end.to output(/Carl.*300/m).to_stdout
    end
  end
end
