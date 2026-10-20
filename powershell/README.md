# PowerShell

A PowerShell 7 profile with the same aliases and prompt as [bash](../bash), for Windows, Linux, and macOS.

Linked to `~/.config/powershell`. On Linux and macOS, pwsh loads `~/.config/powershell/profile.ps1` itself, so linking is all `install.sh` does. On Windows, pwsh reads its profile from `Documents\PowerShell` instead, so `install.ps1` adds one line to `$PROFILE.CurrentUserAllHosts` that loads `profile.ps1`. Like `~/.bashrc`, that file otherwise stays machine-local.

## Files

| File | Purpose |
|---|---|
| `profile.ps1` | Entry point. Loads the aliases, sets up PSReadLine, and starts [starship](../starship) if it is installed. |
| `aliases.ps1` | The functions from [`bash/aliases.sh`](../bash/aliases.sh), with the same names. |
| `profile.local.ps1` | Optional, untracked per-machine additions (PATH entries, tokens, modules). Loaded last. |
| `test/profile.Tests.ps1` | Pester tests (see below). |

## Aliases

The same as [bash](../bash/README.md#aliases). They are functions rather than aliases, because a PowerShell alias can't include arguments. Each passes its arguments on, so `gco -b feature/x` works.

Seven of the names are built-in aliases that the profile removes: `gc` (Get-Content), `gcm` (Get-Command), `gi` (Get-Item), `gl` (Get-Location), `gm` (Get-Member), `gp` (Get-ItemProperty), and `gu` (Get-Unique). Use the full cmdlet names instead.

## Line editing

PSReadLine is set to Emacs mode on every OS, matching bash's defaults (Windows otherwise uses its own key bindings). It also adds:

- Inline suggestions from history.
- `↑`/`↓` search history for lines starting with what is already typed.
- `Tab` opens a completion menu.

## Tests

`test/profile.Tests.ps1` loads the profile in a fresh pwsh and checks three things:

- It loads without errors.
- Every alias in `bash/aliases.sh` exists here as a function and isn't shadowed by a built-in alias.
- Arguments with spaces and flags reach git unchanged.

CI runs it on Ubuntu and Windows.

```powershell
Install-Module Pester -RequiredVersion 5.6.1 -Scope CurrentUser
Invoke-Pester powershell/test
```

## Dependencies

PowerShell 7.4+ (`pwsh`, not the Windows PowerShell 5.1 that ships with Windows). Optional: `starship` and a [Nerd Font](https://www.nerdfonts.com/).
