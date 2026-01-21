blakecode-linux-configs
=======================

A place for me to store all my silly linux/unix configuration files.

Installation
------------

### First Time Setup

1. Clone this repository:

   ```bash
   git clone git@github.com:Djspaceg/blakecode-linux-configs.git
   cd blakecode-linux-configs
   ```

2. Run the installation script:

   ```bash
   ./install.sh
   ```

3. Follow the prompts to:
   - Set a hostname for this machine (e.g., "CandyKingdom", "JungleFort")
   - Backup and merge any existing config files
   - Create symlinks to your home directory

4. Restart your shell or source the new config:

   ```bash
   source ~/.zshrc  # or ~/.bashrc
   ```

### What the installer does

- Prompts for a custom hostname (stored in `~/.bc-hostname`)
- Creates `machine-configs/$HOSTNAME/` for machine-specific configs
- Backs up existing config files to `~/.config-backup-TIMESTAMP/`
- Migrates existing configs to your machine-specific folder
- Creates symlinks from `~/.profileconfig` to your home directory

### Machine-Specific Configuration

After installation, customize your machine by editing files in:

```
machine-configs/$HOSTNAME/
```

These files override the base configuration for this specific machine.

Structure
---------

See [STRUCTURE.md](STRUCTURE.md) for detailed documentation on:

- File execution order for bash and zsh
- What belongs in each file (zshenv vs zshrc vs zprofile)
- Machine-specific configuration
- PATH construction
- History file management

Legacy Setup
------------

The old `./configure` script is still available but doesn't handle hostname setup or config migration. Use `./install.sh` instead.
