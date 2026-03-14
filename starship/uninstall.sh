#!/usr/bin/env bash
#
# uninstall.sh - Starship prompt uninstaller
#
# DESCRIPTION:
#   Removes symlinks for Starship configuration from target directory
#
# USAGE:
#   ./uninstall.sh <target-dir>
#   Example: ./uninstall.sh $HOME/.config

set -euo pipefail

target="${1:-}"

if [[ -z "$target" ]]; then
    echo "Usage: $0 <target-dir>"
    exit 1
fi

cd "$HOME/.dotfiles"
stow --delete -t "$target" starship
