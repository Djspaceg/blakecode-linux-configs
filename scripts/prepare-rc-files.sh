#!/bin/bash
# prepare-rc-files.sh - Bash-compatible version
#
# Sets up environment variables for machine-specific configs
# Used by bash_env (bash doesn't support autoload)

export PROFILECONFIGDIR=${PROFILECONFIGDIR:-"$HOME/.profileconfig"}

# Set HOSTNAME from .bc-hostname or fallback
if [[ -s "$HOME/.bc-hostname" ]]; then
    export HOSTNAME=$(cat "$HOME/.bc-hostname" | tr -d '\n\r')
else
    export HOSTNAME=$(hostname 2>/dev/null || echo "unknown")
fi

export MACHINECONFIGDIR=${MACHINECONFIGDIR:-"$PROFILECONFIGDIR/machine-configs/$HOSTNAME"}

# Define source_machine_version for bash
source_machine_version() {
    local file=${1:-"$(basename -- $0)"}
    if [[ -z "$MACHINECONFIGDIR" ]]; then
        return 1
    fi
    [[ -f "$MACHINECONFIGDIR/$file" ]] && source "$MACHINECONFIGDIR/$file"
}
