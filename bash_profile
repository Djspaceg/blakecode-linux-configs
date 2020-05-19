# bash_profile
#
# Bash login, execute once-per-session type of stuff
#

# echo "Running main bash_profile"

##############################################################################

##########################
### SYSTEM CONFIGURATION
### Execute Once Per Login
##########################

PLAT_NIX=true
PLAT_LINUX=false
PLAT_MAC=false

case "$OSTYPE" in
  darwin*)  PLAT_MAC=true ;;
  solaris*) PLAT_NIX=true ;;
  linux*)   PLAT_NIX=true & PLAT_LINUX=true ;;
  bsd*)     PLAT_NIX=true & PLAT_LINUX=true ;;
  *)        echo "unknown: $OSTYPE" ;;
esac

export PLAT_NIX
export PLAT_LINUX
export PLAT_MAC

export PATH=/opt/bin:/opt/sbin:/usr/local/bin:$PATH:~/Unix/apache-ant/bin:~/Unix/ares-cli/bin


### Setup enyo-dev compiling
ulimit -n 2560


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
source_machine_version bash_profile
