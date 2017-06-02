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
alias gl='gls -l --color=auto'
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
alias rmemptydirs="find -type d -exec bash -c 'shopt -s nullglob; shopt -s dotglob; files=(\"$1\"/*); [[ ${files[@]} ]] || rmdir \"$1\"' -- {} ;"
alias rmignored='rm */*.ignore'

alias dus='du -Psckx * | sort -nr'
alias untar='tar -zxvf'
alias cpan='sudo perl -MCPAN -e shell'
alias editcron='env EDITOR=nano crontab -e'

### Server Connections
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
alias cdenact='cd ~/Source/enact'
alias cdrigby='cd ~/Source/rigby'
alias nodemodules='cd ~/.nvm/versions/node/current/lib/node_modules/'

export CLICOLOR=1
export LSCOLORS='dahebxBxDxehxxbxexGxac'

### LG Shortcuts
alias enstall='npm install; enact link'
alias serve='npm run serve'
alias qa='npm run serve-qa'
alias testComponent='enact test start --single-run --browsers PhantomJS'
alias testComponentWatch='enact test start --browsers PhantomJS'


# For GNU ls (installed via brew -> coreutil)
# http://unix.stackexchange.com/questions/239078/os-x-can-ls-show-broken-symlinks
# http://www.gnu.org/software/coreutils/coreutils.html
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:';
export LS_COLORS

### Setup enyo-dev compiling
ulimit -n 2560

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

#
# Set up Node Version Manager
#
export NVM_DIR="/Users/blake/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
export NVM_CURRENT=$(npm config --global get prefix)

# Update the symlink that controls where the bin files are (added during webpack research)
if [ -d "$NVM_DIR" ]
then
	rm "$NVM_DIR/versions/node/current"
	ln -s "$NVM_CURRENT" "$NVM_DIR/versions/node/current"
fi
