# Kiro Configuration Catalog

Single reference for every MCP server, power, agent, steering doc, skill, and
hook in this setup. Update when adding or removing any of these.

Last audited: 2026-07-23

## Architecture

Three layers, by activation model:

| Layer | Mechanism | When it loads |
|-------|-----------|---------------|
| Global MCP servers | `~/.kiro/settings/mcp.json` | Always, every session |
| Powers (semantic plugins) | `kiro/powers/*` in this repo, installed via Powers UI | On demand, when task matches keywords |
| Steering docs | `~/.kiro/steering/` + workspace `.kiro/steering/` | `always` / `auto` (semantic) / `fileMatch` / `manual` |

Secrets live in `~/.secrets/kiro-mcp.env` (chmod 600, outside all repos),
sourced by `shell/core/env.zsh`, referenced from configs via `${VAR}`.

## Global MCP Servers (always on)

| Server | What it does |
|--------|--------------|
| git | Local git operations (status, diff, commit, branch) |
| filesystem | File ops in /Volumes/workplace, ~/Source, /tmp |
| builder-mcp | Amazon internal: code search, wiki, CRs, Brazil builds, tickets |
| dsai-mcp | JIRA + Confluence (labcollab), WorkDocs, component context |
| SuperhumanDocs | Coda docs (docs.superhuman.com) |
| cr-guide-mcp | CR review guide generation |
| slack-mcp | Slack read/write, canvases, lists, reminders |

## Powers (on-demand, in `kiro/powers/`)

Installed automatically by `install.sh` (Step 4b): each power is symlinked
into `~/.kiro/powers/installed/` and registered in `installed.json`, so edits
in this repo apply immediately. Kiro activates powers automatically when the
task matches their keywords. Restart Kiro after first install so it connects
the powers' MCP servers.

| Power | Server | Activates for |
|-------|--------|---------------|
| macos-xcode-dev | XcodeBuildMCP | Xcode/macOS app builds, schemes, tests |
| unity-dev | unity-mcp | Unity editor work |
| devices-gitlab | gitlab | MRs/issues on git.ak.devices.amazon.dev |
| jetbrains-bridge | jetbrains (SSE) | Working alongside a JetBrains IDE |
| harmony-docs | harmony-mcp | Harmony platform docs and examples |
| tekton-tools | tekton-mcp | Tekton tasks |
| prompt-engineering | prompt-mcp | Prompt authoring/eval |
| concur-expenses | concur-mcp | Expense reports |

Pre-installed (registry): power-builder, ltm-power.

## Steering Docs

User level (`~/.kiro/steering/`):

| Doc | Mode | Purpose |
|-----|------|---------|
| communication-style | always | No sincerity qualifiers, no filler |
| tool-use | always | Use git/filesystem MCP tools |
| amazon-builder/production-safety | always | AWS prod credential/resource safety |
| amazon-builder/inclusivity-scanner | always | Inclusive terminology |
| amazon-builder/git | always | Commit rules, AutoSDE loop, repo integrity |
| amazon-builder/brazil | auto | Brazil builds, workspaces, dependencies |
| amazon-builder/coral | auto | Coral/internal API signature verification |
| amazon-builder/crux | auto | Creating/updating CRs |
| amazon-builder/taskei | auto | Taskei task management |
| amazon-builder/internal-systems | auto | Internal systems reference map |

Workspace level: `blakecode-linux-configs/.kiro/steering/architecture.md`
(always, this repo only).

`auto` docs activate semantically from their name/description, like powers.
They also appear as slash commands.

## Agents (`~/.kiro/agents/`, 78 files, ALL AIM-managed - do not edit)

| Pack | Count | Highlights |
|------|-------|------------|
| AIPowerUserCapabilities | 58 | gpu-dev (general default), gpu-coder, gpu-multiagent + 13 specialists, gpu-autosde CR review pipeline, gpu-research, gpu-writing, pipeline fixers, mixins |
| DeveloperVelocityToolkitAgents | 12 | spec-driven-dev-lite suite, pipeline-unblocker, shepherd-agent, ads-test-generator |
| AmazonBuilderCoreAIAgents | 4 | amzn-builder, pipeline/apollo assistants |
| PipelineAssistantAgent | 3 | duplicates of the pipeline/apollo assistants above |
| AtlasAICapabilities | 1 | atlas |

Known duplicates (shipped by multiple packs, same behavior):
apollo-deployment-assistant (x3), pipeline-assistant (x2),
amzn-pipeline-assistant (x2). Prefer the AmazonBuilderCoreAIAgents versions.

Update agents via AIM, not by editing files.

## Skills (`~/.kiro/skills/`)

- deployment-fixer - pipeline/CFN deployment failures
- frontend-agent - React 19 / Vite / Zustand work
- rewrite-in-amazon-writing-style - Amazon business writing

## Hooks (`~/.kiro/hooks/`)

- review-just-committed-changes.kiro.hook (legacy format - won't execute until migrated in Agent Hooks panel)
- review-uncommitted-changes.kiro.hook (legacy)
- test-fei-hooks.kiro.hook (legacy)

## Secrets

`~/.secrets/kiro-mcp.env` holds: QUIP_API_TOKEN, SUPERHUMAN_API_KEY,
GITLAB_PERSONAL_ACCESS_TOKEN. Referenced via `${VAR}` from mcp.json and the
devices-gitlab power. New machine setup: create the file (chmod 600), populate
tokens, done - env.zsh sources it automatically if present.
