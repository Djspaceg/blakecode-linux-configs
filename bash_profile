# .bashrc

# Source global definitions
#if [ -f /etc/bashrc ]; then
#	source /etc/bashrc
#fi

# User specific aliases and functions

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

	#~ PS1="$TITLEBAR ${EMK}[${UC}\u${EMK}@${UC}\h ${EMB}\${NEW_PWD}${EMK}]${UC}\\$ ${NONE}"
	### Blake's Colors
	### State - EMC NONE Y NONE W
	#~ PS1="$TITLEBAR ${EMK}           [${UC}\u${EMK} @${UC}\h ${EMB}\${NEW_PWD}${EMK}]${UC}\\$ ${NONE}"
	PS1="$TITLEBAR[${PROMPT_STATUS}][${UC}\u${NONE}@${Y}\h:${W}\${NEW_PWD}${NONE}]${UC}\\$ ${NONE}"
	# without colors: PS1="[\u@\h \${NEW_PWD}]\\$ "
	# extra backslash in front of \$ to make bash colorize the prompt
}

PLAT_NIX=true
PLAT_MAC=false

case "$OSTYPE" in
  darwin*)  PLAT_MAC=true ;;
  solaris*) PLAT_NIX=true ;;
  linux*)   PLAT_NIX=true ;;
  bsd*)     PLAT_NIX=true ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

PROMPT_COMMAND=bash_prompt_command
bash_prompt
unset bash_prompt

export PATH=/opt/bin:/opt/sbin:/usr/local/bin:$PATH:~/Unix/apache-ant/bin:~/Unix/ares-cli/bin

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

### Working with Unix
alias l='ls -l'
alias ll='ls -al'
alias p='ps x'
alias pp='ps xa'
alias pm='ps -eo pid,pcpu,pmem,user,comm --sort -%cpu | head -10'
alias pc='ps -eo pid,pcpu,pmem,user,comm --sort -%cpu | head -10'
if $PLAT_MAC ; then
	alias pm='ps amcxo pid,pcpu,pmem,user,command | head -10'
	alias pc='ps arcxo pid,pcpu,pmem,user,command | head -10'
fi
alias ip='ifconfig | grep "inet "'
alias rmemptydirs="find -type d -exec bash -c 'shopt -s nullglob; shopt -s dotglob; files=(\"$1\"/*); [[ ${files[@]} ]] || rmdir \"$1\"' -- {} ;"
alias rmignored='rm */*.ignore'

alias dus='du -Psckx * | sort -nr'
alias untar='tar -zxvf'
alias cpan='sudo perl -MCPAN -e shell'
alias editcron='env EDITOR=nano crontab -e'

### Server Connections
alias carson='ssh carson.mendelbio.com'
alias limsdev='ssh limsdev.mendelbio.com'
alias lims='ssh lims.mendelbio.com'
alias quakers='ssh -l quakers q3.mendelbio.com'

### Working with Perl
alias build='perl Makefile.PL; make'
alias clean='make realclean'
alias rebuild='clean; build'
alias buildtest='perl Makefile.PL INSTALL_BASE=~/dev/stable INST_LIB=~/dev/testmodule INST_SCRIPT=~/dev/scripts'
alias tt='./Build test --verbose 1 --test_files'
alias t='./Build test --test_files'
alias apacheerr='tail /var/log/httpd/error_log'
if $PLAT_MAC ; then
	alias apacheerr='tail /var/log/apache2/error_log'
fi
alias svnbranch='cd ~/src/mb/branches; svn copy http://svn.mendelbio.com/repos/compbio/mb/trunk'
alias mbbranchmerge='svn merge http://svn.mendelbio.com/repos/compbio/mb/trunk'
alias makeless='~/Source/enyo/tools/lessc.sh ./all-package.js'

### Directories
alias ..='cd ..'
alias webroot='cd /var/www/html'
alias mb='cd ~/src/mb/trunk'
alias mobile='cd ~/src/mobile/trunk'
alias ims='cd ~/src/ims/trunk'

export CLICOLOR=1
export LSCOLORS="dahebxBxDxehxxbxexGxac"

### SSH Keys
sshkeylg="$HOME/.ssh/id_rsa_lge"
if [ -e "$sshkeylg" ]
then
	# set -v off
	ssh-add "$sshkeylg"
	# set -v on
fi

# echo get -v

# Make command completion (TAB key) cycle through all possible choices
# (The default is to simply display a list of all choices when more than one
# match is available.)

bind '"\t":menu-complete'
#bindkey "^I" complete-word-fwd

PERL_MB_OPT="--install_base \"/Users/blake/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/blake/perl5"; export PERL_MM_OPT;

PERL_MB_OPT="--install_base \"/Users/blake/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/Users/blake/perl5"; export PERL_MM_OPT;
