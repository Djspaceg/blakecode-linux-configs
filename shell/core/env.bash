# shell/core/env.bash
#
# Shared environment setup for bash machines.
# Sourced by each machine's bash_profile.
# Runs for every shell. NO output allowed here.
#

export PROFILECONFIGDIR="${PROFILECONFIGDIR:-$HOME/.profileconfig}"

# HOSTNAME is set by the machine's bash_profile (can't derive from path in bash)

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
