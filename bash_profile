# bash_profile
#
# Runs for LOGIN shells only
# On macOS, terminal opens login shells, so this sources bashrc
# On Linux, login shells don't automatically source bashrc
#

echo "Running ~/bash_profile"

##############################################################################

# Source bashrc for interactive login shells
if [[ -f "$HOME/.bashrc" ]]; then
	source "$HOME/.bashrc"
fi

# Load machine-specific login configuration
if declare -f source_machine_version >/dev/null 2>&1; then
	source_machine_version bash_profile
fi
