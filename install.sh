#!/usr/bin/env bash
# Symlink each config folder into ~/.config, hook bash in, and install tmux plugins.
# Safe to re-run: existing links are replaced, real files are backed up first.
#
# Usage: ./install.sh [--uninstall] [tool...]
#   With no tools, acts on all of them. --uninstall removes only links that
#   point into this repo; backups are left for you to restore.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG="$HOME/.config"  # fixed, not $XDG_CONFIG_HOME: tmux.conf and bashrc.sh reference it
TOOLS="bash git nvim powershell starship tmux"
DEPENDENCIES="git nvim tmux starship fzf rg node lazygit gh"
SOURCE_LINE="[ -f \"$CONFIG/bash/bashrc.sh\" ] && . \"$CONFIG/bash/bashrc.sh\""

usage() {
    echo "usage: $0 [--uninstall] [tool...]"
    echo "tools: $TOOLS (default: all)"
}

# Tool lists are space-separated strings rather than arrays: empty arrays
# under `set -u` break on macOS's bash 3.2.
uninstall=false
selected=""
for arg in "$@"; do
    case "$arg" in
        --uninstall) uninstall=true ;;
        -h | --help)
            usage
            exit 0
            ;;
        *)
            if [[ " $TOOLS " != *" $arg "* ]]; then
                echo "unknown tool: $arg" >&2
                usage >&2
                exit 1
            fi
            selected="$selected $arg"
            ;;
    esac
done
selected="${selected:-$TOOLS}"

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

unlink_tool() {
    local dest="$CONFIG/$1"
    if [[ -L "$dest" && "$(readlink "$dest")" == "$DOTFILES/$1" ]]; then
        rm "$dest"
        echo "unlinked $dest"
    fi
}

# Bash: ~/.bashrc stays machine-local and sources the tracked config
hook_bash() {
    if ! grep -qxF "$SOURCE_LINE" "$HOME/.bashrc" 2>/dev/null; then
        echo "$SOURCE_LINE" >>"$HOME/.bashrc"
        echo "added source line to ~/.bashrc"
    fi
}

unhook_bash() {
    if grep -qxF "$SOURCE_LINE" "$HOME/.bashrc" 2>/dev/null; then
        local tmp
        tmp="$(mktemp)"
        grep -vxF "$SOURCE_LINE" "$HOME/.bashrc" >"$tmp" || true
        cat "$tmp" >"$HOME/.bashrc" # rewrite in place to keep the file's permissions
        rm "$tmp"
        echo "removed source line from ~/.bashrc"
    fi
}

install_tmux_plugins() {
    command -v tmux >/dev/null || return 0
    local tpm_dir="$CONFIG/tmux/plugins/tpm"
    [[ -d "$tpm_dir" ]] || git clone --depth 1 https://github.com/tmux-plugins/tpm "$tpm_dir"
    # TPM needs a running server; use a throwaway session so existing sessions are untouched
    tmux has-session -t tpm-install 2>/dev/null || tmux new-session -d -s tpm-install
    "$tpm_dir/bin/install_plugins"
    tmux kill-session -t tpm-install
}

if $uninstall; then
    for tool in $selected; do
        unlink_tool "$tool"
        if [[ "$tool" == bash ]]; then unhook_bash; fi
    done
    exit 0
fi

mkdir -p "$CONFIG"
for tool in $selected; do
    link "$DOTFILES/$tool" "$CONFIG/$tool"
    case "$tool" in
        bash) hook_bash ;;
        tmux) install_tmux_plugins ;;
    esac
done

# Dependencies are only reported, not installed
missing=""
for cmd in $DEPENDENCIES; do
    command -v "$cmd" >/dev/null || missing="$missing $cmd"
done
[[ -z "$missing" ]] || echo "missing dependencies:$missing"
