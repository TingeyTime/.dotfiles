# Dotfiles

[![CI](https://github.com/TingeyTime/.dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/TingeyTime/.dotfiles/actions/workflows/ci.yml)

My configuration for the terminal tools I use daily, on Linux and macOS.

| Folder | Tool | Linked to |
|---|---|---|
| [`bash`](bash) | Aliases and prompt setup | `~/.config/bash` |
| [`git`](git) | Global git config, ignore list, commit template | `~/.config/git` |
| [`nvim`](nvim) | Neovim with lazy.nvim, native LSP, and a smoke test | `~/.config/nvim` |
| [`starship`](starship) | Shell prompt | `~/.config/starship` |
| [`tmux`](tmux) | Tmux with TPM | `~/.config/tmux` |

Each folder has its own README covering what it configures, its key bindings, and its dependencies.

## Install

```bash
git clone https://github.com/TingeyTime/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.sh
```

`install.sh` is safe to re-run. It:

1. Symlinks each folder into `~/.config`, moving any existing real file or directory to `<name>.backup.<timestamp>` first.
2. Adds one line to `~/.bashrc` that sources `bash/bashrc.sh`.
3. Clones TPM and installs the tmux plugins, using a throwaway tmux session so open sessions are untouched.
4. Lists any missing dependencies. It does not install packages.

Neovim installs its plugins, at the versions in `nvim/lazy-lock.json`, on first launch.

To act on only some tools, name them. `--uninstall` removes only links that point into this repo (and the `~/.bashrc` line, for `bash`); backups are left for you to restore.

```bash
./install.sh nvim tmux          # install just these
./install.sh --uninstall nvim   # remove the nvim link
./install.sh --uninstall        # remove everything
```

## Machine-local settings

Anything specific to one machine stays out of the repo:

- **Shell:** `~/.bashrc` is untracked. Put PATH entries, tokens, and tool setup (pyenv, Homebrew) there.
- **Git:** `git/config.local` is gitignored and included last, so it can override your identity, e.g. a work email. See [git/README.md](git/README.md#per-machine-overrides).

## Design decisions

- **A symlink script instead of a dotfiles manager.** With five tools and two OSes, a short `install.sh` is easier to read and debug than stow, chezmoi, or Nix. Machine-specific settings go through the local files above instead of templating. If those differences grow, [chezmoi](https://www.chezmoi.io/) is the next step.
- **XDG layout.** Every tool reads from `~/.config/<tool>`, so each folder links in whole and nothing is scattered across `$HOME`.
- **Pinned versions.** `lazy-lock.json` and the catppuccin/tmux tag mean upgrades happen when I choose, as reviewable diffs, rather than whenever a machine is set up.
- **One theme.** Catppuccin Mocha across Neovim, tmux, and starship.

## Development

CI ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) runs on every push:

| Check | Locally |
|---|---|
| `shellcheck` on shell scripts | `shellcheck -x install.sh bash/*.sh` |
| `stylua` formatting for Lua (config in `.stylua.toml`) | `stylua --check nvim/` |
| `install.sh` on Ubuntu and macOS in a fresh home, run twice | `HOME=$(mktemp -d) ./install.sh` |
| Neovim smoke test on a fresh plugin install | `nvim --headless -c "luafile nvim/test/smoke.lua"` |

Commits follow [Conventional Commits](https://www.conventionalcommits.org/); `git/template` is the commit template.
