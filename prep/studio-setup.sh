#!/bin/bash

################################################################################
# MACH-I Mac Studio Setup Script
# ===============================
#
# Sets up Dr. D's Mac Studio (Apple Silicon) with the basics needed for the
# MACH-I website project. This script is idempotent — safe to run multiple
# times without causing problems.
#
# What it does:
#   1. Installs Homebrew (if not already installed)
#   2. Adds Homebrew to PATH for Apple Silicon
#   3. Installs Node.js via brew
#   4. Installs latest Git via brew
#   5. Creates ~/Projects directory
#   6. Clones the mach-i-website repo from GitHub
#   7. Sets up the auto-push safety net (hourly auto-commit/push)
#
# Target machine:
#   - Apple Silicon Mac Studio
#   - macOS user: eddiedavenport
#   - Home directory: /Users/eddiedavenport
#
# Usage:
#   chmod +x studio-setup.sh
#   ./studio-setup.sh
#
################################################################################

set -e  # Exit on error

# Color codes for readable output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

HOMEBREW_PREFIX="/opt/homebrew"
REPO_URL="https://github.com/txcfi-scott/MACH-I-Website.git"
PROJECTS_DIR="$HOME/Projects"
SCRIPTS_DIR="$HOME/Scripts"

# Get the directory where this script lives (for finding sibling files)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}========================================================${NC}"
echo -e "${BLUE}  MACH-I Mac Studio Setup${NC}"
echo -e "${BLUE}  Target: Apple Silicon Mac Studio${NC}"
echo -e "${BLUE}========================================================${NC}"
echo ""

########################################
# Step 1: Install Homebrew
########################################
echo -e "${BLUE}[Step 1/7] Homebrew${NC}"

if command -v ${HOMEBREW_PREFIX}/bin/brew &>/dev/null; then
    echo -e "${GREEN}  Already installed at ${HOMEBREW_PREFIX}/bin/brew${NC}"
    BREW_VERSION=$(${HOMEBREW_PREFIX}/bin/brew --version | head -1)
    echo -e "${GREEN}  Version: ${BREW_VERSION}${NC}"
else
    echo "  Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo -e "${GREEN}  Homebrew installed successfully${NC}"
fi
echo ""

########################################
# Step 2: Ensure Homebrew is on PATH
########################################
echo -e "${BLUE}[Step 2/7] Homebrew PATH (Apple Silicon)${NC}"

# Make brew available for the rest of this script
eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"

# Add to .zprofile if not already there (persists across sessions)
ZPROFILE="$HOME/.zprofile"
BREW_SHELLENV_LINE='eval "$(/opt/homebrew/bin/brew shellenv)"'

if [ -f "$ZPROFILE" ] && grep -q '/opt/homebrew/bin/brew shellenv' "$ZPROFILE"; then
    echo -e "${GREEN}  Homebrew PATH already configured in ~/.zprofile${NC}"
else
    echo "  Adding Homebrew to PATH in ~/.zprofile..."
    echo '' >> "$ZPROFILE"
    echo '# Homebrew (Apple Silicon)' >> "$ZPROFILE"
    echo "$BREW_SHELLENV_LINE" >> "$ZPROFILE"
    echo -e "${GREEN}  Added Homebrew to ~/.zprofile${NC}"
fi
echo ""

########################################
# Step 3: Install Node.js
########################################
echo -e "${BLUE}[Step 3/7] Node.js${NC}"

if command -v node &>/dev/null; then
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}  Already installed: node ${NODE_VERSION}${NC}"
    echo "  Checking for updates..."
    brew upgrade node 2>/dev/null || echo -e "${GREEN}  Already up to date${NC}"
else
    echo "  Installing Node.js via Homebrew..."
    brew install node
    NODE_VERSION=$(node --version)
    echo -e "${GREEN}  Installed: node ${NODE_VERSION}${NC}"
fi
echo ""

########################################
# Step 4: Install Git (latest)
########################################
echo -e "${BLUE}[Step 4/7] Git${NC}"

