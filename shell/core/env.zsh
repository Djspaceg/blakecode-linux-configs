# shell/core/env.zsh
#
# Shared environment setup — sourced by every machine's zshenv.
# Runs for EVERY zsh invocation (interactive, non-interactive, scripts).
# NO output allowed here.
#

# HOSTNAME must be set by the machine's zshenv before sourcing this file.
# Machine zshenv derives it from its own file path:
#   export HOSTNAME="${${(%):-%x}:h:t}"

# Repo root
export PROFILECONFIGDIR="${PROFILECONFIGDIR:-$HOME/.profileconfig}"

# Platform detection
PLAT_NIX=true
PLAT_LINUX=false
PLAT_MAC=false

case "${OSTYPE:-$(uname -s)}" in
    darwin*|Darwin)  PLAT_MAC=true ;;
    solaris*|SunOS)  PLAT_NIX=true ;;
    linux*|Linux)    PLAT_NIX=true; PLAT_LINUX=true ;;
    *bsd*|*BSD)      PLAT_NIX=true; PLAT_LINUX=true ;;
esac

export PLAT_NIX PLAT_LINUX PLAT_MAC
