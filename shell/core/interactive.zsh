# shell/core/interactive.zsh
#
# Shared interactive shell setup — sourced by each machine's zshrc.
# Runs for INTERACTIVE shells only (after zshenv/zprofile).
# Prompt, history, colors, keybindings.
#

# Guard against double-sourcing (terminal integrations can re-source zshrc)
if [[ -n "$_ZSHRC_LOADED" ]]; then
    return 0
fi
_ZSHRC_LOADED=1

###########################
### TERMINAL INTEGRATIONS (load early to prevent re-sourcing)
###########################

if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
fi

if [[ "$TERM_PROGRAM" == "kiro" ]] && (( $+commands[kiro] )); then
    . "$(kiro --locate-shell-integration-path zsh)"
fi

###########################
### SHELL OPTIONS
###########################

setopt prompt_subst

###########################
### HISTORY
###########################

# Screen windows get separate history, everything else shares one file
if [[ -n "$WINDOW" ]]; then
    export HISTFILE="$HOME/.zsh_history.window.$WINDOW"
else
    export HISTFILE="$HOME/.zsh_history"
fi

###########################
### PROMPT
###########################

# Format: CandyKingdom: ~/Source $
PS1='%F{green}${HOSTNAME}%f: %F{cyan}%25<…<%~/%f %F{yellow}%(!.#.$)%f '

###########################
### COLORS
###########################

export CLICOLOR=1
export LSCOLORS='dahebxBxDxehxxbxexGxac'
