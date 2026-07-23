# shell/modules/brazil.zsh
#
# Amazon Brazil build system aliases and functions.
# Source this from any machine's zshrc that uses Brazil.
#

### Brazil Build
alias bb='brazil-build'
alias bba='brazil-build apollo-pkg'
alias bbs='brazil-build start'
alias bbx='brazil-build-tool-exec'

### Brazil Runtime
alias bre='brazil-runtime-exec'

### Brazil Recursive Commands
alias brc='brazil-recursive-cmd'
alias bbr='brc brazil-build'
alias bball='brc --allPackages'
alias bbb='brc --allPackages brazil-build'
alias bbra='bbr apollo-pkg'
alias brb='brc brazil-build run reset && bbr'

### Brazil Workspace
alias bws='brazil ws'
alias bwsuse='bws use --gitMode -p'
alias bwscreate='bws create -n'
alias bsync='bws --sync'
alias bsm='bsync --md'

### CDK Functions

buildcdk() {
    echo " -------------------------------------------------------------------"
    echo "   Releasing using stack: $1"
    echo "   Using account ID: $AWS_ACCOUNT_ID"
    echo " -------------------------------------------------------------------"
    brazil-build release

    if [[ $? -eq 0 ]]; then
        echo ""
        echo " -------------------------------------------------------------------"
        echo "   Deploying Assets with: $1"
        echo " -------------------------------------------------------------------"
        brazil-build deploy:assets "$1"

        if [[ $? -eq 0 ]]; then
            echo ""
            echo " -------------------------------------------------------------------"
            echo "   Deploying CDK with: $1"
            echo " -------------------------------------------------------------------"
            brazil-build cdk deploy "$1"
        fi
    fi
}

bootstrapcdk() {
    [[ -s "$PROFILECONFIGDIR/scripts/cdk-bootstrap.sh" ]] && . "$PROFILECONFIGDIR/scripts/cdk-bootstrap.sh"
}

alias getstacks='brazil-build cdk ls'
alias getuserstack='brazil-build cdk ls | grep BONESBootstrap-${USER}'

### BATS Debugging
alias batslog='bats transform --transformer AWSLambda-1.0 --target $(basename $PWD)-1.0 --parameter $(basename $PWD)-1.0 -o build/private/tmp/'

### npm shim — route to brazil-build when inside a Brazil workspace
#
# Rules (in order):
#   1. cwd matches /workplace/ AND folder name contains "CDK"  -> brazil-build app "$@"
#   2. cwd matches /workplace/                                  -> brazil-build "$@"
#   3. otherwise                                                -> real npm "$@"
#
# Detection is path-based (fast, no subshells). Brazil workspaces always live
# under a /workplace/ directory, so $PWD containing "/workplace/" is a reliable
# signal without paying the cost of `brazil ws show` on every call.
#
# Usage:
#   bnpm install         # always goes through the shim
#   bnpm test
#
# To override the real `npm` command itself, set BNPM_OVERRIDE_NPM=1 before
# sourcing this module (opt-in; off by default to avoid surprising tooling,
# npx, and editor integrations that shell out to `npm`).

bnpm() {
    local pwd_lower folder_lower
    pwd_lower="${PWD:l}"
    folder_lower="${PWD:t:l}"

    if [[ "$pwd_lower" == */workplace/* ]]; then
        if [[ "$folder_lower" == *cdk* ]]; then
            command brazil-build app "$@"
        else
            command brazil-build "$@"
        fi
    else
        command npm --registry https://registry.npmjs.org/ "$@"
    fi
}

if [[ -n "$BNPM_OVERRIDE_NPM" ]]; then
    npm() { bnpm "$@"; }
fi
