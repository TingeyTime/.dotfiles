# Starship

Prompt configuration for [starship](https://starship.rs), linked to `~/.config/starship`. Because it lives in a subfolder rather than at `~/.config/starship.toml`, the shell must set `STARSHIP_CONFIG`. [`bash/bashrc.sh`](../bash/bashrc.sh) and [`powershell/profile.ps1`](../powershell/profile.ps1) do this.

## Prompt

A powerline-style prompt using the Catppuccin Mocha palette, matching nvim and tmux. Left to right:

OS icon and user → directory → git branch and status → language versions (C, Rust, Go, Node, PHP, Java, Kotlin, Haskell, Python) → Docker context → time

The input prompt sits on its own line and changes shape in vi mode.

## Editing

Every color must be a key in `[palettes.catppuccin_mocha]` or a hex value. Starship drops unknown colors without a warning, and the segment renders unstyled.

## Dependencies

`starship` and a [Nerd Font](https://www.nerdfonts.com/) for the icons and separators.
