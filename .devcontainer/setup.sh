#!/bin/bash
# DevContainer setup script

set -e

echo "Setting up development environment..."

# Install additional packages
sudo apt-get update
sudo apt-get install -y jq shellcheck bats

# Install python dependencies
pip3 install poetry

# Setup bash prompt for testing
mkdir -p ~/bash_prompt/parsers
cp -r /workspaces/aphelion-shell-parser/bash_prompt/* ~/bash_prompt/

# Make parsers executable
chmod +x ~/bash_prompt/parsers/*.sh
chmod +x ~/bash_prompt/prompt_generator.sh

echo "Development environment setup complete!"
echo "You can now test the shell parser functionality."
