# Testing Guide

This guide explains how to test the Aphelion Shell Parser using containerized environments.

## Quick Start with Docker

### Build and run the test container:

```bash
# Build the Docker image
docker build -t aphelion-parser-test .

# Run the container
docker run -it aphelion-parser-test

# Inside the container, run tests
cd /workspace
./run_tests.sh
```

### Using Docker Compose:

```bash
# Start the test environment
docker-compose up -d

# Enter the container
docker-compose exec parser-test bash

# Run tests
./run_tests.sh

# Stop the container
docker-compose down
```

## Using DevContainer (VS Code)

1. Install the "Dev Containers" extension in VS Code
2. Open this repository in VS Code
3. Press `F1` and select "Dev Containers: Reopen in Container"
4. Wait for the container to build and setup
5. Open a terminal in VS Code and run:

```bash
./run_tests.sh
```

## Manual Testing

### Install dependencies:

```bash
# On Ubuntu/Debian
sudo apt-get install git jq bats shellcheck python3 python3-venv

# Optional tools for full testing
# AWS CLI, kubectl, helm, terraform, docker
```

### Run tests:

```bash
./run_tests.sh
```

### Test individual parsers:

```bash
# Test git parser
bats tests/git_parser.bats

# Test python project parser
bats tests/python_project_parser.bats

# Test venv parser
bats tests/venv_parser.bats

# Test docker parser
bats tests/docker_parser.bats

# Test storage parser
bats tests/storage_parser.bats
```

## Testing the Prompt Generator

To test the prompt generator in a live environment:

```bash
# Copy the files to your home directory
mkdir -p ~/bash_prompt/parsers
cp bash_prompt/parsers/*.sh ~/bash_prompt/parsers/
cp bash_prompt/prompt_generator.sh ~/bash_prompt/

# Copy the example bashrc
cp .bashrc.example ~/.bashrc

# Source the new bashrc
source ~/.bashrc

# Your prompt should now display contextual information
```

## What Each Test Does

### git_parser.bats
- Tests git repository detection
- Validates branch name display
- Checks status reporting (clean/dirty)
- Ensures graceful handling when git is not installed

### python_project_parser.bats
- Tests pyproject.toml detection (Poetry projects)
- Validates requirements.txt parsing
- Tests dependency counting
- Verifies default project name handling

### venv_parser.bats
- Tests virtual environment detection
- Validates VIRTUAL_ENV variable handling
- Tests storage size calculation

### docker_parser.bats
- Tests Docker installation detection
- Validates container counting
- Ensures graceful handling when Docker daemon is not running

### storage_parser.bats
- Tests storage calculation function
- Validates path handling
- Tests error handling for non-existent paths

## Continuous Integration

The tests can be integrated into CI/CD pipelines:

```yaml
# Example GitHub Actions workflow
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install bats
        run: sudo apt-get install -y bats
      - name: Run tests
        run: ./run_tests.sh
```

## Troubleshooting

### Tests fail with "bats: command not found"
Install bats: `sudo apt-get install bats` or `brew install bats-core`

### Docker tests fail
Ensure Docker daemon is running and you have permissions to access it.

### Git tests fail
Ensure git is installed and configured with user.name and user.email.

### Permission denied errors
Make sure the test scripts are executable: `chmod +x run_tests.sh tests/*.bats`
