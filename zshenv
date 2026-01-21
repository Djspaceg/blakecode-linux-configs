# zshenv
#
# Runs for EVERY zsh invocation (interactive, non-interactive, scripts)
# ONLY environment variables here - no output, no interactive features
#

##############################################################################

##########################
### SYSTEM CONFIGURATION
##########################

PLAT_NIX=true
PLAT_LINUX=false
PLAT_MAC=false

case "${OSTYPE:-$(uname -s)}" in
  darwin*|Darwin)  PLAT_MAC=true ;;
  solaris*|SunOS)  PLAT_NIX=true ;;
  linux*|Linux)    PLAT_NIX=true && PLAT_LINUX=true ;;
  *bsd*|*BSD)      PLAT_NIX=true && PLAT_LINUX=true ;;
esac

export PLAT_NIX PLAT_LINUX PLAT_MAC

# Configure global variables for machine-specific configs
export PROFILECONFIGDIR="$HOME/.profileconfig"
source "$PROFILECONFIGDIR/scripts/prepare-rc-files.zsh"

# Load machine-specific environment variables
source_machine_version zshenv

## Tool paths (conditional additions)

# BUN - should check if paths exist before adding
if [[ -d "$HOME/.bun/bin" ]]; then
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
fi

# Java - should check if java_home exists
if command -v /usr/libexec/java_home >/dev/null 2>&1; then
    export JAVA_HOME=$(/usr/libexec/java_home -v 21 2>/dev/null || /usr/libexec/java_home 2>/dev/null)
fi

# Added by smithy-mcp
# Smithy - check before adding to path
if [[ -d "$HOME/.config/smithy-mcp/mcp-servers" ]]; then
    export PATH="$HOME/.config/smithy-mcp/mcp-servers:$PATH"
fi
