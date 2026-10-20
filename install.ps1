#Requires -Version 7.4
<#
.SYNOPSIS
Links each config folder into place on Windows and hooks PowerShell in.

.DESCRIPTION
The Windows counterpart of install.sh. Safe to re-run: existing links are
replaced, real files are backed up first. Links are directory junctions, which
need neither admin rights nor Developer Mode.

bash and tmux are left out: neither runs natively on Windows (use WSL, where
install.sh works as on Linux).

.PARAMETER Tools
Tools to act on: git, nvim, powershell, starship. Defaults to all of them.

.PARAMETER Uninstall
Remove only links that point into this repo, and the $PROFILE line. Backups are
left for you to restore.

.EXAMPLE
./install.ps1

.EXAMPLE
./install.ps1 -Uninstall nvim
#>
[CmdletBinding()]
param(
    [switch] $Uninstall,
    [Parameter(Position = 0, ValueFromRemainingArguments)]
    [string[]] $Tools
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $IsWindows) {
    throw 'install.ps1 is for Windows. On Linux and macOS, run install.sh.'
}

$Dotfiles = $PSScriptRoot
# From the environment rather than $HOME, so CI can point them at a fresh home
$Config = Join-Path $env:USERPROFILE .config
$Destinations = [ordered]@{
    git        = Join-Path $Config git
    nvim       = Join-Path $env:LOCALAPPDATA nvim  # Neovim on Windows ignores ~/.config
    powershell = Join-Path $Config powershell
    starship   = Join-Path $Config starship
}
# Commands to check for, and the winget package that provides each
$Dependencies = [ordered]@{
    git      = 'Git.Git'
    nvim     = 'Neovim.Neovim'
    starship = 'Starship.Starship'
    fzf      = 'junegunn.fzf'
    rg       = 'BurntSushi.ripgrep.MSVC'
    node     = 'OpenJS.NodeJS.LTS'
    lazygit  = 'JesseDuffield.lazygit'
    gh       = 'GitHub.cli'
}
$TrackedProfile = Join-Path $Config powershell profile.ps1
$ProfileHook = "if (Test-Path '{0}') {{ . '{0}' }}" -f $TrackedProfile.Replace("'", "''")

foreach ($tool in $Tools) {
    if ($tool -in 'bash', 'tmux') {
        throw "$tool doesn't run natively on Windows. Use WSL and install.sh for it."
    }
    if (-not $Destinations.Contains($tool)) {
        throw "unknown tool: $tool (tools: $($Destinations.Keys -join ', '))"
    }
}
if (-not $Tools) { $Tools = @($Destinations.Keys) }

# The target of the link at $Path, or $null if $Path isn't a link. Reads the link
# itself, so a link whose target is gone is still found.
function Get-LinkTarget([string] $Path) {
    $item = [IO.DirectoryInfo]::new($Path)
    if ($item.Exists -and $item.LinkTarget) {
        # Junction targets can be stored in NT form, \??\C:\...
        $target = $item.LinkTarget -replace '^\\\?\?\\', ''
        [IO.Path]::TrimEndingDirectorySeparator([IO.Path]::GetFullPath($target))
    }
}

function Install-Link([string] $Source, [string] $Destination) {
    if ($null -ne (Get-LinkTarget $Destination)) {
        # Delete() without recursion removes the junction, not what it points to
        [IO.DirectoryInfo]::new($Destination).Delete()
    } elseif (Test-Path -LiteralPath $Destination) {
        $backup = "$Destination.backup.$(Get-Date -Format yyyyMMddHHmmss)"
        Move-Item -LiteralPath $Destination $backup
        Write-Host "backed up $Destination -> $backup"
    }
    New-Item -ItemType Directory -Force (Split-Path $Destination) | Out-Null
    New-Item -ItemType Junction -Path $Destination -Target $Source | Out-Null
    Write-Host "linked $Destination -> $Source"
}

function Uninstall-Link([string] $Source, [string] $Destination) {
    if ((Get-LinkTarget $Destination) -eq $Source) {
        [IO.DirectoryInfo]::new($Destination).Delete()
        Write-Host "unlinked $Destination"
    }
}

# PowerShell: $PROFILE stays machine-local and loads the tracked profile. The
# all-hosts profile also covers VS Code's PowerShell terminal.
function Install-ProfileHook {
    $path = $PROFILE.CurrentUserAllHosts
    $lines = @(if (Test-Path $path) { Get-Content $path })
    if ($ProfileHook -cnotin $lines) {
        New-Item -ItemType Directory -Force (Split-Path $path) | Out-Null
        [IO.File]::WriteAllLines($path, [string[]]($lines + $ProfileHook))
        Write-Host "added profile.ps1 to $path"
    }
}

function Uninstall-ProfileHook {
    $path = $PROFILE.CurrentUserAllHosts
    $lines = @(if (Test-Path $path) { Get-Content $path })
    if ($ProfileHook -cin $lines) {
        [IO.File]::WriteAllLines($path, [string[]]@($lines | Where-Object { $_ -cne $ProfileHook }))
        Write-Host "removed profile.ps1 from $path"
    }
}

foreach ($tool in $Tools) {
    $source = Join-Path $Dotfiles $tool
    if ($Uninstall) {
        Uninstall-Link $source $Destinations[$tool]
        if ($tool -eq 'powershell') { Uninstall-ProfileHook }
    } else {
        Install-Link $source $Destinations[$tool]
        if ($tool -eq 'powershell') { Install-ProfileHook }
    }
}
if ($Uninstall) { exit }

# Dependencies are only reported, not installed
$missing = @($Dependencies.Keys | Where-Object { -not (Get-Command $_ -CommandType Application -ErrorAction Ignore) })
if ($missing) {
    Write-Host "missing dependencies: $($missing -join ' ')"
    Write-Host "install with: winget install $(($missing | ForEach-Object { $Dependencies[$_] }) -join ' ')"
}
