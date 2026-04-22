#!/usr/bin/env bash
#
# install-v2.sh — Setup script for the v2 config structure.
#
# Reads ~/.bc-hostname, validates the machine config exists,
# and creates symlinks. The symlinks ARE the machine selection —
# no runtime hostname detection needed after this.
#
# Usage:
#   bash install-v2.sh              # interactive
#   bash install-v2.sh --hostname CandyKingdom  # non-interactive
#

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILECONFIGDIR="$HOME/.profileconfig"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo "=========================================="
echo "  blakecode-linux-configs v2 installer"
echo "=========================================="
echo

#############################################
### Step 1: Determine hostname
#############################################

# Check for --hostname flag
HOSTNAME_ARG=""
while [[ $# -gt 0 ]]; do
    case "$1" in
        --hostname) HOSTNAME_ARG="$2"; shift 2 ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

if [[ -n "$HOSTNAME_ARG" ]]; then
    TARGET_HOSTNAME="$HOSTNAME_ARG"
elif [[ -f "$HOME/.bc-hostname" ]]; then
    TARGET_HOSTNAME=$(cat "$HOME/.bc-hostname" | tr -d '\n\r')
    echo "Found existing hostname: $TARGET_HOSTNAME"
    read -p "Keep this hostname? (Y/n): " keep
    if [[ "$keep" =~ ^[Nn] ]]; then
        TARGET_HOSTNAME=""
    fi
fi

if [[ -z "$TARGET_HOSTNAME" ]]; then
    echo ""
    echo "Available machines:"
    for dir in "$REPO_DIR"/shell/machines/*/; do
        [[ -d "$dir" ]] && echo "  $(basename "$dir")"
    done
    echo ""
    read -p "Enter hostname for this machine: " TARGET_HOSTNAME
fi

if [[ -z "$TARGET_HOSTNAME" ]]; then
    echo "Error: Hostname cannot be empty."
    exit 1
fi

# Save hostname
echo "$TARGET_HOSTNAME" > "$HOME/.bc-hostname"

#############################################
### Step 2: Validate machine config exists
#############################################

SHELL_MACHINE_DIR="$REPO_DIR/shell/machines/$TARGET_HOSTNAME"
SCREEN_MACHINE_FILE="$REPO_DIR/screen/machines/$TARGET_HOSTNAME.screenrc"

if [[ ! -d "$SHELL_MACHINE_DIR" ]]; then
    echo ""
    echo "No shell config found for '$TARGET_HOSTNAME'."
    read -p "Create skeleton machine config? (Y/n): " create_it
    if [[ "$create_it" =~ ^[Nn] ]]; then
        echo "Aborting."
        exit 1
    fi

    mkdir -p "$SHELL_MACHINE_DIR"

    # Skeleton zshenv
    cat > "$SHELL_MACHINE_DIR/zshenv" << ZSHENV
# ${TARGET_HOSTNAME}/zshenv
#
# Runs for EVERY zsh invocation. Environment variables only, no output.
#

export HOSTNAME="${TARGET_HOSTNAME}"

source "\$HOME/.profileconfig/shell/core/env.zsh"

###########################
### MACHINE ENV VARS
###########################

# Add machine-specific environment variables here.
ZSHENV

    # Skeleton zprofile
    cat > "$SHELL_MACHINE_DIR/zprofile" << 'ZPROFILE'
# MACHINE_NAME/zprofile
#
# Login shells only. One-time-per-session setup.
#

source "$HOME/.profileconfig/shell/core/login.zsh"

# Add login-only setup here (e.g., Homebrew module).
ZPROFILE

    # Skeleton zshrc
    cat > "$SHELL_MACHINE_DIR/zshrc" << 'ZSHRC'
# MACHINE_NAME/zshrc
#
# Interactive shells only. Prompt, aliases, functions, integrations.
#

source "$HOME/.profileconfig/shell/core/interactive.zsh"
source "$HOME/.profileconfig/shell/core/aliases.zsh"

###########################
### MODULES
###########################

# Source modules as needed:
# source "$HOME/.profileconfig/shell/modules/brazil.zsh"
# source "$HOME/.profileconfig/shell/modules/aws-federate.zsh"

###########################
### MACHINE ALIASES
###########################

# Add machine-specific aliases here.

###########################
### COMPLETIONS (load last)
###########################

source "$HOME/.profileconfig/shell/core/completions.zsh"
ZSHRC

    echo "Created skeleton config in: $SHELL_MACHINE_DIR"
fi

if [[ ! -f "$SCREEN_MACHINE_FILE" ]]; then
    cat > "$SCREEN_MACHINE_FILE" << SCREENRC
# screen/machines/$TARGET_HOSTNAME.screenrc
#
# Screen config for $TARGET_HOSTNAME.
# ~/.screenrc symlinks here.
#

source \$HOME/.profileconfig/screen/core.screenrc
source \$HOME/.profileconfig/screen/colors/green.screenrc

###########################
### WINDOW LAYOUT
###########################

screen -t 0

chdir \$HOME
screen -t General 1

select 1
SCREENRC

    echo "Created skeleton screenrc: $SCREEN_MACHINE_FILE"
fi

#############################################
### Step 3: Detect shell type for this machine
#############################################

# Auto-detect: if machine dir has bashrc, it's a bash machine
if [[ -f "$SHELL_MACHINE_DIR/bashrc" ]]; then
    MACHINE_SHELL="bash"
elif [[ -f "$SHELL_MACHINE_DIR/zshrc" ]]; then
    MACHINE_SHELL="zsh"
else
    MACHINE_SHELL="zsh"  # default for new skeletons
fi

echo "Detected shell: $MACHINE_SHELL"

#############################################
### Step 4: Backup existing configs
#############################################

if [[ "$MACHINE_SHELL" == "zsh" ]]; then
    FILES_TO_LINK=("zshenv" "zprofile" "zshrc" "screenrc")
else
    FILES_TO_LINK=("bash_profile" "bashrc" "screenrc")
fi
NEEDS_BACKUP=false

for file in "${FILES_TO_LINK[@]}"; do
    target="$HOME/.$file"
    if [[ -f "$target" ]] && [[ ! -h "$target" ]]; then
        NEEDS_BACKUP=true
        break
    fi
done

if [[ "$NEEDS_BACKUP" == "true" ]]; then
    mkdir -p "$BACKUP_DIR"
    echo ""
    echo "Backing up existing configs to: $BACKUP_DIR"
    for file in "${FILES_TO_LINK[@]}"; do
        target="$HOME/.$file"
        if [[ -f "$target" ]] && [[ ! -h "$target" ]]; then
            cp "$target" "$BACKUP_DIR/$file"
            echo "  Backed up: .$file"
        fi
    done
fi

#############################################
### Step 4: Create symlinks
#############################################

echo ""
echo "Creating symlinks..."

make_symlink() {
    local source="$1"
    local target="$2"

    if [[ -h "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
        echo "  ✓ $target (already correct)"
    else
        rm -f "$target"
        ln -s "$source" "$target"
        echo "  ✓ $target → $source"
    fi
}

# Repo → ~/.profileconfig
make_symlink "$REPO_DIR" "$PROFILECONFIGDIR"

# Shell configs → machine-specific files
if [[ "$MACHINE_SHELL" == "zsh" ]]; then
    make_symlink "$PROFILECONFIGDIR/shell/machines/$TARGET_HOSTNAME/zshenv" "$HOME/.zshenv"
    make_symlink "$PROFILECONFIGDIR/shell/machines/$TARGET_HOSTNAME/zprofile" "$HOME/.zprofile"
    make_symlink "$PROFILECONFIGDIR/shell/machines/$TARGET_HOSTNAME/zshrc" "$HOME/.zshrc"
else
    make_symlink "$PROFILECONFIGDIR/shell/machines/$TARGET_HOSTNAME/bash_profile" "$HOME/.bash_profile"
    make_symlink "$PROFILECONFIGDIR/shell/machines/$TARGET_HOSTNAME/bashrc" "$HOME/.bashrc"
fi

# Screen config → machine-specific file
make_symlink "$PROFILECONFIGDIR/screen/machines/$TARGET_HOSTNAME.screenrc" "$HOME/.screenrc"

#############################################
### Step 5: Summary
#############################################

echo ""
echo "=========================================="
echo "  Installation complete"
echo "=========================================="
echo ""
echo "  Hostname:  $TARGET_HOSTNAME"
echo "  Shell:     $MACHINE_SHELL (shell/machines/$TARGET_HOSTNAME/)"
echo "  Screen:    screen/machines/$TARGET_HOSTNAME.screenrc"
echo ""
echo "  Symlinks:"
if [[ "$MACHINE_SHELL" == "zsh" ]]; then
    echo "    ~/.zshenv    → shell/machines/$TARGET_HOSTNAME/zshenv"
    echo "    ~/.zprofile  → shell/machines/$TARGET_HOSTNAME/zprofile"
    echo "    ~/.zshrc     → shell/machines/$TARGET_HOSTNAME/zshrc"
else
    echo "    ~/.bash_profile → shell/machines/$TARGET_HOSTNAME/bash_profile"
    echo "    ~/.bashrc       → shell/machines/$TARGET_HOSTNAME/bashrc"
fi
echo "    ~/.screenrc  → screen/machines/$TARGET_HOSTNAME.screenrc"
echo ""
if [[ "$MACHINE_SHELL" == "zsh" ]]; then
    echo "  Restart your shell or run: exec zsh"
else
    echo "  Restart your shell or run: exec bash"
fi
echo ""
