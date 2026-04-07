#!/bin/bash
# Wrapper to run brazil-build-tool-exec npx from within a Brazil workspace.
# Kiro launches MCP servers from /, which breaks brazil-build-tool-exec.
# This script cd's into a known Brazil package first.

BRAZIL_PACKAGE="/Volumes/workplace/stepblk/stepblk-sandbox/src/StepblkSandbox"

if [ ! -d "$BRAZIL_PACKAGE" ]; then
  echo "Error: Brazil package not found at $BRAZIL_PACKAGE" >&2
  exit 1
fi

cd "$BRAZIL_PACKAGE"
exec brazil-build-tool-exec npx "$@"
