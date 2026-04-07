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
ROUTER_ADDRESS='apt.resourcefork.com'
CMD_SSH_ARC='ssh -A -t admin@192.168.1.9'
CMD_SSH_PILLAR='ssh -A -t blake@192.168.1.2 screen -x -RR -U'
CMD_SSH_RICK='ssh -A -t rick@192.168.1.5 screen -x -RR -U'
CMD_SSH_ROUTER="ssh -A -t root@\${ROUTER_ADDRESS}"
CMD_SSH_ROUTER_LOCAL='ssh -A -t root@192.168.1.1'
alias ssharc="\${CMD_SSH_ROUTER} \\\\ \${CMD_SSH_ARC}"
alias ssharclocal="\${CMD_SSH_ARC}"
alias sshpillar="\${CMD_SSH_ROUTER} \\\\ \${CMD_SSH_PILLAR}"
alias sshpillarlocal="\${CMD_SSH_PILLAR}"
alias sshrick="\${CMD_SSH_ROUTER} \\\\ \${CMD_SSH_RICK}"
alias sshricklocal="\${CMD_SSH_RICK}"
alias sshrouter="\${CMD_SSH_ROUTER}"
alias sshrouterlocal="\${CMD_SSH_ROUTER_LOCAL}"

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
