# shell/modules/homebrew-apple-silicon.zsh
#
# Homebrew environment for Apple Silicon Macs (/opt/homebrew).
# Hardcoded paths to avoid slow `eval "$(brew shellenv)"` subprocess.
# Source this from a machine's zprofile (login shell only).
#

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"
