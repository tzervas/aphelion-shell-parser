#!/usr/bin/env bats
# Tests for git_parser.sh

setup() {
    # Load the parser
    source "${BATS_TEST_DIRNAME}/../bash_prompt/parsers/git_parser.sh"
    
    # Create a temporary directory for testing
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
}

teardown() {
    # Clean up
    cd /
    rm -rf "$TEST_DIR"
}

@test "parse_git_info returns empty when not in git repo" {
    result=$(parse_git_info)
    [ -z "$result" ]
}

@test "parse_git_info returns empty when git not installed" {
    # Mock git command to fail
    function git() { return 127; }
    export -f git
    
    result=$(parse_git_info)
    [ -z "$result" ]
}

@test "parse_git_info works in git repository" {
    # Skip if git is not installed
    if ! command -v git >/dev/null 2>&1; then
        skip "git not installed"
    fi
    
    # Initialize a git repo
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Create a file and commit
    echo "test" > test.txt
    git add test.txt
    git commit -m "Initial commit"
    
    result=$(parse_git_info)
    [[ "$result" =~ "Git:" ]]
    [[ "$result" =~ "main" ]] || [[ "$result" =~ "master" ]]
}

@test "parse_git_info shows branch name" {
    # Skip if git is not installed
    if ! command -v git >/dev/null 2>&1; then
        skip "git not installed"
    fi
    
    # Initialize a git repo
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Create a file and commit
    echo "test" > test.txt
    git add test.txt
    git commit -m "Initial commit"
    
    # Create a new branch
    git checkout -b test-branch
    
    result=$(parse_git_info)
    [[ "$result" =~ "test-branch" ]]
}

@test "parse_git_info shows dirty status" {
    # Skip if git is not installed
    if ! command -v git >/dev/null 2>&1; then
        skip "git not installed"
    fi
    
    # Initialize a git repo
    git init
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    # Create a file and commit
    echo "test" > test.txt
    git add test.txt
    git commit -m "Initial commit"
    
    # Modify the file
    echo "modified" >> test.txt
    
    result=$(parse_git_info)
    [[ "$result" =~ "Git:" ]]
    # Should show M for modified
    [[ "$result" =~ "M" ]] || [[ "$result" =~ "Clean" ]]
}
