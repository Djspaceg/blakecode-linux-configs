# Configuration Architecture (v2)

This repository manages shell and terminal configurations across multiple machines
using an inverted control model: machine configs are the entry points, shared code
is a library they pull from.

## Core Principle: Machine Controls, Core Provides

Each machine has its own set of zsh startup files (zshenv, zprofile, zshrc) and a
screenrc. These files are the symlink targets — they source shared core and modules
as needed. The machine file decides what to load and in what order.

## Directory Structure

```
~/.profileconfig/                        (symlink to this repo)
├── install-v2.sh                        Setup: reads ~/.bc-hostname, creates symlinks
├── ARCHITECTURE.md                      This file
│
├── shell/
│   ├── core/                            Shared config (sourced BY machine files)
│   │   ├── env.zsh                      Platform detection, HOSTNAME derivation
│   │   ├── login.zsh                    Shared login shell setup
│   │   ├── interactive.zsh              Prompt, history, colors, terminal integrations
│   │   ├── aliases.zsh                  Generic Unix aliases (ls, ps, cd, etc.)
│   │   └── completions.zsh             compinit, Docker, bun completions
│   │
│   ├── modules/                         Opt-in feature sets
│   │   ├── brazil.zsh                   Amazon Brazil build aliases + functions
│   │   ├── aws-federate.zsh            Lazy-loaded AWS federate()
│   │   ├── iterm.zsh                    iTerm2 user variables
│   │   ├── homebrew-apple-silicon.zsh  Hardcoded /opt/homebrew paths
│   │   ├── homebrew-intel.zsh          Hardcoded /usr/local paths
│   │   └── docker-aliases.zsh          Docker/compose aliases
│   │
│   └── machines/                        One directory per machine
│       ├── CandyKingdom/
│       │   ├── zshenv                   → ~/.zshenv (symlink target)
│       │   ├── zprofile                 → ~/.zprofile (symlink target)
│       │   └── zshrc                    → ~/.zshrc (symlink target)
│       ├── AmazonCloudDesk/
│       └── JungleFort/
│
├── screen/                              Pure Screen parser syntax only
│   ├── core.screenrc                    Settings, keybindings, F-keys
│   ├── colors/                          Color themes (one per visual identity)
│   │   ├── green.screenrc
│   │   ├── blue.screenrc
│   │   ├── orange.screenrc
│   │   ├── magenta.screenrc
│   │   └── yellow.screenrc
│   └── machines/                        One file per machine (→ ~/.screenrc)
│       ├── CandyKingdom.screenrc
│       ├── AmazonCloudDesk.screenrc
│       └── JungleFort.screenrc
│
├── scripts/                             Standalone executable scripts
│   ├── justuptime.sh
│   ├── myip.sh
│   └── screen-debug.sh
│
└── legacy/                              Archived bash-era machine configs
    ├── Rick/
    ├── Tree-Fort.local/
    └── Pillar-of-Autumn.local/
```

## How It Works

### Symlinks (created by install-v2.sh)

```
~/.profileconfig  → this repo
~/.zshenv         → shell/machines/$HOSTNAME/zshenv
~/.zprofile       → shell/machines/$HOSTNAME/zprofile
~/.zshrc          → shell/machines/$HOSTNAME/zshrc
~/.screenrc       → screen/machines/$HOSTNAME.screenrc
```

The install script reads `~/.bc-hostname` and points symlinks at the right machine
directory. After installation, there is no runtime hostname detection — the symlinks
ARE the configuration.

### Shell Startup Flow (zsh)

```
1. ~/.zshenv (→ shell/machines/CandyKingdom/zshenv)
   └── source shell/core/env.zsh
       ├── Derives HOSTNAME from file path (no ~/.bc-hostname read)
       └── Platform detection (PLAT_MAC, PLAT_LINUX, etc.)
   └── Machine-specific env vars, PATH

2. ~/.zprofile (→ shell/machines/CandyKingdom/zprofile)
   └── source shell/core/login.zsh
   └── source shell/modules/homebrew-apple-silicon.zsh
   └── Machine-specific login setup

3. ~/.zshrc (→ shell/machines/CandyKingdom/zshrc)
   └── source shell/core/interactive.zsh
       ├── Double-source guard
       ├── Terminal integrations (Kiro, iTerm2) — loaded early
       ├── Prompt, history, colors
       └── Shell options
   └── source shell/core/aliases.zsh
   └── source shell/modules/brazil.zsh
   └── source shell/modules/aws-federate.zsh
   └── Machine-specific aliases and functions
   └── source shell/core/completions.zsh (last)
```

### Screen Startup Flow

```
1. ~/.screenrc (→ screen/machines/CandyKingdom.screenrc)
   └── source screen/core.screenrc
       └── Settings, keybindings, F-keys, backtick commands
   └── source screen/colors/green.screenrc
       └── caption + hardstatus with color theme
   └── Window definitions (screen -t, stuff, chdir, select)
```

Screen inherits $HOSTNAME from the shell environment (set by zshenv).
No hostname detection needed in screenrc.

## Key Variables

| Variable | Set By | Purpose |
|----------|--------|---------|
| HOSTNAME | core/env.zsh (derived from file path) | Machine identifier |
| PROFILECONFIGDIR | core/env.zsh | Path to this repo |
| PLAT_MAC | core/env.zsh | true if macOS |
| PLAT_LINUX | core/env.zsh | true if Linux |
| WINDOW | screen | Current screen window number |

## Adding a New Machine

1. Set hostname: `echo "NewMachine" > ~/.bc-hostname`
2. Run: `bash ~/.profileconfig/install-v2.sh`
   - Creates skeleton configs if they don't exist
   - Creates all symlinks
3. Edit the generated files in `shell/machines/NewMachine/`
4. Add a screenrc in `screen/machines/NewMachine.screenrc`
5. Choose a color theme for Screen

## Adding a New Module

1. Create `shell/modules/my-feature.zsh`
2. Add `source "$HOME/.profileconfig/shell/modules/my-feature.zsh"` to any
   machine's zshrc that needs it

## Design Rules

- Shell files live in `shell/`. Screen files live in `screen/`. Never mix.
- Screen files contain ONLY Screen parser commands. No shell syntax.
- Modules are opt-in. Machine files explicitly source what they need.
- `core/completions.zsh` is always sourced last in zshrc.
- Terminal integrations load early in `core/interactive.zsh` to prevent re-sourcing.
- No `eval "$(brew shellenv)"` or similar slow subshells. Hardcode paths in modules.
