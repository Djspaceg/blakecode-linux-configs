# Configuration Architecture (v2)

This repository manages shell and terminal configurations across multiple machines
using an inverted control model: machine configs are the entry points, shared code
is a library they pull from.

## Core Principle: Machine Controls, Core Provides

Each machine has its own zsh startup files (zshenv, zprofile, zshrc) and a screenrc.
These are the symlink targets. They source shared core and modules as needed.
The machine file decides what to load and in what order.

## Directory Structure

```
~/.profileconfig/                        (symlink to this repo)
├── install-v2.sh                        Setup script
├── ARCHITECTURE.md                      Full documentation
│
├── shell/
│   ├── core/                            Shared config (sourced BY machine files)
│   │   ├── env.zsh                      Platform detection, HOSTNAME derivation
│   │   ├── login.zsh                    Shared login shell setup
│   │   ├── interactive.zsh              Prompt, history, colors, terminal integrations
│   │   ├── aliases.zsh                  Generic Unix aliases
│   │   └── completions.zsh             compinit, Docker, bun completions
│   ├── modules/                         Opt-in feature sets
│   │   ├── brazil.zsh                   Amazon Brazil build aliases + functions
│   │   ├── aws-federate.zsh            Lazy-loaded AWS federate()
│   │   ├── iterm.zsh                    iTerm2 user variables
│   │   ├── homebrew-apple-silicon.zsh  /opt/homebrew paths
│   │   ├── homebrew-intel.zsh          /usr/local paths
│   │   └── docker-aliases.zsh          Docker/compose aliases
│   └── machines/                        One directory per machine
│       ├── CandyKingdom/{zshenv,zprofile,zshrc}
│       ├── AmazonCloudDesk/{zshenv,zprofile,zshrc}
│       └── JungleFort/{zshenv,zprofile,zshrc}
│
├── screen/                              Pure Screen parser syntax ONLY
│   ├── core.screenrc                    Settings, keybindings, F-keys
│   ├── colors/                          Color themes
│   │   ├── green.screenrc, blue.screenrc, orange.screenrc
│   │   ├── magenta.screenrc, yellow.screenrc
│   └── machines/                        Window layouts (→ ~/.screenrc)
│       ├── CandyKingdom.screenrc
│       ├── AmazonCloudDesk.screenrc
│       └── JungleFort.screenrc
│
├── scripts/                             Standalone executables
└── legacy/                              Archived bash-era configs
```

## Symlinks (created by install-v2.sh)

```
~/.profileconfig  → this repo
~/.zshenv         → shell/machines/$HOSTNAME/zshenv
~/.zprofile       → shell/machines/$HOSTNAME/zprofile
~/.zshrc          → shell/machines/$HOSTNAME/zshrc
~/.screenrc       → screen/machines/$HOSTNAME.screenrc
```

## Shell Startup Flow

```
1. ~/.zshenv (→ machine zshenv)
   └── source core/env.zsh (HOSTNAME derived from file path, platform detection)
   └── Machine env vars, PATH

2. ~/.zprofile (→ machine zprofile)
   └── source core/login.zsh
   └── Homebrew module, machine login setup

3. ~/.zshrc (→ machine zshrc)
   └── source core/interactive.zsh (guard, terminal integrations, prompt, history)
   └── source core/aliases.zsh
   └── source modules as needed (brazil, aws-federate, iterm, etc.)
   └── Machine aliases and functions
   └── source core/completions.zsh (always last)
```

## Screen Startup Flow

```
~/.screenrc (→ machine screenrc)
└── source screen/core.screenrc (settings, keybindings)
└── source screen/colors/[theme].screenrc (status bar colors)
└── Window definitions
```

## Key Variables

| Variable | Set By | Purpose |
|----------|--------|---------|
| HOSTNAME | core/env.zsh (from file path) | Machine identifier |
| PROFILECONFIGDIR | core/env.zsh | Path to this repo |
| PLAT_MAC / PLAT_LINUX | core/env.zsh | Platform flags |
| WINDOW | screen | Current screen window number |

## Design Rules

- Shell files in `shell/`. Screen files in `screen/`. Never mix parsers.
- Screen files: ONLY Screen commands. No shell syntax, no tput, no $().
- Modules are opt-in. Machine files explicitly source what they need.
- completions.zsh always loads last.
- Terminal integrations load early in interactive.zsh to prevent re-sourcing.
- No `eval "$(brew shellenv)"` or slow subshells. Hardcode paths in modules.

## Adding a New Machine

1. `echo "NewMachine" > ~/.bc-hostname`
2. `bash ~/.profileconfig/install-v2.sh` (creates skeleton + symlinks)
3. Edit files in `shell/machines/NewMachine/`
4. Create `screen/machines/NewMachine.screenrc`, pick a color theme
