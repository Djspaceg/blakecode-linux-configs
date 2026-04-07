#!/usr/bin/env bash
# Validate screenrc files by scanning for common errors.
# Usage: bash ~/.profileconfig/scripts/screen-debug.sh
#
# Screen doesn't have a --check mode and its config errors only flash
# in the message line. This script does a static analysis of the screenrc
# chain to catch common issues before launching screen.

PROFILECONFIGDIR="${PROFILECONFIGDIR:-$HOME/.profileconfig}"
HOSTNAME_FILE="$HOME/.bc-hostname"

if [[ -f "$HOSTNAME_FILE" ]]; then
    HOSTNAME=$(cat "$HOSTNAME_FILE" | tr -d '\n\r')
else
    HOSTNAME=$(hostname)
fi

MACHINECONFIGDIR="$PROFILECONFIGDIR/machine-configs/$HOSTNAME"

echo "Validating screenrc chain for: $HOSTNAME"
echo "============================================"

ERRORS=0

check_file() {
    local file="$1"
    local linenum=0

    if [[ ! -f "$file" ]]; then
        echo "  WARN: File not found: $file"
        return
    fi

    echo ""
    echo "Checking: $file"

    while IFS= read -r line || [[ -n "$line" ]]; do
        linenum=$((linenum + 1))

        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue

        # Check for shell-style variable assignments (not valid in screenrc)
        if [[ "$line" =~ ^[A-Z_]+= ]]; then
            echo "  ERROR line $linenum: Shell variable assignment (not valid in screenrc): $line"
            ERRORS=$((ERRORS + 1))
        fi

        # Check for $() subshell syntax (not valid in screenrc)
        if [[ "$line" =~ \$\( ]]; then
            echo "  ERROR line $linenum: Shell subshell \$() syntax (not valid in screenrc): $line"
            ERRORS=$((ERRORS + 1))
        fi

        # Check for @REM (Windows comment)
        if [[ "$line" =~ ^@REM ]]; then
            echo "  ERROR line $linenum: Windows-style comment @REM: $line"
            ERRORS=$((ERRORS + 1))
        fi

        # Check for tput calls
        if [[ "$line" =~ tput ]]; then
            echo "  ERROR line $linenum: tput call (not valid in screenrc): $line"
            ERRORS=$((ERRORS + 1))
        fi

    done < "$file"
}

check_file "$PROFILECONFIGDIR/screenrc"
check_file "$MACHINECONFIGDIR/screenrc"
check_file "$MACHINECONFIGDIR/screenrc-tabs"

echo ""
echo "============================================"
if [[ $ERRORS -eq 0 ]]; then
    echo "No errors found."
else
    echo "Found $ERRORS error(s)."
fi
