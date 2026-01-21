#!/usr/bin/env bash
#
# Installation script for blakecode-linux-configs
# Sets up shell configuration with proper hostname and backup handling
#

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILECONFIGDIR="${PROFILECONFIGDIR:-$HOME/.profileconfig}"
BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo "=========================================="
echo "blakecode-linux-configs Installation"
echo "=========================================="
echo

# Detect current shell
CURRENT_SHELL=$(basename "$SHELL")
echo "Detected shell: $CURRENT_SHELL"
echo

# Step 1: Get hostname
echo "Step 1: Configure hostname"
echo "--------------------------"
if [[ -f "$HOME/.bc-hostname" ]]; then
    CURRENT_HOSTNAME=$(cat "$HOME/.bc-hostname")
    echo "Current hostname: $CURRENT_HOSTNAME"
    read -p "Keep this hostname? (Y/n): " keep_hostname
    if [[ "$keep_hostname" =~ ^[Nn] ]]; then
        read -p "Enter new hostname for this machine: " NEW_HOSTNAME
        echo "$NEW_HOSTNAME" > "$HOME/.bc-hostname"
        echo "Hostname set to: $NEW_HOSTNAME"
    fi
else
    echo "No hostname configured yet."
    read -p "Enter a hostname for this machine (e.g., CandyKingdom, JungleFort): " NEW_HOSTNAME
    if [[ -z "$NEW_HOSTNAME" ]]; then
        echo "Error: Hostname cannot be empty"
        exit 1
    fi
    echo "$NEW_HOSTNAME" > "$HOME/.bc-hostname"
    echo "Hostname set to: $NEW_HOSTNAME"
fi

HOSTNAME=$(cat "$HOME/.bc-hostname")
MACHINECONFIGDIR="$REPO_DIR/machine-configs/$HOSTNAME"

echo

# Step 2: Create machine config directory
echo "Step 2: Create machine-specific config directory"
echo "------------------------------------------------"
if [[ ! -d "$MACHINECONFIGDIR" ]]; then
    mkdir -p "$MACHINECONFIGDIR"
    echo "Created: $MACHINECONFIGDIR"
else
    echo "Already exists: $MACHINECONFIGDIR"
fi

echo

# Step 3: Backup and merge existing configs
echo "Step 3: Handle existing configuration files"
echo "-------------------------------------------"

# Determine which files to link based on shell
if [[ "$CURRENT_SHELL" == "zsh" ]]; then
    FILES_TO_LINK=(
        "zshenv"
        "zprofile"
        "zshrc"
        "screenrc"
        "Xresources"
    )
    echo "Installing zsh configuration files only."
elif [[ "$CURRENT_SHELL" == "bash" ]]; then
    FILES_TO_LINK=(
        "bash_env"
        "bash_profile"
        "bashrc"
        "screenrc"
        "Xresources"
    )
    echo "Installing bash configuration files only."
else
    echo "Unknown shell: $CURRENT_SHELL"
    read -p "Install both bash and zsh configs? (Y/n): " install_both
    if [[ "$install_both" =~ ^[Nn] ]]; then
        echo "Installation cancelled."
        exit 1
    fi
    FILES_TO_LINK=(
        "bash_env"
        "bash_profile"
        "bashrc"
        "zshenv"
        "zprofile"
        "zshrc"
        "screenrc"
        "Xresources"
    )
    echo "Installing both bash and zsh configuration files."
fi
echo

NEEDS_BACKUP=false
for file in "${FILES_TO_LINK[@]}"; do
    target="$HOME/.$file"
    if [[ -f "$target" ]] && [[ ! -h "$target" ]]; then
        NEEDS_BACKUP=true
        break
    fi
done

if [[ "$NEEDS_BACKUP" == "true" ]]; then
    echo "Found existing configuration files."
    read -p "Backup and merge existing configs? 'n' skips existing files (Y/n): " do_backup
    
    if [[ ! "$do_backup" =~ ^[Nn] ]]; then
        mkdir -p "$BACKUP_DIR"
        echo "Backing up to: $BACKUP_DIR"
        
        for file in "${FILES_TO_LINK[@]}"; do
            target="$HOME/.$file"
            machine_file="$MACHINECONFIGDIR/$file"
            
            if [[ -f "$target" ]] && [[ ! -h "$target" ]]; then
                # Backup original
                cp "$target" "$BACKUP_DIR/$file"
                echo "  Backed up: .$file"
                
                # If machine-specific file doesn't exist, move content there
                if [[ ! -f "$machine_file" ]]; then
                    cp "$target" "$machine_file"
                    echo "  Migrated to: machine-configs/$HOSTNAME/$file"
                else
                    echo "  Note: machine-configs/$HOSTNAME/$file already exists, check manually"
                fi
            fi
        done
        echo
    fi
else
    echo "No existing config files to backup."
    echo
fi

# Step 4: Create symlinks
echo "Step 4: Create symlinks"
echo "-----------------------"

make_symlink() {
    local source=$1
    local target=$2
    
    if [[ -h "$target" ]] && [[ "$(readlink "$target")" == "$source" ]]; then
        echo "  ✓ $target (already linked)"
    elif [[ -e "$target" ]]; then
        rm -f "$target"
        ln -s "$source" "$target"
        echo "  ✓ $target (updated)"
    else
        ln -s "$source" "$target"
        echo "  ✓ $target (created)"
    fi
}

# Link repo to ~/.profileconfig
make_symlink "$REPO_DIR" "$PROFILECONFIGDIR"

# Link config files
for file in "${FILES_TO_LINK[@]}"; do
    make_symlink "$PROFILECONFIGDIR/$file" "$HOME/.$file"
done

echo

# Step 5: Summary
echo "=========================================="
echo "Installation Complete!"
echo "=========================================="
echo
echo "Configuration:"
echo "  Hostname: $HOSTNAME"
echo "  Profile dir: $PROFILECONFIGDIR"
echo "  Machine configs: $MACHINECONFIGDIR"
if [[ -d "$BACKUP_DIR" ]]; then
    echo "  Backups: $BACKUP_DIR"
fi
echo
echo "Next steps:"
echo "  1. Restart your shell or run: source ~/.zshrc"
echo "  2. Customize machine-specific configs in: $MACHINECONFIGDIR"
echo "  3. Review backups if any were created"
echo
