#!/bin/bash
uptime | awk 'BEGIN { FS = ",[ \t\n]*" } sub(/^.*up/,"up",$1) {print $1}'