if brew list git &>/dev/null; then
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}  Already installed via Homebrew: ${GIT_VERSION}${NC}"
    echo "  Checking for updates..."
    brew upgrade git 2>/dev/null || echo -e "${GREEN}  Already up to date${NC}"
else
    echo "  Installing Git via Homebrew..."
    brew install git
    GIT_VERSION=$(git --version)
    echo -e "${GREEN}  Installed: ${GIT_VERSION}${NC}"
fi
echo ""

########################################
# Step 5: Create ~/Projects directory
########################################
echo -e "${BLUE}[Step 5/7] Projects directory${NC}"

if [ -d "$PROJECTS_DIR" ]; then
    echo -e "${GREEN}  ~/Projects already exists${NC}"
else
    mkdir -p "$PROJECTS_DIR"
    echo -e "${GREEN}  Created ~/Projects${NC}"
fi
echo ""

########################################
# Step 6: Clone mach-i-website repo
########################################
echo -e "${BLUE}[Step 6/7] Clone MACH-I Website repository${NC}"

REPO_DIR="$PROJECTS_DIR/mach-i-website"

if [ -d "$REPO_DIR/.git" ]; then
    echo -e "${GREEN}  Repository already cloned at ${REPO_DIR}${NC}"
    echo "  Pulling latest changes..."
    cd "$REPO_DIR"
    git pull || echo -e "${YELLOW}  Warning: Could not pull (may need auth configured)${NC}"
    cd -
else
    echo "  Cloning from ${REPO_URL}..."
    git clone "$REPO_URL" "$REPO_DIR"
    echo -e "${GREEN}  Cloned to ${REPO_DIR}${NC}"
fi
echo ""

########################################
# Step 7: Set up auto-push safety net
########################################
echo -e "${BLUE}[Step 7/7] Auto-push safety net${NC}"

AUTOPUSH_SCRIPT="$SCRIPTS_DIR/machi-autopush.sh"
PLIST_NAME="com.machi.autopush.plist"
PLIST_DEST="$HOME/Library/LaunchAgents/$PLIST_NAME"
MAC_USER="eddiedavenport"

# Create ~/Scripts directory
if [ -d "$SCRIPTS_DIR" ]; then
    echo -e "${GREEN}  ~/Scripts already exists${NC}"
else
    mkdir -p "$SCRIPTS_DIR"
    echo -e "${GREEN}  Created ~/Scripts${NC}"
fi

# Install the auto-push script
echo "  Installing auto-push script..."
if [ -f "$SCRIPT_DIR/machi-autopush.sh" ]; then
    cp "$SCRIPT_DIR/machi-autopush.sh" "$AUTOPUSH_SCRIPT"
    echo -e "${GREEN}  Copied machi-autopush.sh to ~/Scripts/${NC}"
else
    echo -e "${YELLOW}  Warning: machi-autopush.sh not found in ${SCRIPT_DIR}${NC}"
    echo -e "${YELLOW}  Creating auto-push script inline...${NC}"

    cat > "$AUTOPUSH_SCRIPT" << 'AUTOPUSH_EOF'
#!/bin/bash
# MACH-I Auto-Push Safety Net Script
# Automatically commits and pushes pending changes every hour

export PATH="/usr/local/bin:/opt/homebrew/bin:/usr/bin:/bin:$PATH"

LOG_FILE="$HOME/Library/Logs/machi-autopush.log"

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log_message "========================================="
log_message "Auto-push cycle started"
log_message "========================================="

declare -a REPOS=(
    "$HOME/Projects/mach-i-website"
)

