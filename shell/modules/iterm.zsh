# shell/modules/iterm.zsh
#
# iTerm2 custom user variables for the status bar.
# Only meaningful when running inside iTerm2.
# The shell integration itself is loaded early in core/interactive.zsh.
#

if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    iterm2_print_user_vars() {
        iterm2_set_user_var hostName "$HOSTNAME"

        local uptime_str
        uptime_str=$("$PROFILECONFIGDIR/scripts/justuptime.sh")
        iterm2_set_user_var uptime "$uptime_str"

        local ip_str
        ip_str=$("$PROFILECONFIGDIR/scripts/myip.sh")
        iterm2_set_user_var ipAddress "$ip_str"
    }
fi
