#!/usr/bin/env bats
# Tests for venv_parser.sh

setup() {
    # Load the parser
    source "${BATS_TEST_DIRNAME}/../bash_prompt/parsers/venv_parser.sh"
    
    # Create a temporary directory for testing
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
}

teardown() {
    # Clean up
    cd /
    rm -rf "$TEST_DIR"
    unset VIRTUAL_ENV
}

@test "parse_virtual_env returns empty when VIRTUAL_ENV not set" {
    unset VIRTUAL_ENV
    result=$(parse_virtual_env)
    [ -z "$result" ]
}

@test "parse_virtual_env detects active virtual environment" {
    # Create a fake venv directory
    mkdir -p /tmp/test-venv
    export VIRTUAL_ENV="/tmp/test-venv"
    
    result=$(parse_virtual_env)
    [[ "$result" =~ "Venv:" ]]
    [[ "$result" =~ "test-venv" ]]
    
    rm -rf /tmp/test-venv
}

@test "parse_virtual_env shows venv name" {
    mkdir -p /tmp/my-custom-venv
    export VIRTUAL_ENV="/tmp/my-custom-venv"
    
    result=$(parse_virtual_env)
    [[ "$result" =~ "my-custom-venv" ]]
    
    rm -rf /tmp/my-custom-venv
}

@test "parse_virtual_env calculates storage size" {
    # Skip if du is not available
    if ! command -v du >/dev/null 2>&1; then
        skip "du not installed"
    fi
    
    mkdir -p /tmp/test-venv-size
    echo "test" > /tmp/test-venv-size/test.txt
    export VIRTUAL_ENV="/tmp/test-venv-size"
    
    result=$(parse_virtual_env)
    [[ "$result" =~ "Venv:" ]]
    # Should contain a size indicator (could be K, M, or G)
    [[ "$result" =~ "|" ]]
    
    rm -rf /tmp/test-venv-size
}
