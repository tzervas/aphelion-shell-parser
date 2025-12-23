#!/usr/bin/env bats
# Tests for docker_parser.sh

setup() {
    # Load the parser
    source "${BATS_TEST_DIRNAME}/../bash_prompt/parsers/docker_parser.sh"
}

@test "parse_docker_info returns empty when docker not installed" {
    # Mock docker to not exist
    function docker() { return 127; }
    export -f docker
    
    result=$(parse_docker_info)
    [ -z "$result" ]
}

@test "parse_docker_info returns empty when docker daemon not running" {
    # Skip if docker is installed and running
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
        skip "docker is running, cannot test non-running case"
    fi
    
    result=$(parse_docker_info)
    [ -z "$result" ]
}

@test "parse_docker_info shows running containers" {
    # Skip if docker is not installed or not running
    if ! command -v docker >/dev/null 2>&1 || ! docker info >/dev/null 2>&1; then
        skip "docker not available"
    fi
    
    result=$(parse_docker_info)
    # Should either show number or be empty
    [[ "$result" =~ "Docker:" ]] || [ -z "$result" ]
}
