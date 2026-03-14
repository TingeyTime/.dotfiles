#!/usr/bin/env bash
#
# uninstall.sh - Tmux configuration uninstaller
#
# DESCRIPTION:
#   Removes symlinks for Tmux configuration from target directory
#   Note: TPM plugins are not removed to avoid data loss
#
# USAGE:
#   ./uninstall.sh <target-dir>
#   Example: ./uninstall.sh $HOME

set -euo pipefail

target="${1:-}"

if [[ -z "$target" ]]; then
    echo "Usage: $0 <target-dir>"
    exit 1
fi

cd "$HOME/.dotfiles"
stow --delete -t "$target" tmux
