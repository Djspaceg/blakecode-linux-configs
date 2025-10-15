# zprofile
#
# Runs for LOGIN shells only (after zshenv, before zshrc)
# Login-specific setup that doesn't need to run for every shell
#

echo "Running ~/zprofile"

##############################################################################

# Load machine-specific login configuration
source_machine_version zprofile
