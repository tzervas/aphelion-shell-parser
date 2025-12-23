# Contributing to Aphelion Shell Parser

Thank you for your interest in contributing to Aphelion Shell Parser! This document provides guidelines and instructions for contributing.

## Getting Started

### Development Environment

We recommend using the provided DevContainer for development:

1. Install [Docker](https://www.docker.com/get-started) and [VS Code](https://code.visualstudio.com/)
2. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
3. Open this repository in VS Code
4. Press `F1` and select "Dev Containers: Reopen in Container"

Alternatively, you can use Docker directly:

```bash
docker-compose up -d
docker-compose exec parser-test bash
```

### Running Tests

Before submitting any changes, make sure all tests pass:

```bash
./run_tests.sh
```

To run shellcheck:

```bash
shellcheck bash_prompt/parsers/*.sh bash_prompt/prompt_generator.sh
```

## How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/tzervas/aphelion-shell-parser/issues)
2. If not, create a new issue with:
   - A clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Your environment (OS, bash version, etc.)

### Suggesting Enhancements

1. Check existing issues and discussions
2. Create a new issue with:
   - Clear description of the enhancement
   - Use cases and benefits
   - Possible implementation approach

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Make your changes following our [Coding Standards](#coding-standards)
4. Add or update tests as needed
5. Ensure all tests pass: `./run_tests.sh`
6. Run shellcheck on your changes
7. Commit your changes with clear messages
8. Push to your fork
9. Submit a pull request

#### Pull Request Guidelines

- Keep changes focused and atomic
- Update documentation if needed
- Add tests for new functionality
- Follow existing code style
- Write clear commit messages

## Coding Standards

### Shell Script Style

- Use `#!/bin/bash` shebang
- Use 4 spaces for indentation (no tabs)
- Use descriptive variable names in lowercase with underscores
- Use `local` for function variables
- Quote variables: `"$variable"` not `$variable`
- Check for command existence before use: `type command >/dev/null 2>&1`
- Return nothing (empty) instead of error messages when conditions aren't met

### Function Design

Each parser function should:

1. Check if the tool is available
2. Check if the context is relevant
3. Gather information only if applicable
4. Return formatted string or nothing
5. Handle errors gracefully

Example:

```bash
#!/bin/bash

parse_my_tool_info() {
    # Check if tool is installed
    if ! type my_tool >/dev/null 2>&1; then
        return
    fi
    
    # Check if context is relevant
    if [ ! -f ".my_tool_config" ]; then
        return
    fi
    
    # Gather information
    local info
    info=$(my_tool status 2>/dev/null)
    
    # Return formatted output only if we have info
    if [ -n "$info" ]; then
        echo "MyTool:${info}"
    fi
}
```

### Testing

- Write bats tests for new parsers
- Test both success and failure cases
- Use `skip` for tests that require specific tools
- Clean up temporary files in teardown

Example test:

```bash
@test "parse_my_tool_info returns empty when tool not installed" {
    # Mock command to fail
    function my_tool() { return 127; }
    export -f my_tool
    
    result=$(parse_my_tool_info)
    [ -z "$result" ]
}
```

## Adding a New Parser

To add a new parser:

1. Create `bash_prompt/parsers/my_tool_parser.sh`:

```bash
#!/bin/bash

parse_my_tool_info() {
    # Implementation here
}
```

2. Create `tests/my_tool_parser.bats`:

```bash
#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/../bash_prompt/parsers/my_tool_parser.sh"
}

@test "parse_my_tool_info basic functionality" {
    # Test implementation
}
```

3. The prompt generator will automatically discover and use your parser
4. Run tests and ensure they pass
5. Update README.md with information about the new parser
6. Submit a pull request

## Documentation

- Update README.md for user-facing changes
- Update TESTING.md for test-related changes
- Add inline comments for complex logic
- Keep documentation clear and concise

## Release Process

(For maintainers)

1. Update version in relevant files
2. Update CHANGELOG.md
3. Create a git tag: `git tag -a v1.0.0 -m "Release 1.0.0"`
4. Push tag: `git push origin v1.0.0`
5. Create GitHub release with release notes

## Questions?

Feel free to open an issue for questions or discussions about contributing.

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
