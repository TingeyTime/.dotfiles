# Dotfiles

[![CI](https://github.com/TingeyTime/.dotfiles/actions/workflows/ci.yml/badge.svg)](https://github.com/TingeyTime/.dotfiles/actions/workflows/ci.yml)

My configuration for the terminal tools I use daily, on Linux, macOS, and Windows.

| Folder | Tool | Linked to |
|---|---|---|
| [`bash`](bash) | Aliases and prompt setup | `~/.config/bash` |
| [`git`](git) | Global git config, ignore list, commit template | `~/.config/git` |
| [`nvim`](nvim) | Neovim with lazy.nvim, native LSP, and a smoke test | `~/.config/nvim` (Windows: `%LOCALAPPDATA%\nvim`) |
| [`powershell`](powershell) | PowerShell 7 profile with the bash aliases and prompt | `~/.config/powershell` |
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

### Windows

In PowerShell 7 (`winget install Microsoft.PowerShell`), not Windows PowerShell 5.1:

```powershell
git clone https://github.com/TingeyTime/.dotfiles.git ~/.dotfiles
~/.dotfiles/install.ps1
```

`install.ps1` works like `install.sh`, with three differences:

1. It links with directory junctions, which need neither admin rights nor Developer Mode.
2. It adds one line to `$PROFILE.CurrentUserAllHosts` that loads `powershell/profile.ps1`, in place of the `~/.bashrc` line.
3. It skips bash and tmux, which don't run natively on Windows. Missing dependencies are listed with the `winget install` command for them.

```powershell
./install.ps1 nvim git          # install just these
./install.ps1 -Uninstall nvim   # remove the nvim link
Get-Help ./install.ps1          # full usage
```

Under WSL, use `install.sh` as on Linux.

## Machine-local settings

Anything specific to one machine stays out of the repo:

- **Shell:** `~/.bashrc` is untracked. Put PATH entries, tokens, and tool setup (pyenv, Homebrew) there.
- **PowerShell:** `powershell/profile.local.ps1` is gitignored and loaded last. On Windows, `$PROFILE` itself is also untracked.
- **Git:** `git/config.local` is gitignored and included last, so it can override your identity, e.g. a work email. See [git/README.md](git/README.md#per-machine-overrides).

## Design decisions

- **A symlink script instead of a dotfiles manager.** With six tools and three OSes, a short `install.sh`, plus `install.ps1` for Windows, is easier to read and debug than stow, chezmoi, or Nix. Machine-specific settings go through the local files above instead of templating. If those differences grow, [chezmoi](https://www.chezmoi.io/) is the next step.
- **XDG layout.** Every tool reads from `~/.config/<tool>`, so each folder links in whole and nothing is scattered across `$HOME`.
- **Pinned versions.** `lazy-lock.json` and the catppuccin/tmux tag mean upgrades happen when I choose, as reviewable diffs, rather than whenever a machine is set up.
- **One theme.** Catppuccin Mocha across Neovim, tmux, and starship.
- **PowerShell as a tool, Windows as a platform.** The PowerShell profile is cross-platform and installs on Linux and macOS too, so it is tested on Ubuntu as well as Windows. Only `install.ps1` is Windows-specific. Aliases are kept in two files (`bash/aliases.sh`, `powershell/aliases.ps1`) rather than generated from one, and a test fails if they drift.
- **Native Windows only where it pays.** git, Neovim, starship, and PowerShell run natively. bash and tmux are left to WSL rather than emulated through Git Bash or MSYS.

## Development

CI ([`.github/workflows/ci.yml`](.github/workflows/ci.yml)) runs on every push:

| Check | Locally |
|---|---|
| `shellcheck` on shell scripts | `shellcheck -x install.sh bash/*.sh` |
| `stylua` formatting for Lua (config in `.stylua.toml`) | `stylua --check nvim/` |
| PSScriptAnalyzer on PowerShell scripts (config in `PSScriptAnalyzerSettings.psd1`) | `Invoke-ScriptAnalyzer -Path install.ps1 -Settings ./PSScriptAnalyzerSettings.psd1` |
| Pester tests for the PowerShell profile, on Ubuntu and Windows | `Invoke-Pester powershell/test` |
| `install.sh` on Ubuntu and macOS in a fresh home, run twice | `HOME=$(mktemp -d) ./install.sh` |
| `install.ps1` on Windows in a fresh home, run twice, then uninstalled | CI only: a local run edits your real `$PROFILE` |
| Neovim smoke test on a fresh plugin install, on Ubuntu and Windows | `nvim --headless -c "luafile nvim/test/smoke.lua"` |

Commits follow [Conventional Commits](https://www.conventionalcommits.org/); `git/template` is the commit template.
