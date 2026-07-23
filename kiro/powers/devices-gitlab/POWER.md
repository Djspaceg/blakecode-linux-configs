---
name: "devices-gitlab"
displayName: "Amazon Devices GitLab"
description: "Work with repos on git.ak.devices.amazon.dev - merge requests, issues, pipelines, and repository browsing. Activates for GitLab tasks on the Devices GitLab instance."
keywords: ["gitlab", "merge request", "MR", "git.ak.devices", "gitlab pipeline", "gitlab issue", "devices gitlab"]
author: "stepblk"
---

# Amazon Devices GitLab

## Overview

GitLab API access for the Amazon Devices GitLab instance
(`git.ak.devices.amazon.dev`). Create/review merge requests, manage issues,
inspect pipelines, and browse repos without leaving the session.

## Available MCP Servers

**gitlab** (`@zereight/mcp-gitlab`)

- API URL: `https://git.ak.devices.amazon.dev/api/v4`
- Auth: reads `GITLAB_PERSONAL_ACCESS_TOKEN` from the environment
  (set in `~/.secrets/kiro-mcp.env`, chmod 600, sourced by shell startup)
- Read-only mode: off (writes allowed)

## Configuration

The PAT is never stored in this power. If auth fails:
1. Check the token exists: `grep GITLAB ~/.secrets/kiro-mcp.env`
2. Regenerate at https://git.ak.devices.amazon.dev/-/user_settings/personal_access_tokens
3. Update the env file and restart Kiro.
