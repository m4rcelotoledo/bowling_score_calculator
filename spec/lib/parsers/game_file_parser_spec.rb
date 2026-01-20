require 'spec_helper'
require 'parsers/game_file_parser'

RSpec.describe Bowling::Parsers::GameFileParser do
  describe '#parse' do
    context 'with valid input file' do
      it 'returns a hash of player names to rolls' do
        parser = described_class.new(file_fixture('scores.txt').to_s)
        result = parser.parse

        expect(result).to be_a(Hash)
        expect(result.keys).to contain_exactly('Jeff', 'John')
      end

      it 'parses the correct number of rolls per player' do
        parser = described_class.new(file_fixture('scores.txt').to_s)
        result = parser.parse

        expect(result['Jeff'].length).to eq(17)
        expect(result['John'].length).to eq(18)
      end

      it 'converts F to 0' do
        parser = described_class.new(file_fixture('scores.txt').to_s)
        result = parser.parse

        # Jeff has an F (foul) which should be converted to 0
        expect(result['Jeff']).to include(0)
      end

      it 'parses perfect game correctly' do
        parser = described_class.new(file_fixture('perfect.txt').to_s)
        result = parser.parse

        expect(result['Carl']).to eq([10] * 12)
      end
    end

    context 'with invalid input file' do
      it 'raises FileNotFoundError for non-existent file' do
        parser = described_class.new('non_existent_file.txt')

        expect { parser.parse }.to raise_error(Bowling::Errors::FileNotFoundError)
      end

      it 'raises EmptyFileError for empty file' do
        parser = described_class.new(file_fixture('empty.txt').to_s)

        expect { parser.parse }.to raise_error(Bowling::Errors::EmptyFileError)
      end

      it 'raises InvalidFormatError for free text' do
        parser = described_class.new(file_fixture('free-text.txt').to_s)

        expect { parser.parse }.to raise_error(Bowling::Errors::InvalidFormatError)
      end

      it 'raises InvalidScoreError for invalid score values' do
        parser = described_class.new(file_fixture('invalid-score.txt').to_s)

        expect { parser.parse }.to raise_error(Bowling::Errors::InvalidScoreError)
      end

      it 'raises InvalidScoreError for negative scores' do
        parser = described_class.new(file_fixture('negative.txt').to_s)

        expect { parser.parse }.to raise_error(Bowling::Errors::InvalidScoreError)
      end
    end
  end
end
