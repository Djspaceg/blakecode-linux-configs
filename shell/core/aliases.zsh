# shell/core/aliases.zsh
#
# Shared aliases for all machines — sourced by each machine's zshrc.
#

### Working with Unix
alias l='ls -lh'
alias ll='l -a'
if $PLAT_LINUX; then
    alias l='ls -lh --color'
fi
alias p='ps x'
alias pp='ps xa'
alias pm='ps -eo pid,pcpu,pmem,user,comm --sort -%cpu | head -10'
alias pc='ps -eo pid,pcpu,pmem,user,comm --sort -%cpu | head -10'
if $PLAT_MAC; then
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

### Home Network
# Single source of truth: each host's full connect command is defined once,
# as an array. The direct ("*local") and through-the-router variants both
# reuse the same array, so they can never drift apart. The router address is
# likewise defined once. Aliases can't do this (alias expansion only fires on
# a command's first word, so it won't compose in argument position), so these
# are functions.
ROUTER_ADDRESS='apt.resourcefork.com'
ROUTER_LOCAL_ADDRESS='192.168.1.1'

_arc_cmd=(ssh -A -t admin@192.168.1.9)
_pillar_cmd=(ssh -A -t blake@192.168.1.2 screen -x -RR -U)
_rick_cmd=(ssh -A -t rick@192.168.1.5 screen -x -RR -U)

# Dial the router, then run whatever command you pass on it.
sshrouter()      { ssh -A -t "root@${ROUTER_ADDRESS}" "$@"; }
sshrouterlocal() { ssh -A -t "root@${ROUTER_LOCAL_ADDRESS}"; }

# Direct connections (already on the LAN): run the connect command locally.
ssharclocal()    { "${_arc_cmd[@]}"; }
sshpillarlocal() { "${_pillar_cmd[@]}"; }
sshricklocal()   { "${_rick_cmd[@]}"; }

# Through the router: run the SAME connect command, but on the router.
ssharc()    { sshrouter "${_arc_cmd[@]}"; }
sshpillar() { sshrouter "${_pillar_cmd[@]}"; }
sshrick()   { sshrouter "${_rick_cmd[@]}"; }

### Working with Perl
alias build='perl Makefile.PL; make'
alias clean='make realclean'
alias rebuild='clean; build'

alias apacheerr='tail /var/log/httpd/error_log'
if $PLAT_MAC; then
    alias apacheerr='tail /var/log/apache2/error_log'
fi

### Working with NodeJS
alias npmreset='rm -rf node_modules package-lock.json'

### Directories
alias ..='cd ..'
