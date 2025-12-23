# aphelion-shell-parser

Aphelion Shell Parser is a modular bash prompt enhancement system that displays contextual information about your development environment. It automatically detects Git repositories, Python virtual environments, Docker containers, Kubernetes contexts, and more, presenting relevant information in your terminal prompt.

## Features

- **Git Integration**: Display current branch, status, and commit information
- **Python Project Detection**: Shows Poetry/pip project info and virtual environment status
- **DevOps Tools**: Integration with Docker, Kubernetes, Helm, Terraform, and AWS CloudFormation
- **Modular Design**: Easy to extend with new parsers
- **Error Resilient**: Gracefully handles missing tools and invalid states
- **Containerized Testing**: Full DevContainer and Docker support for development and testing

## Quick Start

### Using DevContainer (Recommended for Development)

1. Open this repository in VS Code with the Dev Containers extension
2. VS Code will automatically build and configure the development environment
3. The prompt will be automatically configured for testing

### Manual Installation

```bash
# Clone the repository
git clone https://github.com/tzervas/aphelion-shell-parser.git
cd aphelion-shell-parser

# Copy files to your home directory
mkdir -p ~/bash_prompt/parsers
cp bash_prompt/parsers/*.sh ~/bash_prompt/parsers/
cp bash_prompt/prompt_generator.sh ~/bash_prompt/

# Backup your existing .bashrc
cp ~/.bashrc ~/.bashrc.backup

# Append the prompt configuration to your .bashrc
cat .bashrc.example >> ~/.bashrc

# Reload your shell configuration
source ~/.bashrc
```

### Docker Testing

```bash
# Build and run the test container
docker build -t aphelion-parser-test .
docker run -it aphelion-parser-test

# Or use docker-compose
docker-compose up -d
docker-compose exec parser-test bash
```

## What Gets Displayed

The prompt displays contextual information based on your current directory:

- **Git**: `Git:(branch|status|commit-hash)` - Shows when in a git repository
- **Python**: `Python: Poetry|project-name vX.X.X` - Shows Python project info
- **Venv**: `Venv:env-name|size` - Shows active virtual environment
- **Docker**: `Docker:N running` - Shows number of running containers
- **K8s**: `K8s:context-name` - Shows current Kubernetes context
- **Helm**: `Helm:N deployed` - Shows number of deployed Helm charts
- **TF**: `TF:workspace` - Shows Terraform workspace when in a terraform directory
- **CFN**: `CFN:N active stacks` - Shows CloudFormation stacks (requires AWS CLI)

## Prerequisites

Core requirements:
- Bash 4.0+
- Git (for git parser functionality)

Optional (for specific parsers):
- Python 3.8+ and python3-venv (for Python parsers)
- Docker (for Docker parser)
- kubectl (for Kubernetes parser)
- Helm (for Helm parser)
- Terraform (for Terraform parser)
- AWS CLI v2 and jq (for CloudFormation parser)

See [TESTING.md](TESTING.md) for detailed setup instructions.

## Architecture

The system consists of three main components:

1. **Parser Modules** (`bash_prompt/parsers/*.sh`): Individual parsers for different tools
2. **Prompt Generator** (`bash_prompt/prompt_generator.sh`): Orchestrates parsers and builds the prompt
3. **Bashrc Integration** (`.bashrc.example`): Hooks the prompt generator into bash

### Parser Design

Each parser:
- Returns nothing if the tool/context is not applicable
- Returns formatted string if information is available
- Handles missing dependencies gracefully
- Avoids direct execution on source (only defines functions)

## Development

### Running Tests

```bash
# Install bats (if not already installed)
sudo apt-get install bats  # Ubuntu/Debian
# or
brew install bats-core     # macOS

# Run all tests
./run_tests.sh

# Run specific test suite
bats tests/git_parser.bats
```

See [TESTING.md](TESTING.md) for comprehensive testing documentation.

### Adding a New Parser

1. Create a new parser file in `bash_prompt/parsers/`:

```bash
#!/bin/bash

parse_my_tool_info() {
    # Check if tool is available
    if ! type my_tool >/dev/null 2>&1; then
        return
    fi
    
    # Gather information
    local info=$(my_tool status 2>/dev/null)
    
    # Return formatted output
    if [ -n "$info" ]; then
        echo "MyTool:${info}"
    fi
}
```

2. The prompt generator will automatically source and call your parser
3. Add tests in `tests/my_tool_parser.bats`

### Code Quality

The project includes:
- ShellCheck integration for static analysis
- Comprehensive test coverage with bats
- DevContainer for consistent development environment
- Docker-based testing infrastructure

## Troubleshooting

### Prompt not showing up
- Ensure `~/bash_prompt/prompt_generator.sh` is executable: `chmod +x ~/bash_prompt/prompt_generator.sh`
- Check that all parser files are executable: `chmod +x ~/bash_prompt/parsers/*.sh`
- Verify your .bashrc sources the prompt generator correctly

### Git info not displaying
- Ensure you're in a git repository
- Check that git is installed: `git --version`

### Docker/Kubernetes info not showing
- Ensure the tools are installed and in your PATH
- For Docker, make sure the daemon is running
- For Kubernetes, ensure you have a valid kubeconfig

### Performance issues
- The prompt generator sources parsers on each prompt
- Consider disabling parsers you don't use by removing them from `bash_prompt/parsers/`

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for your changes
4. Ensure all tests pass: `./run_tests.sh`
5. Submit a pull request

## License

MIT License - see [LICENSE](LICENSE) file for details

## Credits

Original project by tzervas. Enhanced with improved error handling, containerized testing, and comprehensive test coverage.
