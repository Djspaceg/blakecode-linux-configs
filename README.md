blakecode-linux-configs
=======================

A place for me to store all my silly linux/unix configuration files.

Setup
-----

To get started after checking out this repo, run the `./configure` script. It will create a hidden folder in your home (`~/.profileconfig`), sym-link in all of the necessary files to their correct names in your home directory, ignoring any filenames that already exist.

For machine-specific configs, edit files in the `machine-configs/$HOSTNAME/` folder. The folder name is determined by the `~/.bc-hostname` file (if it exists) or by the `hostname` command result.

Structure
---------

See [STRUCTURE.md](STRUCTURE.md) for detailed documentation on:
- File execution order for bash and zsh
- What belongs in each file (zshenv vs zshrc vs zprofile)
- Machine-specific configuration
- PATH construction
- History file management
