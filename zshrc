
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# zshrc
#
# Runs for INTERACTIVE shells only (after zshenv/zprofile)
# Aliases, functions, prompts, keybindings, completion, history
#
# Difference between all of these files:
# https://unix.stackexchange.com/questions/71253/what-should-shouldnt-go-in-zshenv-zshrc-zlogin-zprofile-zlogout

echo "Running ~/zshrc"

##############################################################################

# Enable variables in the prompt
setopt prompt_subst

#
# Set up the zsh HISTFILE
# Screen windows get separate history, everything else shares one file
#
if [[ -n "$WINDOW" ]]; then
    export HISTFILE="$HOME/.zsh_history.window.$WINDOW"
else
    export HISTFILE="$HOME/.zsh_history"
fi

#~ SMALL_PWD=`if [[ \`pwd|wc -c|tr -d " "\` > 25 ]]; then echo "/.../\\W"; else echo "\\w"; fi`;
#~ SMALL_PWD=`if [[ \`pwd|wc -c\` > 25 ]]; then echo "/.../\\W"; else echo "\\w"; fi`;
#~ SMALL_PWD='\w';

# set prompt: ``username@hostname:/directory $ ''
#PS1="[\e[1;36m\u\e[m\]@\e[0;33m\h\e[m\]:\e[0;37m\w\e[m\]] "
#~ PS1="[\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`\!\[\033[0m\]][\[\033[1;36m\]\u\[\033[0m\]@\[\033[0;33m\]\h\[\033[0m\]:\[\033[0;37m\]\`***if [[ `pwd|wc -c|tr -d " "` > 25 ]]; then echo "/.../\\W"; else echo "\\w"; fi***\`\[\033[0m\]]\[\033]2;\h @ \w\a"
#~ PS1="[\`if [[ \$? = "0" ]]; then echo "\\[\\033[32m\\]"; else echo "\\[\\033[31m\\]"; fi\`\!\[\033[0m\]][\[\033[1;36m\]\u\[\033[0m\]@\[\033[0;33m\]\h\[\033[0m\]:\[\033[0;37m\]${SMALL_PWD}\[\033[0m\]]\[\033]2;\h  ${SMALL_PWD}\a"
#~ case `id -u` in
	#~ 0) PS1="${PS1}# ";;
	#~ *) PS1="${PS1}$ ";;
#~ esac


# Custom prompt:
#    JungleFort: ~/Source $
PS1='%F{green}${HOSTNAME}%f: %F{cyan}%25<…<%~/%f %F{yellow}%(!.#.$)%f '

export CLICOLOR=1
export LSCOLORS='dahebxBxDxehxxbxexGxac'

# For GNU ls (installed via brew -> coreutil)
# http://unix.stackexchange.com/questions/239078/os-x-can-ls-show-broken-symlinks
# http://www.gnu.org/software/coreutils/coreutils.html
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

# Make command completion (TAB key) cycle through all possible choices
# (The default is to simply display a list of all choices when more than one
# match is available.)

# bind '"\t":menu-complete'
# bindkey "^I" complete-word-fwd
# history search up/down-arrow behavior. Start typing a word, then use arrow keys to search for
# similar historical commands.
# https://unix.stackexchange.com/questions/76566/where-do-i-find-a-list-of-terminal-key-codes-to-remap-shortcuts-in-zsh
# if $PLAT_MAC ; then
	# Mac specific(?) binds -nope, works on deb
# bind '"\033[A":history-search-backward'
# bind '"\033[B":history-search-forward'
# fi


###########################
### ALIASES and COMMANDS
###########################

# Load shared aliases
if [[ -f "$PROFILECONFIGDIR/scripts/shell_aliases.sh" ]]; then
	source "$PROFILECONFIGDIR/scripts/shell_aliases.sh"
fi

# Load machine-specific zshrc
source_machine_version zshrc

###########################
### TOOL INTEGRATIONS
###########################

# bun completions
# BUN - should check if paths exist before adding
if [[ -s "$HOME/.bun/_bun" ]]; then
    source "$HOME/.bun/_bun"
fi

# Local bin environment
if [[ -f "$HOME/.local/bin/env" ]]; then
    . "$HOME/.local/bin/env"
fi

# Kiro terminal integration
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
export PATH="$HOME/.local/bin:$PATH"


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"
