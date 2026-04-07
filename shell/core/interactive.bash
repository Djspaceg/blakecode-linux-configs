# shell/core/interactive.bash
#
# Shared interactive bash setup — sourced by each bash machine's bashrc.
# Prompt, history, colors, keybindings.
#

# Source global definitions
if [[ -f /etc/bashrc ]]; then
    source /etc/bashrc
fi

###########################
### HISTORY
###########################

# Screen windows get separate history
if [[ -n "$WINDOW" ]]; then
    export HISTFILE="$HOME/.bash_history.window.$WINDOW"
else
    export HISTFILE="$HOME/.bash_history"
fi

###########################
### PROMPT
###########################

bash_prompt_command() {
    local pwdmaxlen=25
    local trunc_symbol=".."
    local dir=${PWD##*/}
    pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
    NEW_PWD=${PWD/#$HOME/\~}
    local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
    if [[ ${pwdoffset} -gt "0" ]]; then
        NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
        NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
    fi

    ELAPSED_S="$(($SECONDS % 60))s"
    ELAPSED_M=""
    ELAPSED_H=""
    if [[ $((( SECONDS / 60 ) % 60)) -gt 0 ]]; then
        ELAPSED_M="$((($SECONDS / 60) % 60))m "
    fi
    if [[ $(( SECONDS / 3600 )) -gt 0 ]]; then
        ELAPSED_H="$(($SECONDS / 3600))h "
    fi
}

function before_command() {
    case "$BASH_COMMAND" in
        $PROMPT_COMMAND) ;;
        *) SECONDS=0 ;;
    esac
}

bash_prompt() {
    case $TERM in
        xterm*|rxvt*)
            local TITLEBAR='\[\033]0;\h @ ${NEW_PWD}\007\]'
            ;;
        *)
            local TITLEBAR=""
            ;;
    esac

    local NONE="\[\033[0m\]"
    local R="\[\033[0;31m\]"
    local G="\[\033[0;32m\]"
    local Y="\[\033[0;33m\]"
    local C="\[\033[0;36m\]"
    local W="\[\033[0;37m\]"
    local UC=$C
    [[ $UID -eq "0" ]] && UC=$R

    local PROMPT_STATUS="${R}\!${NONE}"
    [[ $? -eq "0" ]] && PROMPT_STATUS="${G}\!${NONE}"

    PS1="$TITLEBAR[$PROMPT_STATUS][${G}ELAPSED:${NONE} $R\${ELAPSED_H}$NONE$Y\${ELAPSED_M}$NONE$G\${ELAPSED_S}$NONE][${UC}\u${NONE}@${Y}\h:${W}\${NEW_PWD}${NONE}]${UC}\\$ ${NONE}"
}

trap before_command DEBUG
PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

###########################
### COLORS
###########################

export CLICOLOR=1
export LSCOLORS='dahebxBxDxehxxbxexGxac'

###########################
### KEYBINDINGS
###########################

bind '"\t":menu-complete'
bind '"\033[A":history-search-backward'
bind '"\033[B":history-search-forward'