for REPO in "${REPOS[@]}"; do
    if [ ! -d "$REPO" ]; then
        log_message "WARNING: Repository does not exist: $REPO"
        continue
    fi

    cd "$REPO" || {
        log_message "ERROR: Could not cd into $REPO"
        continue
    }

    BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    CHANGES=$(git status --porcelain 2>/dev/null)

    if [ -z "$CHANGES" ]; then
        log_message "No changes in $REPO ($BRANCH) - skipping"
    else
        log_message "Changes detected in $REPO ($BRANCH) - committing..."

        if ! git add -A 2>&1 | while read line; do log_message "  git add: $line"; done; then
            log_message "ERROR: git add failed in $REPO"
            continue
        fi

        COMMIT_MSG="auto-save $(date '+%Y-%m-%d %H:%M')"
        if ! git commit -m "$COMMIT_MSG" 2>&1 | while read line; do log_message "  commit: $line"; done; then
            log_message "ERROR: git commit failed in $REPO"
            continue
        fi

        if ! git push 2>&1 | while read line; do log_message "  push: $line"; done; then
            log_message "ERROR: git push failed in $REPO - changes committed locally but not pushed"
            continue
        fi

        log_message "Successfully pushed changes from $REPO"
    fi
done

log_message "Auto-push cycle completed"
log_message ""
AUTOPUSH_EOF
    echo -e "${GREEN}  Created auto-push script inline${NC}"
fi

chmod +x "$AUTOPUSH_SCRIPT"
echo -e "${GREEN}  Made auto-push script executable${NC}"

# Install the launchd plist (adapted for eddiedavenport user)
echo "  Installing launchd configuration..."
mkdir -p "$HOME/Library/LaunchAgents"

cat > "$PLIST_DEST" << PLIST_EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>Label</key>
	<string>com.machi.autopush</string>

	<key>ProgramArguments</key>
	<array>
		<string>/bin/bash</string>
		<string>/Users/${MAC_USER}/Scripts/machi-autopush.sh</string>
	</array>

	<key>StartInterval</key>
	<integer>3600</integer>

	<key>RunAtLoad</key>
	<true/>

	<key>StandardOutPath</key>
	<string>/Users/${MAC_USER}/Library/Logs/machi-autopush.log</string>

	<key>StandardErrorPath</key>
	<string>/Users/${MAC_USER}/Library/Logs/machi-autopush.log</string>

	<key>KeepAlive</key>
	<true/>

	<key>WorkingDirectory</key>
	<string>/Users/${MAC_USER}</string>

</dict>
</plist>
PLIST_EOF

echo -e "${GREEN}  Installed launchd plist to ~/Library/LaunchAgents/${NC}"

# Load the launchd agent (unload first if already loaded)
echo "  Loading launchd agent..."
if launchctl list 2>/dev/null | grep -q "com.machi.autopush"; then
    echo "  Unloading existing agent first..."
    launchctl unload "$PLIST_DEST" 2>/dev/null || true
fi
launchctl load "$PLIST_DEST"

if launchctl list 2>/dev/null | grep -q "com.machi.autopush"; then
    echo -e "${GREEN}  Auto-push agent loaded and running${NC}"
else
    echo -e "${YELLOW}  Warning: Could not verify agent load${NC}"
fi
echo ""

########################################
# Summary
########################################
echo -e "${BLUE}========================================================${NC}"
echo -e "${GREEN}  Setup Complete!${NC}"
echo -e "${BLUE}========================================================${NC}"
echo ""
echo "  Installed:"
echo "    - Homebrew (package manager)"
echo "    - Node.js ($(node --version 2>/dev/null || echo 'check manually'))"
echo "    - Git ($(git --version 2>/dev/null || echo 'check manually'))"
echo ""
echo "  Directories:"
echo "    - ~/Projects          (project workspace)"
echo "    - ~/Projects/mach-i-website  (website repo)"
echo "    - ~/Scripts           (automation scripts)"
echo ""
echo "  Auto-push safety net:"
echo "    - Runs every hour, commits and pushes any changes"
echo "    - Log: ~/Library/Logs/machi-autopush.log"
echo "    - Test: ~/Scripts/machi-autopush.sh"
echo "    - Status: launchctl list | grep com.machi.autopush"
echo ""
echo -e "${YELLOW}  Next steps:${NC}"
echo "    1. Configure Git identity:"
echo "       git config --global user.name \"Dr. Eddie Davenport\""
echo "       git config --global user.email \"your-email@example.com\""
echo "    2. Set up GitHub authentication (for push access):"
echo "       gh auth login   (if GitHub CLI installed)"
echo "       — or use HTTPS personal access token"
echo ""
