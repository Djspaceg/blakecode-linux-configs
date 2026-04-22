# shell/modules/aws-federate.zsh
#
# AWS federation — sources the full script at shell init.
# The script only defines variables and a function; the actual
# network calls only happen when you run `federate`.
#

source ~/.aws/aws-federate.sh
