#!/usr/bin/env bash
#
# install.sh - Neovim configuration installer
#
# DESCRIPTION:
#   Symlinks Neovim configuration from dotfiles to ~/.config/nvim
#
# USAGE:
#   ./install.sh <target-dir>
#   Example: ./install.sh $HOME/.config/nvim

set -euo pipefail

target="${1:-}"

if [[ -z "$target" ]]; then
    echo "Usage: $0 <target-dir>"
    exit 1
fi

cd "$HOME/.dotfiles"
mkdir -p "$target"
stow --restow --no-folding --ignore='^install\.sh$' --ignore='^uninstall\.sh$' -t "$target" nvim
