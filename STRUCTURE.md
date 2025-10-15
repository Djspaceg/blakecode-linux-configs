# Shell Configuration Structure

This document explains the organization and execution flow of shell configuration files.

## File Execution Order

### Zsh Shells

**Login Shell** (e.g., initial terminal, SSH login):
1. `zshenv` → Environment variables (runs for ALL zsh invocations)
2. `zprofile` → Login-specific setup
3. `zshrc` → Interactive features (aliases, prompt, etc.)

**Non-Login Interactive Shell** (e.g., screen, tmux, new terminal tab):
1. `zshenv` → Environment variables
2. `zshrc` → Interactive features

**Non-Interactive Shell** (e.g., scripts, background processes):
1. `zshenv` → Environment variables only

### Bash Shells

**Login Shell**:
1. `bash_profile` → Sources bashrc, then loads machine-specific bash_profile

**Interactive Non-Login Shell**:
1. `bashrc` → Sources bash_env, loads shared aliases, interactive features

**Non-Interactive Shell**:
- Typically doesn't source any of these files

## File Purposes

### Environment Files (Run for ALL shells)

**`zshenv`** / **`bash_env`**
- Platform detection (PLAT_MAC, PLAT_LINUX, PLAT_NIX)
- PROFILECONFIGDIR setup
- Loads machine-specific environment
- **NO output** (breaks rsync, scp, etc.)
- **NO interactive features**

### Login Files (Run for LOGIN shells only)

**`zprofile`** / **`bash_profile`**
- Login-specific initialization
- Can have output (echo statements OK)
- Loads machine-specific login config

### Interactive Files (Run for INTERACTIVE shells)

**`zshrc`** / **`bashrc`**
- Prompt configuration
- Aliases and functions
- History settings
- Keybindings
- Color settings
- Loads shared aliases from `shell_aliases`
- Loads machine-specific interactive config

### Shared Files

**`shell_aliases.sh`**
- Common aliases for both bash and zsh
- Sourced by both bashrc and zshrc
- Platform-specific aliases using PLAT_* variables

**`prepare-rc-files.sh`**
- Sets up FPATH for functions
- Autoloads custom functions
- Calls custom_hostname
- Sets MACHINECONFIGDIR

## Machine-Specific Configs

Located in `machine-configs/$HOSTNAME/`

Each machine can have:
- `zshenv` / `bash_env` - Machine-specific environment variables
- `zprofile` / `bash_profile` - Machine-specific login setup
- `zshrc` / `bashrc` - Machine-specific aliases and functions
- `screenrc` - Machine-specific screen configuration
- `screenrc-tabs` - Machine-specific screen tab layout

## Directory Structure

```
~/.profileconfig/                    (symlink to repo)
├── zshenv                           → ~/.zshenv
├── zprofile                         → ~/.zprofile
├── zshrc                            → ~/.zshrc
├── bash_env                         → ~/.bash_env
├── bash_profile                     → ~/.bash_profile
├── bashrc                           → ~/.bashrc
├── shell_aliases.sh                 (shared, not symlinked to ~)
├── screenrc                         → ~/.screenrc
├── prepare-rc-files.sh
├── functions/
│   ├── custom_hostname
│   ├── source_machine_version
│   ├── source_optional
│   └── set-title
└── machine-configs/
    └── $HOSTNAME/
        ├── zshenv
        ├── zprofile
        ├── zshrc
        ├── bash_env
        ├── bash_profile
        ├── bashrc
        └── screenrc
```

## History Files

History is shared across all sessions except screen windows:
- Zsh: `~/.zsh_history` (shared) or `~/.zsh_history.window.$WINDOW` (screen)
- Bash: `~/.bash_history` (shared) or `~/.bash_history.window.$WINDOW` (screen)
- Screen windows ($WINDOW) get separate history files
- All other shells/terminals/tabs share one history file per shell type

## Best Practices

1. **Environment variables** → `zshenv` / `bash_env`
2. **Login setup** (one-time) → `zprofile` / `bash_profile`
3. **Interactive features** → `zshrc` / `bashrc`
4. **Shared aliases** → `shell_aliases.sh`
5. **Machine-specific** → `machine-configs/$HOSTNAME/`

## PATH Construction

PATH is built in layers:
1. `zshenv` / `bash_env` - Base system paths
2. Machine-specific `zshenv` / `bash_env` - Machine-specific paths (toolbox, node, etc.)
3. Machine-specific `zprofile` / `bash_profile` - Login paths (Homebrew, etc.)

Each layer **appends** to PATH to avoid shadowing.
