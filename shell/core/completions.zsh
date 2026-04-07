# shell/core/completions.zsh
#
# Completion system setup — sourced by each machine's zshrc.
# Loaded last so all fpath additions from modules are in place.
#

# Docker Desktop CLI completions
if [[ -d "$HOME/.docker/completions" ]]; then
    fpath=($HOME/.docker/completions $fpath)
fi

# bun completions
if [[ -s "$HOME/.bun/_bun" ]]; then
    source "$HOME/.bun/_bun"
fi

# Initialize completion system
# -C skips security check and uses cached dump for faster startup
autoload -Uz compinit
compinit -C
