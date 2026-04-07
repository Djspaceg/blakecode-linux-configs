# shell/modules/homebrew-intel.zsh
#
# Homebrew environment for Intel Macs (/usr/local).
# Hardcoded paths to avoid slow `eval "$(brew shellenv)"` subprocess.
# Source this from a machine's zprofile (login shell only).
#

export HOMEBREW_PREFIX="/usr/local"
export HOMEBREW_CELLAR="/usr/local/Cellar"
export HOMEBREW_REPOSITORY="/usr/local/Homebrew"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"
export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/usr/local/share/info:${INFOPATH:-}"
