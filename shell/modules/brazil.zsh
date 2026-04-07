# shell/modules/brazil.zsh
#
# Amazon Brazil build system aliases and functions.
# Source this from any machine's zshrc that uses Brazil.
#

### Brazil Build
alias bb='brazil-build'
alias bba='brazil-build apollo-pkg'
alias bbs='brazil-build start'

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
