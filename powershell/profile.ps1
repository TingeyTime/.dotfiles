#Requires -Version 7.4
# Profile for every PowerShell host. pwsh loads ~/.config/powershell/profile.ps1
# by itself on Linux and macOS; on Windows, install.ps1 hooks it into $PROFILE.

. (Join-Path $PSScriptRoot aliases.ps1)

# Bash-style line editing on every OS (Windows defaults to its own key bindings).
# PSReadLine is only loaded in interactive sessions.
if (Get-Module PSReadLine) {
    Set-PSReadLineOption -EditMode Emacs -PredictionSource History -HistorySearchCursorMovesToEnd
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
}

if (Get-Command starship -CommandType Application -ErrorAction Ignore) {
    $env:STARSHIP_CONFIG = Join-Path $HOME .config starship starship.toml
    Invoke-Expression (& starship init powershell)
}

# Per-machine additions (PATH entries, tokens, modules), untracked. Keep this last so it wins.
$localProfile = Join-Path $PSScriptRoot profile.local.ps1
if (Test-Path $localProfile) { . $localProfile }
Remove-Variable localProfile
