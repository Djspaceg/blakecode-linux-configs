#!/bin/bash
echo "Preparing RC files"

# Order of operations is important in this file.

export PROFILECONFIGDIR=${PROFILECONFIGDIR:-"$HOME/.profileconfig"}
export FPATH=$PROFILECONFIGDIR/functions:$FPATH

# Configure auto-load of defined functions
# http://zsh.sourceforge.net/Intro/intro_4.html
autoload custom_hostname source_optional source_machine_version

# Actually execute the custom_hostname script, setting the $HOSTNAME variable
custom_hostname

export MACHINECONFIGDIR=${MACHINECONFIGDIR:-"$PROFILECONFIGDIR/machine-configs/$HOSTNAME"}
