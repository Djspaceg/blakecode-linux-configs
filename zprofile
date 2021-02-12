# zshenv
#
# Zsh login, execute once-per-session type of stuff
#

echo "Running ~/zprofile"

##############################################################################


export PATH=/opt/bin:/opt/sbin:/usr/local/bin:$PATH


# Re-run the custom_hostname method to ensure $HOSTNAME being set.
# This seemed necessary on AL2.
custom_hostname

# Load the machine version of this file
source_machine_version zprofile
