#!/bin/bash
uptime | awk 'BEGIN { FS = "(  |,[ \t\n]*)" } {print $2}'
