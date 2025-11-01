#!/bin/bash

# Sync Claude Code configuration to both home directory and filesystem root
# This script copies .claude/ and CLAUDE.md to both ~ and / where Claude Code can access them
# Requires sudo for copying to /

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$SCRIPT_DIR"

echo "=== Claude Server Manager - Sync to Home AND Root ==="
echo "Repository location: $REPO_DIR"
echo "Target locations: $HOME and /"
echo ""

# Check if we're in the right directory
if [ ! -f "$REPO_DIR/CLAUDE.md" ] || [ ! -d "$REPO_DIR/.claude" ]; then
    echo "Error: CLAUDE.md or .claude directory not found in $REPO_DIR"
    echo "Please run this script from the Claude-Server-Manager-Template repository."
    exit 1
fi

# Check for sudo access
if ! sudo -v; then
    echo "Error: This script requires sudo access to copy files to /"
    exit 1
fi

echo "=== Syncing to $HOME ==="
echo ""

# Sync CLAUDE.md to home
echo "Syncing CLAUDE.md to home..."
cp -v "$REPO_DIR/CLAUDE.md" "$HOME/CLAUDE.md"

# Sync .claude directory to home
echo "Syncing .claude directory to home..."
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
echo "=== Syncing to / (requires sudo) ==="
echo ""

# Sync CLAUDE.md to root
echo "Syncing CLAUDE.md to /..."
sudo cp -v "$REPO_DIR/CLAUDE.md" "/CLAUDE.md"

# Sync .claude directory to root
echo "Syncing .claude directory to /..."
sudo rsync -av --delete "$REPO_DIR/.claude/" "/.claude/"

# Create hw-profile symlink at root if needed
if [ -d "$REPO_DIR/hw-profile" ]; then
    if [ ! -e "/hw-profile" ]; then
        echo "Creating hw-profile symlink at /hw-profile -> $REPO_DIR/hw-profile"
        sudo ln -sv "$REPO_DIR/hw-profile" "/hw-profile"
    else
        echo "/hw-profile already exists (skipping)"
    fi
fi

echo ""
echo "=== Sync Complete ==="
echo ""
echo "Claude Code configuration is now deployed to:"
echo "  - $HOME (user space)"
echo "  - / (system root)"
echo ""
echo "Run 'claude' from anywhere to use the server management commands."
echo ""
echo "Available slash commands: $(find "$HOME/.claude/commands" -name "*.md" 2>/dev/null | wc -l)"
echo ""
echo "To update after making changes to this repo, run this script again:"
echo "  $REPO_DIR/sync-to-home-and-root.sh"
