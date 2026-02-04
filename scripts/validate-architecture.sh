#!/usr/bin/env bash
#
# Validates that the repository follows the architecture patterns
# Run this to check for common issues
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

error() {
    echo -e "${RED}ERROR:${NC} $1"
    ((ERRORS++))
}

warn() {
    echo -e "${YELLOW}WARN:${NC} $1"
    ((WARNINGS++))
}

ok() {
    echo -e "${GREEN}OK:${NC} $1"
}

echo "Validating architecture in: $REPO_DIR"
echo "=========================================="
echo

# Check 1: Global files should call source_machine_version
echo "Checking global shell files source machine versions..."
for file in zshenv zprofile zshrc bash_env bash_profile bashrc; do
    if [[ -f "$REPO_DIR/$file" ]]; then
        if grep -q "source_machine_version" "$REPO_DIR/$file"; then
            ok "$file calls source_machine_version"
        else
            error "$file does not call source_machine_version"
        fi
    fi
done
echo

# Check 2: Global screenrc should source machine screenrc
echo "Checking screenrc sources machine version..."
if grep -q 'source.*MACHINECONFIGDIR.*screenrc' "$REPO_DIR/screenrc"; then
    ok "screenrc sources machine-specific screenrc"
else
    error "screenrc does not source \${MACHINECONFIGDIR}/screenrc"
fi
echo

# Check 3: Machine screenrc files should use full paths for screenrc-tabs
echo "Checking machine screenrc files use full paths..."
for dir in "$REPO_DIR"/machine-configs/*/; do
    hostname=$(basename "$dir")
    screenrc="$dir/screenrc"
    if [[ -f "$screenrc" ]]; then
        if grep -q 'source screenrc-tabs' "$screenrc"; then
            error "$hostname/screenrc uses relative path for screenrc-tabs"
        elif grep -q 'source.*MACHINECONFIGDIR.*screenrc-tabs' "$screenrc"; then
            ok "$hostname/screenrc uses full path for screenrc-tabs"
        else
            # No screenrc-tabs reference - that's fine if they don't need it
            ok "$hostname/screenrc (no screenrc-tabs reference)"
        fi
    fi
done
echo

# Check 4: Check for hardcoded paths
echo "Checking for hardcoded paths..."
HARDCODED=$(grep -r "blakecode-linux-configs" "$REPO_DIR" --include="*.sh" --include="screenrc*" --include="*rc" 2>/dev/null | grep -v ".git" | grep -v "validate-architecture")
if [[ -n "$HARDCODED" ]]; then
    warn "Found hardcoded 'blakecode-linux-configs' paths:"
    echo "$HARDCODED" | head -5
else
    ok "No hardcoded repository paths found"
fi
echo

# Check 5: Verify prepare-rc-files exists for both shells
echo "Checking bootstrap scripts exist..."
if [[ -f "$REPO_DIR/scripts/prepare-rc-files.zsh" ]]; then
    ok "prepare-rc-files.zsh exists"
else
    error "prepare-rc-files.zsh missing"
fi
if [[ -f "$REPO_DIR/scripts/prepare-rc-files.sh" ]]; then
    ok "prepare-rc-files.sh exists (for bash)"
else
    error "prepare-rc-files.sh missing (bash won't work)"
fi
echo

# Check 6: Verify bash_env uses bash version, not zsh
echo "Checking bash_env uses correct bootstrap..."
if grep -q "prepare-rc-files.zsh" "$REPO_DIR/bash_env"; then
    error "bash_env sources zsh version (should use .sh)"
elif grep -q "prepare-rc-files.sh" "$REPO_DIR/bash_env"; then
    ok "bash_env sources bash-compatible version"
fi
echo

# Summary
echo "=========================================="
echo "Validation complete"
echo -e "Errors: ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

if [[ $ERRORS -gt 0 ]]; then
    exit 1
fi
exit 0
