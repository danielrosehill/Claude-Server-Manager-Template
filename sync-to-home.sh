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

# Function to prompt user for action
prompt_action() {
    local file_desc="$1"
    local default="$2"
    echo ""
    echo "Existing $file_desc found at target location."
    echo "How would you like to proceed?"
    echo "  [o] Overwrite - Replace with new version"
    echo "  [m] Merge - Keep existing and add new items"
    echo "  [d] Destructively overwrite - Delete existing and replace"
    echo "  [s] Skip - Keep existing, don't sync"

    if [ -n "$default" ]; then
        echo "  (default: $default)"
        read -p "Choice [o/m/d/s]: " -r choice
        choice=${choice:-$default}
    else
        read -p "Choice [o/m/d/s]: " -r choice
    fi

    echo "$choice"
}

# Sync CLAUDE.md
echo "Syncing CLAUDE.md..."
if [ -f "$HOME/CLAUDE.md" ]; then
    action=$(prompt_action "CLAUDE.md" "o")
    case "$action" in
        o|O)
            echo "Overwriting CLAUDE.md..."
            cp -v "$REPO_DIR/CLAUDE.md" "$HOME/CLAUDE.md"
            ;;
        m|M)
            echo "Merging not supported for CLAUDE.md (it's a single file). Use overwrite or skip."
            echo "Defaulting to overwrite..."
            cp -v "$REPO_DIR/CLAUDE.md" "$HOME/CLAUDE.md"
            ;;
        d|D)
            echo "Destructively overwriting CLAUDE.md..."
            rm -f "$HOME/CLAUDE.md"
            cp -v "$REPO_DIR/CLAUDE.md" "$HOME/CLAUDE.md"
            ;;
        s|S)
            echo "Skipping CLAUDE.md..."
            ;;
        *)
            echo "Invalid choice. Skipping CLAUDE.md..."
            ;;
    esac
else
    cp -v "$REPO_DIR/CLAUDE.md" "$HOME/CLAUDE.md"
fi

# Sync .claude directory
echo ""
echo "Syncing .claude directory..."

if [ -d "$HOME/.claude" ]; then
    # Check what exists in .claude
    has_commands=false
    has_agents=false
    [ -d "$HOME/.claude/commands" ] && has_commands=true
    [ -d "$HOME/.claude/agents" ] && has_agents=true

    if [ "$has_commands" = true ] || [ "$has_agents" = true ]; then
        action=$(prompt_action ".claude directory (commands/agents)" "m")
        case "$action" in
            o|O)
                echo "Overwriting .claude directory..."
                rsync -av "$REPO_DIR/.claude/" "$HOME/.claude/"
                ;;
            m|M)
                echo "Merging .claude directory (keeping existing, adding new)..."
                rsync -av "$REPO_DIR/.claude/" "$HOME/.claude/"
                echo "Merge complete. Existing files were preserved, new files were added."
                ;;
            d|D)
                echo "Destructively overwriting .claude directory..."
                rsync -av --delete "$REPO_DIR/.claude/" "$HOME/.claude/"
                ;;
            s|S)
                echo "Skipping .claude directory..."
                ;;
            *)
                echo "Invalid choice. Skipping .claude directory..."
                ;;
        esac
    else
        # .claude exists but is empty or has no commands/agents
        rsync -av "$REPO_DIR/.claude/" "$HOME/.claude/"
    fi
else
    rsync -av "$REPO_DIR/.claude/" "$HOME/.claude/"
fi

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
