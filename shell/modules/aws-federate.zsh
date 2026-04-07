# shell/modules/aws-federate.zsh
#
# Lazy-loaded AWS federation.
# The federate() function needs to `source` aws-federate.sh to export
# env vars into the current shell, but there's no reason to parse the
# full file at shell startup. This stub replaces itself on first call.
#

federate() {
    unfunction federate
    source ~/.aws/aws-federate.sh
    federate "$@"
}
