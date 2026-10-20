#!/usr/bin/env bash
# Symlink each config folder into ~/.config, hook bash in, and install tmux plugins.
# Safe to re-run: existing links are replaced, real files are backed up first.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"  # fixed, not $XDG_CONFIG_HOME: tmux.conf and bashrc.sh reference it
PACKAGES=(bash git nvim starship tmux)
DEPENDENCIES=(git nvim tmux starship fzf rg node lazygit gh)

link() {
    local src="$1" dest="$2"
    if [[ -e "$dest" && ! -L "$dest" ]]; then
        local backup
        backup="$dest.backup.$(date +%Y%m%d%H%M%S)"
        mv "$dest" "$backup"
        echo "backed up $dest -> $backup"
    fi
    ln -sfn "$src" "$dest"
    echo "linked $dest -> $src"
}

# Configs
mkdir -p "$CONFIG"
for pkg in "${PACKAGES[@]}"; do
    link "$DOTFILES/$pkg" "$CONFIG/$pkg"
done

# Bash: ~/.bashrc stays machine-local and sources the tracked config
source_line="[ -f \"$CONFIG/bash/bashrc.sh\" ] && . \"$CONFIG/bash/bashrc.sh\""
if ! grep -qxF "$source_line" "$HOME/.bashrc" 2>/dev/null; then
    echo "$source_line" >> "$HOME/.bashrc"
    echo "added source line to ~/.bashrc"
fi

# Tmux plugins (TPM)
if command -v tmux >/dev/null; then
    tpm_dir="$CONFIG/tmux/plugins/tpm"
    [[ -d "$tpm_dir" ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
    # TPM needs a running server; use a throwaway session so existing sessions are untouched
    tmux has-session -t tpm-install 2>/dev/null || tmux new-session -d -s tpm-install
    "$tpm_dir/bin/install_plugins"
    tmux kill-session -t tpm-install
fi

# Dependencies are only reported, not installed
missing=""
for cmd in "${DEPENDENCIES[@]}"; do
    command -v "$cmd" >/dev/null || missing="$missing $cmd"
done
[[ -z "$missing" ]] || echo "missing dependencies:$missing"
