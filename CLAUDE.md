# Repository guidance

This is a personal dotfiles repo. The tracked configs live under `dotfiles/`
and are symlinked into place by `scripts/setup-fedora.sh`.

## Keep README.md up to date

`README.md` documents every config file and the setup flow. Treat it as part
of the change, not an afterthought:

- When adding, removing, or renaming a tracked dotfile, update its entry in the
  `## Contents` list.
- When changing what a config does in a way the README describes (prefix keys,
  themes, plugin set, key bindings, etc.), update that description to match.
- When changing `scripts/setup-fedora.sh` (packages installed, symlinks
  created, or `~/.bashrc` edits), update both its `## Contents` entry and the
  `## Setup` section so they stay accurate.

After making changes, re-read the relevant README sections and confirm they
still match reality before considering the task done.
