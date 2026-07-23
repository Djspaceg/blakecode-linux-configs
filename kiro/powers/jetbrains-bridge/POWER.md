---
name: "jetbrains-bridge"
displayName: "JetBrains IDE Bridge"
description: "Bridge to a running JetBrains IDE (IntelliJ, PyCharm, etc.) for run configurations, refactoring, and project inspection. Activates when working alongside a JetBrains IDE."
keywords: ["intellij", "jetbrains", "pycharm", "idea", "run configuration", "jetbrains refactor"]
author: "stepblk"
---

# JetBrains IDE Bridge

## Overview

Connects to a running JetBrains IDE's built-in MCP server (SSE on
localhost:64342). Lets the agent execute run configurations, inspect
problems/dependencies, and use IDE-quality refactoring.

## Available MCP Servers

**jetbrains** - SSE at `http://localhost:64342/sse`

Key tools (auto-approved): run configurations, file problems, project
modules/dependencies, file CRUD, regex/text search, `rename_refactoring`,
`reformat_file`, terminal commands.

## Prerequisites

- A JetBrains IDE must be running with the MCP server enabled
  (Settings -> Tools -> MCP Server), listening on port 64342.

## Troubleshooting

- Connection refused: IDE not running or MCP server disabled.
- Port mismatch: check the port in IDE settings matches 64342.
