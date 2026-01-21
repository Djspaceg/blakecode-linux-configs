#!/bin/bash -e
# NOTE the `-e` above which forces an exit on any script failure automatically.

# This script is used to bootstrap the CDK package and deploy the full CDK
# stack. It is used in the pipeline to bootstrap the CDK package and deploy the
# full CDK stack. It is also used to bootstrap the CDK package and deploy the
# full CDK stack locally.
# Usage:
#   ./cdk-bootstrap.sh
#      or
#   ./cdk-bootstrap.sh <stack-name>
# Example:
#   ./cdk-bootstrap.sh "FullCDKStack-Dev"

# Help message function
show_help() {
    cat << EOF
Usage: $0 [-p] [stack-name]
Bootstrap and deploy the CDK stack.

Options:
  -h, --help    Show this help message
  -p            Deploy pipeline before stack deployment

Arguments:
  stack-name    Name of the stack to deploy (optional)

Example:
  $0 -p "FullCDKStack-Dev"    # Deploy pipeline then stack
  $0 "FullCDKStack-Dev"       # Deploy stack only
  $0                          # Deploy everything
EOF
    return 0
}

# Initialize variables
DEPLOY_PIPELINE=false
STACK_NAME=""

# Process command line arguments
# while [ $# -gt 0 ]; do
#   case "$1" in
#     --help|-h)
#       show_help
#       return 0
#       ;;
#     *)
#       STACK_NAME="$1"
#       break
#       ;;
#   esac
#   shift
# done
while getopts ":hp" opt; do
  case ${opt} in
    h )
      show_help
      return 0
      ;;
    p )
      DEPLOY_PIPELINE=true
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      return 1
      ;;
  esac
done
shift $((OPTIND -1))

# Get stack name from remaining argument
STACK_NAME="$1"

### Rest of the script

line () {
  printf "\n"
  printf -- "-%.0s" {1..60}
  printf "\n"
}

big_message () {
  line
  printf "   %s" "$1";
  line
}

# big_message "Releasing"

# if brazil-build release; then
#   big_message "Bootstrapping CDK package"

#   if brazil-build bootstrap; then
#     big_message "Deploying Pipeline"

#     if brazil-build deploy:pipeline; then
#       # Check if stack name is provided
#       if [ -z "$STACK_NAME" ]; then
#         big_message "Deploying All Stacks"
#         brazil-build cdk deploy --all
#       else
#         big_message "Deploying Stack: $STACK_NAME"
#         brazil-build cdk deploy "$STACK_NAME"
#       fi
#     fi
#   fi
# fi

# Main execution
big_message "Releasing"
if ! brazil-build release; then
    echo "Release failed"
    return 1
fi

big_message "Bootstrapping CDK package"
if ! brazil-build bootstrap; then
    echo "Bootstrap failed"
    return 1
fi

# Only run pipeline deployment if -p flag is present
if [ "$DEPLOY_PIPELINE" = true ]; then
    big_message "Deploying Pipeline"
    if ! brazil-build deploy:pipeline; then
        echo "Pipeline deployment failed"
        return 1
    fi
fi

big_message "Deploying Full CDK: $STACK_NAME"
if ! brazil-build cdk deploy "$STACK_NAME"; then
    echo "Stack deployment failed"
    return 1
fi

big_message "Deployment Complete"
