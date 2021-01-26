blakecode-linux-configs
=======================

A place for me to store all my silly linix/unix configuration files.

Setup
-----

To get started after checking out this repo, is to run the `./configure` script. It will create a hidden folder in your home, sym-link in all of the necessary files, and sym-link those to their correct names in your actual root directory, ignoring any filenames that already exist.

For machine-specific configs, edit the "machine-configs" files. The folder name there is determined by the `~/.bc-hostname` file (if it exists) or by the `hostname` command result. This will automatically be determined each time a shell is opened.
