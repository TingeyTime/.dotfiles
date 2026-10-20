# Dotfiles

My configuration for the terminal tools I use daily, on Linux and macOS.

| Folder | Tool | Linked to |
|---|---|---|
| [`bash`](bash) | Aliases and prompt setup | `~/.config/bash` |
| [`git`](git) | Global git config, ignore list, commit template | `~/.config/git` |
| [`nvim`](nvim) | Neovim with lazy.nvim | `~/.config/nvim` |
| [`starship`](starship) | Shell prompt | `~/.config/starship` |
| [`tmux`](tmux) | Tmux with TPM | `~/.config/tmux` |

Each folder has its own README covering what it configures and what it depends on.

## Install

```bash
git clone https://github.com/TingeyTime/dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` is safe to re-run. It:

1. Symlinks each folder into `~/.config`, moving any existing real file or directory to `<name>.backup.<timestamp>` first.
2. Adds one line to `~/.bashrc` that sources `bash/bashrc.sh`.
3. Clones TPM and installs the tmux plugins.
4. Lists any missing dependencies. It does not install packages.

## Machine-local settings

`~/.bashrc` is not tracked, so anything specific to one machine (PATH entries, tokens, tool setup like pyenv) belongs there rather than in this repo.
