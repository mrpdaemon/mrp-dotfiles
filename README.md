mrp-dotfiles
============

My personal dotfiles.

## Contents

- `dotfiles/.vimrc` — Vim configuration using Vundle for plugin management.
  Sets up the `xoria256` colorscheme, 3-space indentation, and a curated set
  of plugins (NERDTree, fugitive, tagbar, airline, CtrlP, fzf, ag, gitgutter,
  syntastic, ultisnips, clang-format, augment, etc.) with `,` as the leader
  key.
- `dotfiles/.config/nvim/` — Neovim configuration using `lazy.nvim` for
  plugin management. Mirrors the Vim setup with the `xoria256` colorscheme,
  3-space indentation, and lazy-loaded equivalents of the same plugin set
  (NERDTree, fugitive, gitgutter, tagbar, CtrlP, fzf, ag,
  airline/bufferline, clang-format, jsonnet). Symlink the whole directory
  to `~/.config/nvim` so the `lua/mrp/*` local modules (e.g.
  `lua/mrp/gitdiff.lua`, a fugitive-based git diff workflow exposing
  `<leader>gd` and `<leader>q`) are on Neovim's `runtimepath`.
- `dotfiles/.tmux.conf` — tmux configuration. Uses `C-a` as the prefix,
  enables mouse and system-clipboard support, sets a 256-color terminal and
  10k-line scrollback, vim-style pane navigation, an SSH-agent-forwarding
  workaround via `~/.ssh/ssh_auth_sock`, and a `prefix + u` binding to spawn
  a two-pane dev window via `~/bin/tmux-new-dev-window`.
