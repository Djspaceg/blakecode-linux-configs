# bashrc
#
# Commands to configure each time a prompt is started.
#

# echo "Running main bashrc"

##############################################################################

# Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

if [[ -z "$PROFILECONFIGDIR" ]]; then
	# This is present to ensure that the bash_profile is executed on remote login connections like SSH
	# > ssh with a command will NOT start a login shell. Thus bash_profile is not sourced.
	# https://superuser.com/questions/952084/why-is-ssh-not-invoking-bash-profile
	# https://unix.stackexchange.com/questions/332531/why-does-remote-bash-source-bash-profile-instead-of-bashrc
	source "$HOME/.bash_profile"
fi

##########################
### SHELL CONFIGURATION
##########################

##################################################
# Fancy PWD display function
##################################################
# The home directory (HOME) is replaced with a ~
# The last pwdmaxlen characters of the PWD are displayed
# Leading partial directory names are striped off
# /home/me/stuff          -> ~/stuff               if USER=me
# /usr/share/big_dir_name -> ../share/big_dir_name if pwdmaxlen=20
##################################################
bash_prompt_command() {
	local NONE="\[\033[0m\]"    # unsets color to term's fg color

	# regular colors
	local R="\[\033[0;31m\]"    # red
	local G="\[\033[0;32m\]"    # green
	local Y="\[\033[0;33m\]"    # yellow

	#
	### Set the Duration of the last command
	#
	ELAPSED_S="$(($SECONDS % 60))s"
	ELAPSED_M=""
	ELAPSED_H=""
	if [[ $((( SECONDS / 60 ) % 60)) > 0 ]]; then
		ELAPSED_M="$((($SECONDS / 60) % 60))m "
	fi

	if [[ $(( SECONDS / 3600 )) > 0 ]]; then
		ELAPSED_H="$(($SECONDS / 3600))h "
	fi

	# ELAPSED="Elapsed SEC=${SECONDS} pc: ${ELAPSED}"

	# ELAPSED="${G}$(($SECONDS % 60))sec${NONE}"
	# if [[ $((( SECONDS / 60 ) % 60)) > 0 ]]; then
	# 	ELAPSED="${Y}$((($SECONDS / 60) % 60))min${NONE} ${ELAPSED}"
	# fi

	# if [[ $(( SECONDS / 3600 )) > 0 ]]; then
	# 	ELAPSED="${R}$(($SECONDS / 3600))hrs${NONE} ${ELAPSED}"
	# fi

	# ELAPSED="Elapsed SEC=${SECONDS} pc: ${ELAPSED}"

	# ELAPSED="Elapsed: $(($SECONDS / 3600))hrs $((($SECONDS / 60) % 60))min $(($SECONDS % 60))sec"
	# echo "Running bash_prompt_command ${SECONDS} ${ELAPSED}"

	# Reset seconds for the next command.
	# SECONDS=0
	# echo $ELAPSED

	#
	### Set the PWD
	#
	# How many characters of the $PWD should be kept
	local pwdmaxlen=25
	# Indicate that there has been dir truncation
	local trunc_symbol=".."
	local dir=${PWD##*/}
	pwdmaxlen=$(( ( pwdmaxlen < ${#dir} ) ? ${#dir} : pwdmaxlen ))
	NEW_PWD=${PWD/#$HOME/\~}
	local pwdoffset=$(( ${#NEW_PWD} - pwdmaxlen ))
	if [ ${pwdoffset} -gt "0" ]
	then
		NEW_PWD=${NEW_PWD:$pwdoffset:$pwdmaxlen}
		NEW_PWD=${trunc_symbol}/${NEW_PWD#*/}
	fi
}

function before_command() {
	case "$BASH_COMMAND" in
		$PROMPT_COMMAND)
			# echo "PROMPT_COMMAND running"
			;;
		*)
			# echo "resetting SECONDS to 0 from ${SECONDS} for $BASH_COMMAND";
			SECONDS=0;
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
	local NONE="\[\033[0m\]"    # unsets color to term's fg color

	# regular colors
	local K="\[\033[0;30m\]"    # black
	local R="\[\033[0;31m\]"    # red
	local G="\[\033[0;32m\]"    # green
	local Y="\[\033[0;33m\]"    # yellow
	local B="\[\033[0;34m\]"    # blue
	local M="\[\033[0;35m\]"    # magenta
	local C="\[\033[0;36m\]"    # cyan
	local W="\[\033[0;37m\]"    # white

	# emphasized (bolded) colors
	local EMK="\[\033[1;30m\]"
	local EMR="\[\033[1;31m\]"
	local EMG="\[\033[1;32m\]"
	local EMY="\[\033[1;33m\]"
	local EMB="\[\033[1;34m\]"
	local EMM="\[\033[1;35m\]"
	local EMC="\[\033[1;36m\]"
	local EMW="\[\033[1;37m\]"

	# background colors
	local BGK="\[\033[40m\]"
	local BGR="\[\033[41m\]"
	local BGG="\[\033[42m\]"
	local BGY="\[\033[43m\]"
	local BGB="\[\033[44m\]"
	local BGM="\[\033[45m\]"
	local BGC="\[\033[46m\]"
	local BGW="\[\033[47m\]"

	local UC=$C                 # user's color
	[ $UID -eq "0" ] && UC=$R   # root's color

	### Set the prompt color using the status
	#~ local RET=$?
	local PROMPT_STATUS="${R}\!${NONE}"
	[[ $? -eq "0" ]] && PROMPT_STATUS="${G}\!${NONE}"

	#~ if [ $? -eq "0" ]
	#~ then
		#~ PROMPT_STATUS="${B}\!${NONE}"
	#~ fi

	#
	### Set the Duration of the last command
	#
	# ELAPSED="${G}$(($SECONDS % 60))sec${NONE}"
	# if [[ $((( SECONDS / 60 ) % 60)) > 0 ]]; then
	# 	ELAPSED="${Y}$((($SECONDS / 60) % 60))min${NONE} ${ELAPSED}"
	# fi

	# if [[ $(( SECONDS / 3600 )) > 0 ]]; then
	# 	ELAPSED="${R}$(($SECONDS / 3600))hrs${NONE} ${ELAPSED}"
	# fi

	# ELAPSED="Elapsed SEC=${SECONDS} p: ${ELAPSED}"

	# ELAPSED="Elapsed SEC=$SECONDS SINCE=${SECONDS} p: $ELAPSED"


	#~ PS1="$TITLEBAR ${EMK}[${UC}\u${EMK}@${UC}\h ${EMB}\${NEW_PWD}${EMK}]${UC}\\$ ${NONE}"
	### Blake's Colors
	### State - EMC NONE Y NONE W
	#~ PS1="$TITLEBAR ${EMK}           [${UC}\u${EMK} @${UC}\h ${EMB}\${NEW_PWD}${EMK}]${UC}\\$ ${NONE}"
	PS1="$TITLEBAR[$PROMPT_STATUS][${G}ELAPSED:${NONE} $R\${ELAPSED_H}$NONE$Y\${ELAPSED_M}$NONE$G\${ELAPSED_S}$NONE][${UC}\u${NONE}@${Y}\h:${W}\${NEW_PWD}${NONE}]${UC}\\$ ${NONE}"
	# without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
	# extra backslash in front of \$ to make bash colorize the prompt
}

trap before_command DEBUG
PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

#
# Set up the bash HISTFILE to save into the sessions folder with a name related to the shell and window
#
if [[ ! -e "$HOME/.bash_sessions" ]]; then
	mkdir "$HOME/.bash_sessions"
fi
export HISTFILE="$HOME/.bash_sessions/$TERM.window.$WINDOW"

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

bind '"\t":menu-complete'
# bindkey "^I" complete-word-fwd
# history search up/down-arrow behavior. Start typing a word, then use arrow keys to search for
# similar historical commands.
# https://unix.stackexchange.com/questions/76566/where-do-i-find-a-list-of-terminal-key-codes-to-remap-shortcuts-in-bash
if $PLAT_MAC ; then
	# Mac specific(?) binds
	bind '"\033[A":history-search-backward'
	bind '"\033[B":history-search-forward'
fi


###########################
### ALIASES and COMMANDS
###########################


### Working with Unix
alias l='ls -lh'
alias ll='ls -al'
alias gl='gls -lh --color=auto'
alias gll='gl -a'
alias p='ps x'
alias pp='ps xa'
alias pm='ps -eo pid,pcpu,pmem,user,comm --sort -%cpu | head -10'
alias pc='ps -eo pid,pcpu,pmem,user,comm --sort -%cpu | head -10'
if $PLAT_MAC ; then
	alias pm='ps amcxo pid,pcpu,pmem,user,command | head -10'
	alias pc='ps arcxo pid,pcpu,pmem,user,command | head -10'
fi
alias ip='ifconfig | grep "inet "'
alias rmignored='rm */*.ignore'

alias dus='du -Psckx * | sort -nr'
alias untar='tar -zxvf'
alias cpan='sudo perl -MCPAN -e shell'
alias editcron='env EDITOR=nano crontab -e'

### Server Connections
alias quakers='ssh -l quakers q3.mendelbio.com'
##### Home Network
# ssh -A -t root@apt.resourcefork.com \ ssh -A -t rick@192.168.1.5
ROUTER_ADDRESS='apt.resourcefork.com'
CMD_SSH_ARC='ssh -A -t admin@192.168.1.9'
CMD_SSH_MORTY='ssh -A -t root@192.168.1.6'
CMD_SSH_PILLAR='ssh -A -t blake@192.168.1.2 screen -x -RR -U'
CMD_SSH_RICK='ssh -A -t rick@192.168.1.5 screen -x -RR -U'
CMD_SSH_ROUTER="ssh -A -t root@${ROUTER_ADDRESS}"
CMD_SSH_ROUTER_LOCAL='ssh -A -t root@192.168.1.1'
alias ssharc="${CMD_SSH_ROUTER} \ ${CMD_SSH_ARC}"
alias ssharclocal=$CMD_SSH_ARC
alias sshpillar="${CMD_SSH_ROUTER} \ ${CMD_SSH_PILLAR}"
alias sshpillarlocal=$CMD_SSH_PILLAR
alias sshrick="${CMD_SSH_ROUTER} \ ${CMD_SSH_RICK}"
alias sshricklocal=$CMD_SSH_RICK
alias sshrouter=$CMD_SSH_ROUTER
alias sshrouterlocal=$CMD_SSH_ROUTER_LOCAL

### Working with Perl
alias build='perl Makefile.PL; make'
alias clean='make realclean'
alias rebuild='clean; build'

alias apacheerr='tail /var/log/httpd/error_log'
if $PLAT_MAC ; then
	alias apacheerr='tail /var/log/apache2/error_log'
fi

### Working with NodeJS
alias npmreset='rm -rf node_modules package-lock.json'
alias nvmupgrade='nvm alias default node && nvm install node --reinstall-packages-from=node'

### Directories
alias ..='cd ..'
alias webroot='cd /var/www/html'


# Load the machine version of this file
source_machine_version bashrc
