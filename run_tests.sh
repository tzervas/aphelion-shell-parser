#!/bin/bash
# Test runner script for aphelion-shell-parser

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEST_DIR="${SCRIPT_DIR}/tests"

echo "=================================="
echo "Aphelion Shell Parser Test Suite"
echo "=================================="
echo ""

# Check if bats is installed
if ! command -v bats >/dev/null 2>&1; then
    echo "ERROR: bats is not installed."
    echo "Install it with: sudo apt-get install bats"
    echo "or: brew install bats-core (on macOS)"
    exit 1
fi

# Run all tests
echo "Running tests..."
echo ""

if [ -d "$TEST_DIR" ]; then
    bats "$TEST_DIR"/*.bats
    echo ""
    echo "=================================="
    echo "All tests completed!"
    echo "=================================="
else
    echo "ERROR: Tests directory not found at $TEST_DIR"
    exit 1
fi
