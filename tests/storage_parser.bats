#!/usr/bin/env bats
# Tests for storage_parser.sh

setup() {
    # Load the parser
    source "${BATS_TEST_DIRNAME}/../bash_prompt/parsers/storage_parser.sh"
    
    # Create a temporary directory for testing
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
}

teardown() {
    # Clean up
    cd /
    rm -rf "$TEST_DIR"
}

@test "calculate_storage_used returns size for current directory" {
    # Skip if du is not available
    if ! command -v du >/dev/null 2>&1; then
        skip "du not installed"
    fi
    
    # Create some files
    echo "test" > test.txt
    
    result=$(calculate_storage_used)
    [ -n "$result" ]
}

@test "calculate_storage_used returns size for specific path" {
    # Skip if du is not available
    if ! command -v du >/dev/null 2>&1; then
        skip "du not installed"
    fi
    
    # Create a directory with files
    mkdir -p test_dir
    echo "test" > test_dir/file.txt
    
    result=$(calculate_storage_used "test_dir")
    [ -n "$result" ]
}

@test "calculate_storage_used handles non-existent path" {
    result=$(calculate_storage_used "/nonexistent/path")
    [ -z "$result" ]
}
