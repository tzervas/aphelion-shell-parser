#!/bin/bash
# Uninstallation script for aphelion-shell-parser

set -e

INSTALL_DIR="${HOME}/bash_prompt"

echo "=================================="
echo "Aphelion Shell Parser Uninstaller"
echo "=================================="
echo ""

# Check if installation exists
if [ ! -d "$INSTALL_DIR" ]; then
    echo "❌ Aphelion Shell Parser is not installed at $INSTALL_DIR"
    exit 1
fi

# Confirm uninstallation
read -p "Are you sure you want to uninstall Aphelion Shell Parser? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Remove installation directory
echo "🗑️  Removing installation directory..."
rm -rf "$INSTALL_DIR"

echo ""
echo "=================================="
echo "✅ Uninstallation complete!"
echo "=================================="
echo ""
echo "Note: Your .bashrc file still contains the Aphelion configuration."
echo "You may want to:"
echo "  1. Manually remove the Aphelion section from ~/.bashrc"
echo "  2. Or restore from a backup if you have one"
echo ""
echo "To restore your original prompt, remove or comment out the lines between:"
echo "  '# Aphelion Shell Parser' and '# Enhanced Bash Prompt Integration End'"
echo ""
