# Configuration Architecture

This repository manages shell and terminal configurations across multiple machines using a layered inheritance model.

## Core Principle: Global + Machine-Specific

Every configuration file follows this pattern:

1. **Global version** (in repo root) - shared defaults for all machines
2. **Machine-specific version** (in `machine-configs/$HOSTNAME/`) - augments or overrides global

The global file is responsible for sourcing the machine-specific version when it exists.

## File Hierarchy

```
~/.profileconfig/              (symlink to this repo)
├── [config-file]              Global version, symlinked to ~/.[config-file]
├── scripts/
│   ├── prepare-rc-files.zsh   Bootstraps functions and sets HOSTNAME (zsh)
│   ├── prepare-rc-files.sh    Bootstraps variables for bash (no autoload)
│   └── shell_aliases.sh       Shared aliases for bash/zsh
├── functions/                 Autoloaded shell functions (zsh only)
└── machine-configs/
    └── $HOSTNAME/
        └── [config-file]      Machine-specific overrides
```

## Execution Flow

### Shell Startup (zsh)

```
1. ~/.zshenv (symlink → zshenv)
   └── sources scripts/prepare-rc-files.zsh
       ├── Sets PROFILECONFIGDIR, HOSTNAME, MACHINECONFIGDIR
       ├── Adds functions/ to FPATH
       └── Autoloads: custom_hostname, source_machine_version, etc.
   └── calls source_machine_version zshenv
       └── sources machine-configs/$HOSTNAME/zshenv (if exists)

2. ~/.zprofile (symlink → zprofile)
   └── calls source_machine_version zprofile

3. ~/.zshrc (symlink → zshrc)
   └── sources scripts/shell_aliases.sh
   └── calls source_machine_version zshrc
```

### Screen Startup

```
1. screen command runs
2. ~/.screenrc (symlink → screenrc)
   ├── Sets HOSTNAME, PROFILECONFIGDIR, MACHINECONFIGDIR (screen can't use zsh functions)
   ├── Defines hardstatus, keybindings, colors
   └── sources machine-configs/$HOSTNAME/screenrc
       └── sources screenrc-tabs (machine-specific)
           └── Defines window tabs/layout
```

### Screen Spawns New Shell

```
1. Screen creates new window
2. Shell startup sequence repeats (zshenv → zprofile → zshrc)
3. WINDOW environment variable is set by screen
4. History file may be per-window based on $WINDOW
```

## Key Variables

| Variable | Set By | Purpose |
|----------|--------|---------|
| `HOSTNAME` | custom_hostname function | Machine identifier from ~/.bc-hostname |
| `PROFILECONFIGDIR` | prepare-rc-files.zsh | Path to this repo (~/.profileconfig) |
| `MACHINECONFIGDIR` | prepare-rc-files.zsh | Path to machine-configs/$HOSTNAME |
| `WINDOW` | screen | Current screen window number |

## Adding Machine-Specific Config

1. Create `~/.bc-hostname` with your machine name
2. Create folder: `machine-configs/[hostname]/`
3. Add only the files you need to customize
4. Machine files augment globals - don't duplicate shared config

## Common Issues

### Colors not working in screen

- Add `term screen-256color` to machine screenrc
- Ensure terminal supports 256 colors before starting screen

### Functions not available

- Check that prepare-rc-files.zsh is sourced early in zshenv
- Verify FPATH includes the functions directory

### Machine config not loading

- Verify ~/.bc-hostname exists and matches folder name exactly
- Check HOSTNAME variable: `echo $HOSTNAME`
