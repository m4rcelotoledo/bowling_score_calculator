#!/bin/bash

# Bowling Score Calculator - Docker Runner
# Usage: ./run.sh <path-to-score-file>

set -e

IMAGE_NAME="bowling-calculator"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

show_usage() {
    echo -e "${GREEN}Ten-Pin Bowling Score Calculator${NC}"
    echo ""
    echo "Usage: $0 <path-to-score-file>"
    echo ""
    echo "Examples:"
    echo "  $0 spec/fixtures/positive/scores.txt"
    echo "  $0 spec/fixtures/positive/perfect.txt"
    echo "  $0 /absolute/path/to/game.txt"
    echo ""
    echo "Available test files:"
    echo "  spec/fixtures/positive/scores.txt      - Standard game (2 players)"
    echo "  spec/fixtures/positive/perfect.txt     - Perfect game (300 points)"
    echo "  spec/fixtures/positive/scores-of-three-players.txt - 3 players"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if argument provided
if [ $# -eq 0 ]; then
    show_usage
    exit 1
fi

INPUT_FILE="$1"

# Convert to absolute path if relative
if [[ ! "$INPUT_FILE" = /* ]]; then
    INPUT_FILE="$SCRIPT_DIR/$INPUT_FILE"
fi

# Check if file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo -e "${RED}Error: File not found: $1${NC}"
    exit 1
fi

# Build image if it doesn't exist or if Dockerfile is newer
if [[ ! "$(docker images -q $IMAGE_NAME 2> /dev/null)" ]] || \
   [[ "$SCRIPT_DIR/Dockerfile" -nt "$(docker inspect -f '{{.Created}}' $IMAGE_NAME 2>/dev/null || echo '0')" ]]; then
    echo -e "${YELLOW}Building Docker image...${NC}"
    docker build -t "$IMAGE_NAME" "$SCRIPT_DIR" --quiet
    echo -e "${GREEN}Image built successfully!${NC}"
    echo ""
fi

# Run the container with the input file mounted
docker run --rm \
    -v "$INPUT_FILE:/app/input.txt:ro" \
    "$IMAGE_NAME" \
    /app/input.txt
