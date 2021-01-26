# zshenv
#
# Zsh login, execute once-per-session type of stuff
#

echo "Running ~/zshenv"

##############################################################################

##########################
### SYSTEM CONFIGURATION
### Execute Once Per Login
##########################

# Enable variables in the prompt
setopt prompt_subst

# Use a custom host name, for loading config files etc, if the file exists
if [[ -e "$HOME/.bc-hostname" ]]; then
    export HOSTNAME=$(cat $HOME/.bc-hostname)
else
    export HOSTNAME=$(hostname)
fi


PLAT_NIX=true
PLAT_LINUX=false
PLAT_MAC=false

case "$OSTYPE" in
  darwin*)  PLAT_MAC=true ;;
  solaris*) PLAT_NIX=true ;;
  linux*)   PLAT_NIX=true && PLAT_LINUX=true ;;
  bsd*)     PLAT_NIX=true && PLAT_LINUX=true ;;
  *)        echo "OS Detection failed. \$OSTYPE '$OSTYPE' unknown." ;;
esac

export PLAT_NIX
export PLAT_LINUX
export PLAT_MAC

export PATH=/opt/bin:/opt/sbin:/usr/local/bin:$PATH:~/Unix/apache-ant/bin:~/Unix/ares-cli/bin


### Setup enyo-dev compiling
# ulimit -n 2560


#
# Configure global variables to make loading machine-specific configs easier
# and more consistent across multiple files
#
export PROFILECONFIGDIR="$HOME/.profileconfig"
export MACHINECONFIGDIR="$PROFILECONFIGDIR/machine-configs/$HOSTNAME"
source "$PROFILECONFIGDIR/prepare-rc-files.sh"
# screen -X setenv HOME "$HOME"
# screen -X setenv HOSTNAME "$HOSTNAME"
# screen -X setenv PROFILECONFIGDIR "$PROFILECONFIGDIR"
# screen -X setenv MACHINECONFIGDIR "$MACHINECONFIGDIR"

# Load the machine version of this file
source_machine_version zshenv
