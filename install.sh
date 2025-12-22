#!/bin/bash
# Installation script for aphelion-shell-parser

set -e

INSTALL_DIR="${HOME}/bash_prompt"
BACKUP_DIR="${HOME}/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"

echo "=================================="
echo "Aphelion Shell Parser Installer"
echo "=================================="
echo ""

# Check if bash_prompt directory already exists
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  Warning: $INSTALL_DIR already exists."
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Installation cancelled."
        exit 1
    fi
    echo "Backing up existing installation to ${INSTALL_DIR}.backup..."
    mv "$INSTALL_DIR" "${INSTALL_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Create installation directory
echo "📁 Creating installation directory..."
mkdir -p "$INSTALL_DIR/parsers"

# Copy parser files
echo "📋 Copying parser files..."
cp bash_prompt/parsers/*.sh "$INSTALL_DIR/parsers/"
cp bash_prompt/prompt_generator.sh "$INSTALL_DIR/"

# Make scripts executable
echo "🔧 Making scripts executable..."
chmod +x "$INSTALL_DIR/parsers/"*.sh
chmod +x "$INSTALL_DIR/prompt_generator.sh"

# Backup existing .bashrc
if [ -f "${HOME}/.bashrc" ]; then
    echo "💾 Backing up existing .bashrc to $BACKUP_DIR..."
    cp "${HOME}/.bashrc" "$BACKUP_DIR"
fi

# Check if our configuration is already in .bashrc
if grep -q "aphelion-shell-parser" "${HOME}/.bashrc" 2>/dev/null; then
    echo "⚠️  Aphelion configuration already exists in .bashrc"
    read -p "Do you want to add it again? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping .bashrc modification."
    else
        echo "Adding configuration to .bashrc..."
        echo "" >> "${HOME}/.bashrc"
        cat .bashrc.example | grep -A 100 "Enhanced Bash Prompt" >> "${HOME}/.bashrc"
    fi
else
    echo "✏️  Adding configuration to .bashrc..."
    echo "" >> "${HOME}/.bashrc"
    echo "# Aphelion Shell Parser - Enhanced Bash Prompt" >> "${HOME}/.bashrc"
    cat .bashrc.example | grep -A 100 "Enhanced Bash Prompt" >> "${HOME}/.bashrc"
fi

echo ""
echo "=================================="
echo "✅ Installation complete!"
echo "=================================="
echo ""
echo "To activate the new prompt:"
echo "  source ~/.bashrc"
echo ""
echo "To uninstall:"
echo "  rm -rf $INSTALL_DIR"
echo "  Restore .bashrc from: $BACKUP_DIR"
echo ""
echo "For more information, see README.md"
