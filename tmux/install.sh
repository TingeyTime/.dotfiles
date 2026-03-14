#!/usr/bin/env bash
#
# install.sh - Tmux configuration installer
#
# DESCRIPTION:
#   Symlinks Tmux configuration from dotfiles to $HOME and installs
#   the Tmux Plugin Manager (TPM) if not already present.
#
# USAGE:
#   ./install.sh <target-dir>
#   Example: ./install.sh $HOME

set -euo pipefail

target="${1:-}"

if [[ -z "$target" ]]; then
    echo "Usage: $0 <target-dir>"
    exit 1
fi

cd "$HOME/.dotfiles"

# Install TPM (Tmux Plugin Manager) if not present
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo "==> Installing TMUX plugin manager (TPM)"
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

mkdir -p "$target"
stow --restow --no-folding --ignore='^install\.sh$' --ignore='^uninstall\.sh$' -t "$target" tmux

# Reload tmux config to apply changes
echo "==> Sourcing tmux config"
tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
