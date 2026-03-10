#!/bin/bash

################################################################################
# MACH-I Mac Studio Bootstrap Script
# ====================================
#
# One-shot setup for the edave user account on Eddie's Mac Studio.
# Run this via SSH after the initial OS setup is complete and Homebrew
# is already installed.
#
# This script is idempotent — safe to run multiple times.
#
# Prerequisites:
#   - macOS user: edave
#   - Homebrew already installed at /opt/homebrew
#   - gh (GitHub CLI) already installed via brew
#
# Usage:
#   chmod +x studio-bootstrap.sh
#   ./studio-bootstrap.sh
#
################################################################################

set -e  # Exit on error

# Color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BOLD='\033[1m'
NC='\033[0m'

# Track what we did for the summary
ACTIONS=()

info()    { echo -e "${BLUE}[INFO]${NC}  $1"; }
success() { echo -e "${GREEN}[OK]${NC}    $1"; }
warn()    { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()   { echo -e "${RED}[ERR]${NC}   $1"; }
step()    { echo -e "\n${BOLD}${BLUE}━━━ Step $1 ━━━${NC}"; }

echo -e "${BOLD}${BLUE}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║         MACH-I Mac Studio Bootstrap                     ║"
echo "║         Target: edave@mach1-studio                      ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

########################################
# Step 1: Add Homebrew to PATH
########################################
step "1/10 — Homebrew PATH"

HOMEBREW_PREFIX="/opt/homebrew"

if [ -d "$HOMEBREW_PREFIX" ]; then
    eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"
    success "Homebrew environment loaded from $HOMEBREW_PREFIX"
    ACTIONS+=("Loaded Homebrew into PATH")
else
    error "Homebrew not found at $HOMEBREW_PREFIX — install it first"
    exit 1
fi

########################################
# Step 2: Check gh authentication
########################################
step "2/10 — GitHub CLI authentication"

if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null 2>&1; then
        GH_USER=$(gh api user --jq .login 2>/dev/null || echo "unknown")
        success "gh is authenticated as: $GH_USER"
        ACTIONS+=("Verified gh authentication (user: $GH_USER)")
    else
        warn "gh is installed but NOT authenticated"
        warn "Run 'gh auth login' before using git push/pull with HTTPS"
        warn "Continuing anyway — repos will be cloned but may not push"
        ACTIONS+=("WARNING: gh not authenticated")
    fi
else
    warn "gh (GitHub CLI) is not installed"
    warn "Install with: brew install gh"
    ACTIONS+=("WARNING: gh not installed")
fi

########################################
# Step 3: Clone or pull ~/Claude/agents
########################################
step "3/10 — Claude agents repo"

AGENTS_DIR="$HOME/Claude/agents"
AGENTS_REPO="https://github.com/txcfi-scott/claude-agents.git"

mkdir -p "$HOME/Claude"

if [ -d "$AGENTS_DIR/.git" ]; then
    info "Repository exists at $AGENTS_DIR — pulling latest..."
    cd "$AGENTS_DIR"
    if git pull 2>&1; then
        success "Pulled latest changes"
        ACTIONS+=("Pulled latest ~/Claude/agents")
    else
        warn "Could not pull — check authentication"
        ACTIONS+=("WARNING: Could not pull ~/Claude/agents")
    fi
else
    info "Cloning $AGENTS_REPO..."
    git clone "$AGENTS_REPO" "$AGENTS_DIR"
    success "Cloned to $AGENTS_DIR"
    ACTIONS+=("Cloned ~/Claude/agents from GitHub")
fi

########################################
# Step 4: Clone or pull ~/Projects/mach-i-website
########################################
step "4/10 — MACH-I Website repo"

PROJECTS_DIR="$HOME/Projects"
WEBSITE_DIR="$PROJECTS_DIR/mach-i-website"
WEBSITE_REPO="https://github.com/txcfi-scott/MACH-I-Website.git"

mkdir -p "$PROJECTS_DIR"

if [ -d "$WEBSITE_DIR/.git" ]; then
    info "Repository exists at $WEBSITE_DIR — pulling latest..."
    cd "$WEBSITE_DIR"
    if git pull 2>&1; then
        success "Pulled latest changes"
        ACTIONS+=("Pulled latest ~/Projects/mach-i-website")
    else
        warn "Could not pull — check authentication"
        ACTIONS+=("WARNING: Could not pull mach-i-website")
    fi
else
    info "Cloning $WEBSITE_REPO..."
    git clone "$WEBSITE_REPO" "$WEBSITE_DIR"
    success "Cloned to $WEBSITE_DIR"
    ACTIONS+=("Cloned ~/Projects/mach-i-website from GitHub")
fi

########################################
# Step 5: Create ~/.claude/commands/
########################################
step "5/10 — Claude commands directory"

CLAUDE_COMMANDS_DIR="$HOME/.claude/commands"

if [ -d "$CLAUDE_COMMANDS_DIR" ]; then
    success "~/.claude/commands/ already exists"
else
    mkdir -p "$CLAUDE_COMMANDS_DIR"
    success "Created ~/.claude/commands/"
fi
ACTIONS+=("Ensured ~/.claude/commands/ exists")

########################################
# Step 6: Copy agent commands
########################################
step "6/10 — Copy agent command files"

AGENT_COMMANDS_SRC="$AGENTS_DIR/commands"

if [ -d "$AGENT_COMMANDS_SRC" ]; then
    CMD_COUNT=$(ls -1 "$AGENT_COMMANDS_SRC"/*.md 2>/dev/null | wc -l | tr -d ' ')
    if [ "$CMD_COUNT" -gt 0 ]; then
        cp "$AGENT_COMMANDS_SRC"/*.md "$CLAUDE_COMMANDS_DIR/"
        success "Copied $CMD_COUNT command files to ~/.claude/commands/"
        ACTIONS+=("Copied $CMD_COUNT command .md files to ~/.claude/commands/")
    else
        warn "No .md files found in $AGENT_COMMANDS_SRC"
        ACTIONS+=("WARNING: No command files found to copy")
    fi
else
    warn "Agent commands source not found at $AGENT_COMMANDS_SRC"
    ACTIONS+=("WARNING: Agent commands directory missing")
fi

########################################
# Step 7: Set git identity
########################################
step "7/10 — Git identity"

CURRENT_NAME=$(git config --global user.name 2>/dev/null || echo "")
CURRENT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [ "$CURRENT_NAME" = "Dr. Eddie Davenport" ] && [ "$CURRENT_EMAIL" = "DrD@mach1cardiology.com" ]; then
    success "Git identity already set correctly"
else
    git config --global user.name "Dr. Eddie Davenport"
    git config --global user.email "DrD@mach1cardiology.com"
    success "Set git identity: Dr. Eddie Davenport <DrD@mach1cardiology.com>"
fi
ACTIONS+=("Git identity: Dr. Eddie Davenport <DrD@mach1cardiology.com>")

########################################
# Step 8: Disable sleep
########################################
step "8/10 — Disable sleep (requires sudo)"

info "Running: sudo pmset -a sleep 0 disksleep 0 displaysleep 0"
if sudo pmset -a sleep 0 disksleep 0 displaysleep 0 2>&1; then
    success "Sleep disabled (system, disk, and display)"
    ACTIONS+=("Disabled sleep, disksleep, displaysleep")
else
    warn "Could not set power management — may need admin privileges"
    ACTIONS+=("WARNING: Could not disable sleep")
fi

########################################
# Step 9: SSH key pair
########################################
step "9/10 — SSH key pair"

SSH_KEY="$HOME/.ssh/id_ed25519"

if [ -f "$SSH_KEY" ]; then
    success "SSH key already exists at $SSH_KEY"
    ACTIONS+=("SSH key already existed")
else
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"
    ssh-keygen -t ed25519 -C "edave@mach1-studio" -f "$SSH_KEY" -N ""
    success "Generated new SSH key pair"
    ACTIONS+=("Generated new SSH key pair (ed25519)")
fi

########################################
# Step 10: Print public key
########################################
step "10/10 — SSH public key"

SSH_PUB="$SSH_KEY.pub"

if [ -f "$SSH_PUB" ]; then
    echo ""
    echo -e "${BOLD}${YELLOW}┌─────────────────────────────────────────────────────┐${NC}"
    echo -e "${BOLD}${YELLOW}│  SSH PUBLIC KEY — add this to GitHub / authorized_keys  │${NC}"
    echo -e "${BOLD}${YELLOW}└─────────────────────────────────────────────────────┘${NC}"
    echo ""
    cat "$SSH_PUB"
    echo ""
    ACTIONS+=("Displayed SSH public key")
else
    warn "No public key found at $SSH_PUB"
fi

########################################
# Summary
########################################
echo ""
echo -e "${BOLD}${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BOLD}${GREEN}║                   BOOTSTRAP COMPLETE                    ║${NC}"
echo -e "${BOLD}${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BOLD}Actions performed:${NC}"
for action in "${ACTIONS[@]}"; do
    if [[ "$action" == WARNING* ]]; then
        echo -e "  ${YELLOW}⚠  $action${NC}"
    else
        echo -e "  ${GREEN}✓  $action${NC}"
    fi
done

echo ""
echo -e "${BOLD}Directory layout:${NC}"
echo "  ~/Claude/agents/           — Agent orchestration framework"
echo "  ~/Projects/mach-i-website/ — MACH-I website repo"
echo "  ~/.claude/commands/        — Claude slash commands"
echo "  ~/.ssh/id_ed25519          — SSH key pair"

echo ""
echo -e "${BOLD}Next steps:${NC}"
echo "  1. If gh was not authenticated, run: gh auth login"
echo "  2. Add the SSH public key above to GitHub and Scott's authorized_keys"
echo "  3. Start Claude Code in ~/Projects/mach-i-website"
echo ""
