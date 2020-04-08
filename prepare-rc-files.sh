#!/bin/bash

export PROFILECONFIGDIR=${PROFILECONFIGDIR:-"$HOME/.profileconfig"}
export MACHINECONFIGDIR=${MACHINECONFIGDIR:-"$PROFILECONFIGDIR/machine-configs/$HOSTNAME"}

# Sources a given file, if it exists
function source_optional() {
	local file=$1
	if [[ -e "$file" ]]; then
		# echo "   source_optional: $file"
		source "$file"
	fi
}

# "Sources" the machine version of the script that calls this.
# It looks in the machine-configs folder for a matching file name.
# Accepts an optional path or uses the curent script's name.
function source_machine_version() {
	local file=${1:-"$(basename -- $0)"}
	# echo "   source_machine_version: $MACHINECONFIGDIR/$file"
	source_optional "$MACHINECONFIGDIR/$file"
}


export -f source_optional
export -f source_machine_version
