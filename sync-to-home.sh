#!/bin/bash

# Sync Claude Code configuration to home directory
# This script copies .claude/ and CLAUDE.md from the repo to ~ where Claude Code expects them

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

echo "=== Claude Server Manager - Sync to Home ==="
echo "Repository location: $REPO_DIR"
echo "Target location: $HOME"
echo ""

# Check if we're in the right directory
if [ ! -f "$REPO_DIR/CLAUDE.md" ] || [ ! -d "$REPO_DIR/.claude" ]; then
    echo "Error: CLAUDE.md or .claude directory not found in $REPO_DIR"
    echo "Please run this script from the Claude-Server-Manager-Template repository."
    exit 1
fi

# Sync CLAUDE.md
echo "Syncing CLAUDE.md..."
cp -v "$REPO_DIR/CLAUDE.md" "$HOME/CLAUDE.md"

# Sync .claude directory
echo "Syncing .claude directory..."
rsync -av --delete "$REPO_DIR/.claude/" "$HOME/.claude/"

# Check for hw-profile directory
if [ -d "$REPO_DIR/hw-profile" ]; then
    echo ""
    if [ ! -d "$HOME/hw-profile" ]; then
        echo "Creating hw-profile symlink at ~/hw-profile -> $REPO_DIR/hw-profile"
        ln -sv "$REPO_DIR/hw-profile" "$HOME/hw-profile"
    else
        echo "~/hw-profile already exists (skipping)"
    fi
fi

echo ""
echo "=== Sync Complete ==="
echo ""
echo "Claude Code configuration is now deployed to your home directory."
echo "Run 'claude' from anywhere to use the server management commands."
echo ""
echo "Available slash commands: $(find "$HOME/.claude/commands" -name "*.md" 2>/dev/null | wc -l)"
echo ""
echo "To update after making changes to this repo, run this script again:"
echo "  $REPO_DIR/sync-to-home.sh"
