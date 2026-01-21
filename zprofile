
# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"

# zprofile
#
# Runs for LOGIN shells only (after zshenv, before zshrc)
# Login-specific setup that doesn't need to run for every shell
#

echo "Running ~/zprofile"

##############################################################################

# Load machine-specific login configuration
source_machine_version zprofile


# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"
