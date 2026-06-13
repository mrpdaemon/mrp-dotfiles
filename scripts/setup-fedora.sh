#!/usr/bin/env bash
#
# Set up a Fedora machine from these dotfiles: install packages, create
# symlinks into the repo, and configure ~/.bashrc.

set -euo pipefail

# Repo root is the parent of the directory holding this script.
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

install_packages() {
  echo "==> Enabling scottames/ghostty COPR"
  sudo dnf copr enable -y scottames/ghostty

  echo "==> Installing packages"
  sudo dnf install -y neovim tmux ghostty
}

# link <target> <link>: point <link> at <target>, creating parent dirs.
link() {
  local target="$1" link="$2"

  mkdir -p "$(dirname "$link")"

  if [[ -L "$link" && "$(readlink -f "$link")" == "$(readlink -f "$target")" ]]; then
    echo "    $link -> $target (already linked)"
    return
  fi

  ln -sfn "$target" "$link"
  echo "    $link -> $target"
}

create_symlinks() {
  echo "==> Creating symlinks"
  link "${REPO}/dotfiles/.config/nvim" "${HOME}/.config/nvim"
  link "${REPO}/dotfiles/.config/ghostty/config.ghostty" "${HOME}/.config/ghostty/config.ghostty"
  link "${REPO}/dotfiles/.tmux.conf" "${HOME}/.tmux.conf"
  link "${REPO}/dotfiles/.vimrc" "${HOME}/.vimrc"
}

configure_bashrc() {
  echo "==> Configuring ~/.bashrc"
  local bashrc="${HOME}/.bashrc"
  touch "$bashrc"

  local lines=(
    '# Use Neovim as my default editor'
    'export EDITOR=nvim'
    "alias vi='nvim'"
  )

  local line
  for line in "${lines[@]}"; do
    if grep -qxF "$line" "$bashrc"; then
      echo "    present: $line"
    else
      printf '%s\n' "$line" >> "$bashrc"
      echo "    added:   $line"
    fi
  done
}

main() {
  install_packages
  create_symlinks
  configure_bashrc
  echo "==> Done"
}

main "$@"
