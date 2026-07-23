---
name: "unity-dev"
displayName: "Unity Development"
description: "Unity editor integration via the Unity MCP relay. Activates for Unity game development - scenes, GameObjects, assets, and editor operations."
keywords: ["unity", "unity3d", "unity editor", "game development", "gameobject", "unity scene", "prefab"]
author: "stepblk"
---

# Unity Development

## Overview

Connects to the local Unity MCP relay for editor-integrated work on Unity
projects. Requires the Unity editor to be running with the relay installed.

## Available MCP Servers

**unity-mcp** - local relay binary at
`~/.unity/relay/relay_mac_arm64.app/Contents/MacOS/relay_mac_arm64`

## Prerequisites

- Unity editor open with the target project
- Unity MCP relay package installed in the project

## Troubleshooting

- Connection refused: the relay only runs while the Unity editor is open.
- Stale state: restart the relay from Unity's MCP window.
