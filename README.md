# Ten-Pin Bowling Score Calculator

A command-line application to calculate and display scores for ten-pin bowling games.

## Table of Contents

- [Ten-Pin Bowling Score Calculator](#ten-pin-bowling-score-calculator)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
    - [Features](#features)
  - [Quick Start with Docker](#quick-start-with-docker)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Usage](#usage)
    - [Examples](#examples)
  - [Input File Format](#input-file-format)
  - [Output Format](#output-format)
  - [Running Tests](#running-tests)
  - [Project Structure](#project-structure)
  - [Architecture \& Design Decisions](#architecture--design-decisions)
    - [Design Principles](#design-principles)
    - [Class Responsibilities](#class-responsibilities)
    - [Error Handling](#error-handling)
  - [Test Fixtures](#test-fixtures)
    - [Positive (Valid) Test Cases](#positive-valid-test-cases)
    - [Negative (Invalid) Test Cases](#negative-invalid-test-cases)
  - [License](#license)

## Overview

This application reads a bowling game input file containing player names and their roll results, calculates the scores according to official ten-pin bowling rules (including strikes, spares, and the special 10th frame), and outputs a formatted scoreboard.

### Features

- Support for multiple players in a single game
- Proper handling of strikes (X), spares (/), and fouls (F)
- Correct bonus calculation for strikes and spares
- Special 10th frame handling (up to 3 rolls)
- Input validation with descriptive error messages
- Perfect game support (300 points)
- Docker support for easy execution without Ruby installation

## Quick Start with Docker

If you have Docker installed, you can run the application without installing Ruby:

**Using the helper script (recommended):**

```bash
# Make the script executable (first time only)
chmod +x run.sh

# Run with a score file
./run.sh spec/fixtures/positive/scores.txt

# Perfect game example
./run.sh spec/fixtures/positive/perfect.txt

# Game with 3 players
./run.sh spec/fixtures/positive/scores-of-three-players.txt
```

**Or using Docker directly:**

```bash
# Build the image
docker build -t bowling-calculator .

# Run with your score file
docker run --rm -v $(pwd)/spec/fixtures/positive/scores.txt:/app/input.txt bowling-calculator /app/input.txt
```

## Requirements

**Option A - Using Docker (no Ruby installation needed):**
- Docker

**Option B - Local Ruby installation:**
- Ruby 3.4.6 (managed via asdf or rbenv)
- Bundler gem

## Installation

1. Clone the repository:

```bash
git clone git@git.jobsity.com:marcelotoledo/ruby-challenge.git
cd ruby-challenge
```

2. Ensure you have Ruby 3.4.6 installed:

```bash
# Using asdf
asdf install ruby 3.4.6
asdf local ruby 3.4.6

# Or using rbenv
rbenv install 3.4.6
rbenv local 3.4.6
```

3. Install dependencies:

```bash
bundle install
```

## Usage

Run the application from the command line with an input file:

```bash
ruby lib/main.rb <input_file>
```

### Examples

**Standard game with two players:**

```bash
ruby lib/main.rb spec/fixtures/positive/scores.txt
```

Output:
```
Frame		1		2		3		4		5		6		7		8		9		10
Jeff
Pinfalls		X	7	/	9	F		X	F	8	8	/	F	6		X		X	X	8	1
Score		20		39		48		66		74		84		90		120		148		167
John
Pinfalls	3	/	6	3		X	8	1		X		X	9	F	7	/	4	4	X	9	F
Score		16		25		44		53		82		101		110		124		132		151
```

**Perfect game (all strikes):**

```bash
ruby lib/main.rb spec/fixtures/positive/perfect.txt
```

Output:
```
Frame		1		2		3		4		5		6		7		8		9		10
Carl
Pinfalls		X		X		X		X		X		X		X		X		X	X	X	X
Score		30		60		90		120		150		180		210		240		270		300
```

## Input File Format

The input file should follow these rules:

1. Each line represents a player and a single roll
2. Format: `PlayerName<TAB>PinsKnockedDown`
3. Pins knocked down can be:
   - A number from 0 to 10
   - `F` for a foul (counts as 0 pins)
4. Players can be interleaved (as in a real game)

**Example input file:**

```
Jeff	10
John	3
John	7
Jeff	7
Jeff	3
John  0
...
```

## Output Format

The scoreboard displays:

1. **Frame header** - Frame numbers 1-10
2. **For each player:**
   - Player name
   - Pinfalls row showing:
     - `X` for strikes
     - `/` for spares
     - `F` for fouls (0 pins)
     - Numbers for regular rolls
   - Score row with cumulative scores

## Running Tests

**Run all tests:**

```bash
bundle exec rspec
```

**Run tests with documentation format:**

```bash
bundle exec rspec --format documentation
```

**Run a specific test file:**

```bash
bundle exec rspec spec/lib/bowling/frame_spec.rb
```

**Run linter:**

```bash
bundle exec rubocop
```

## Project Structure

```
ruby-challenge/
├── lib/
│   ├── main.rb                     # CLI entry point
│   ├── bowling/
│   │   ├── frame.rb                # Frame model (strike, spare, completion logic)
│   │   ├── game.rb                 # Game orchestrator
│   │   ├── player.rb               # Player with frames
│   │   └── score_calculator.rb     # Score calculation with bonuses
│   ├── errors/
│   │   └── bowling_errors.rb       # Custom error classes
│   ├── formatters/
│   │   └── scoreboard_formatter.rb # Output formatting
│   ├── parsers/
│   │   └── game_file_parser.rb     # Input file parsing
│   └── validators/
│       └── input_validator.rb      # Input validation
├── spec/
│   ├── lib/                        # Unit and integration tests
│   ├── fixtures/
│   │   ├── positive/               # Valid input files
│   │   └── negative/               # Invalid input files for error testing
│   ├── support/
│   │   └── file_fixtures.rb        # Test helpers
│   └── spec_helper.rb
├── Gemfile
├── Gemfile.lock
├── .rubocop.yml
├── .tool-versions
├── Dockerfile                      # Docker configuration
├── run.sh                          # Docker helper script
└── README.md
```

## Architecture & Design Decisions

### Design Principles

The application follows **SOLID principles**:

- **Single Responsibility Principle (SRP)**: Each class has one clear responsibility:
  - `Frame` - Manages frame state (rolls, strike/spare detection)
  - `Player` - Holds player data and frames
  - `Game` - Orchestrates players
  - `ScoreCalculator` - Calculates scores with bonuses
  - `GameFileParser` - Parses input files
  - `InputValidator` - Validates game rules
  - `ScoreboardFormatter` - Formats output

- **Open/Closed Principle**: Classes are open for extension (e.g., different formatters could be created) but closed for modification.

- **Dependency Inversion**: Components depend on abstractions. The `Main` class coordinates components through their interfaces, not concrete implementations.

### Class Responsibilities

| Class | Responsibility |
|-------|---------------|
| `Bowling::Main` | CLI entry point, orchestrates the flow |
| `Bowling::Frame` | Represents a single frame, handles strike/spare logic |
| `Bowling::Player` | Manages a player's 10 frames |
| `Bowling::Game` | Holds all players in a game |
| `Bowling::ScoreCalculator` | Calculates cumulative scores with bonuses |
| `Parsers::GameFileParser` | Reads and parses input files |
| `Validators::InputValidator` | Validates input according to bowling rules |
| `Formatters::ScoreboardFormatter` | Generates formatted scoreboard output |
| `Errors::BowlingError` | Base error class with specific subclasses |

### Error Handling

Custom error classes provide clear feedback:

- `FileNotFoundError` - Input file doesn't exist
- `EmptyFileError` - Input file is empty
- `InvalidFormatError` - Malformed input lines
- `InvalidScoreError` - Invalid pin values (negative, > 10, non-numeric)
- `InvalidRollCountError` - Wrong number of rolls for a player

## Test Fixtures

### Positive (Valid) Test Cases

| File | Description |
|------|-------------|
| `scores.txt` | Standard game with 2 players (Jeff & John) |
| `perfect.txt` | Perfect game - all strikes (300 points) |
| `scores-of-three-players.txt` | Game with 3 players |

### Negative (Invalid) Test Cases

| File | Description |
|------|-------------|
| `empty.txt` | Empty file |
| `free-text.txt` | Invalid format (not tab-separated) |
| `invalid-score.txt` | Non-numeric score values |
| `negative.txt` | Negative pin values |
| `extra-score.txt` | Too many rolls for a player |

## License

This project was created as part of a technical challenge.
