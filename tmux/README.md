# Tmux

Tmux configuration, linked to `~/.config/tmux` (tmux 3.1+ reads `~/.config/tmux/tmux.conf`). Plugins are managed by [TPM](https://github.com/tmux-plugins/tpm), which `install.sh` clones into `plugins/` (gitignored) and uses to install the plugins.

## Behavior

- Windows and panes are numbered from 1, and windows renumber when one closes.
- The status bar is at the top: session on the left, current directory and time on the right, themed with Catppuccin Mocha.
- New splits open in the current pane's directory.
- Closing the last window in a session switches to another session instead of detaching.

## Key bindings

Prefix is the default `C-b`.

| Keys | Action |
|---|---|
| `prefix r` | Reload config |
| `prefix h/j/k/l` | Select pane |
| `prefix ←/↓/↑/→` | Resize pane by 5 (repeatable) |
| `M-H` / `M-L` | Previous / next window (no prefix) |
| `prefix b` | Previous window |
| `prefix C-y` | lazygit popup |
| `prefix C-n` | New session popup |
| `prefix C-j` | Switch session (fzf) |
| `prefix C-t` | Shell popup in current directory |
| `prefix C-p` | IPython popup |
| `prefix d` | Menu to edit tmux.conf, aliases, or the nvim config |
| `C-h/j/k/l` | Move between panes and nvim splits (vim-tmux-navigator) |

## Plugins

tmux-sensible, vim-tmux-navigator, and catppuccin/tmux pinned to `v2.3.2`. Catppuccin is pinned because v2 changed every option name, and an unpinned upgrade silently reverted the theme. To upgrade, bump the tag, check the [changelog](https://github.com/catppuccin/tmux/blob/main/CHANGELOG.md), and run `prefix U`.

## Dependencies

`tmux` 3.1+, `git` (TPM), and a [Nerd Font](https://www.nerdfonts.com/). Optional: `lazygit`, `fzf`, `ipython` for the popups.
