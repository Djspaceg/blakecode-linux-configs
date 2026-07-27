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

# Kiro runs its agent commands through interactive shells that inherit this
# config. Those commands are machine-generated, huge, and useless for recall.
# No env marker separates an agent shell from a terminal opened by hand inside
# Kiro, so ALL Kiro shells write to their own history file and the real ones
# are left alone. This is unconditional and does not depend on how the agent
# formats or prefixes what it runs.
if [[ -n "$WINDOW" ]]; then
    # Screen windows get separate history
    export HISTFILE="$HOME/.zsh_history.window.$WINDOW"
elif [[ "$TERM_PROGRAM" == "kiro" ]]; then
    export HISTFILE="$HOME/.zsh_history.kiro"
else
    export HISTFILE="$HOME/.zsh_history"
fi

# macOS /etc/zshrc ships HISTSIZE=2000 / SAVEHIST=1000. zsh with no append
# option rewrites HISTFILE wholesale from memory when a shell exits, so one
# long-lived shell can shrink the file to its own last 1000 commands. Kiro's
# agent shell is exactly that: one persistent zsh that runs hundreds of huge
# generated commands against this same history file.
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY        # add to HISTFILE instead of replacing it on exit
setopt INC_APPEND_HISTORY    # write each command when run, not at shell exit
setopt EXTENDED_HISTORY      # store timestamp and duration per entry
setopt HIST_IGNORE_SPACE     # a leading space keeps a command out of history
setopt HIST_IGNORE_DUPS      # drop an entry identical to the previous one
setopt HIST_REDUCE_BLANKS    # normalize whitespace before storing
setopt HIST_NO_STORE         # don't store history/fc invocations themselves

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
