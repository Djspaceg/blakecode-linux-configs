---
name: "macos-xcode-dev"
displayName: "macOS / Xcode Development"
description: "Build, test, and run macOS apps with XcodeBuildMCP. Activates for Xcode project work - discovering schemes, building, running tests, and launching Mac apps."
keywords: ["xcode", "xcodebuild", "macos app", "swift", "swiftui", "xcodeproj", "xcworkspace", "build scheme", "mac app"]
author: "stepblk"
---

# macOS / Xcode Development

## Overview

Wraps XcodeBuildMCP so Xcode tooling only loads when doing macOS development.
Simulator, iOS-device, and UI-automation tools are disabled by design - this
power is scoped to macOS desktop app work.

## Available MCP Servers

**XcodeBuildMCP** (`npx xcodebuildmcp@latest`)

Key tools (auto-approved):
- `discover_projs` / `list_schemes` - find projects and schemes
- `build_macos` / `build_run_macos` / `run_macos` - build and launch
- `test_macos` - run test plans
- `clean` / `show_build_settings` - housekeeping
- `get_mac_app_path` / `launch_mac_app` / `stop_mac_app` - app lifecycle
- `session-set-defaults` / `session-show-defaults` - sticky project/scheme defaults

## Common Workflow

1. `discover_projs` to locate the .xcodeproj/.xcworkspace
2. `session-set-defaults` with the project and scheme
3. `build_macos` (or `build_run_macos` to build and launch)
4. `test_macos` to run tests

## Troubleshooting

- "No schemes found": open the project once in Xcode to generate shared schemes.
- Build errors referencing signing: check the Signing & Capabilities tab; CLI
  builds use the same signing config as Xcode.
