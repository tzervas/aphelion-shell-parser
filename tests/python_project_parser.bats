#!/usr/bin/env bats
# Tests for python_project_parser.sh

setup() {
    # Load the parser
    source "${BATS_TEST_DIRNAME}/../bash_prompt/parsers/python_project_parser.sh"
    
    # Create a temporary directory for testing
    TEST_DIR=$(mktemp -d)
    cd "$TEST_DIR"
}

teardown() {
    # Clean up
    cd /
    rm -rf "$TEST_DIR"
}

@test "parse_python_project returns empty when no Python files" {
    result=$(parse_python_project)
    [ -z "$result" ]
}

@test "parse_python_project detects pyproject.toml" {
    cat > pyproject.toml <<EOF
[tool.poetry]
name = "test-project"
version = "1.0.0"
EOF
    
    result=$(parse_python_project)
    [[ "$result" =~ "Poetry" ]]
    [[ "$result" =~ "test-project" ]]
    [[ "$result" =~ "1.0.0" ]]
}

@test "parse_python_project detects requirements.txt" {
    cat > requirements.txt <<EOF
# project: my-project
flask==2.0.0
requests==2.26.0
EOF
    
    result=$(parse_python_project)
    [[ "$result" =~ "proj:" ]]
    [[ "$result" =~ "deps:2" ]]
}

@test "parse_python_project counts dependencies in requirements.txt" {
    cat > requirements.txt <<EOF
flask==2.0.0
requests==2.26.0
django==3.2.0
# This is a comment
pytest==6.2.0
EOF
    
    result=$(parse_python_project)
    [[ "$result" =~ "deps:4" ]]
}

@test "parse_python_project handles empty requirements.txt" {
    touch requirements.txt
    
    result=$(parse_python_project)
    [[ "$result" =~ "proj:" ]]
    [[ "$result" =~ "deps:0" ]]
}

@test "parse_python_project uses directory name as default" {
    mkdir -p my-test-project
    cd my-test-project
    
    cat > requirements.txt <<EOF
flask==2.0.0
EOF
    
    result=$(parse_python_project)
    [[ "$result" =~ "my-test-project" ]]
}

@test "parse_python_project detects setup.py" {
    cat > setup.py <<EOF
from setuptools import setup
setup(name='test-setup-project')
EOF
    
    result=$(parse_python_project)
    [[ "$result" =~ "setuptools" ]]
}

@test "parse_python_project detects Pipfile" {
    cat > Pipfile <<EOF
[[source]]
url = "https://pypi.org/simple"
verify_ssl = true
name = "pypi"

[packages]
flask = "*"
EOF
    
    result=$(parse_python_project)
    [[ "$result" =~ "Pipenv" ]]
}
