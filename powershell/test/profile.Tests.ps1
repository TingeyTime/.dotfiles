# Pester tests for the PowerShell profile. Run from the repo root:
#   Invoke-Pester powershell/test

BeforeDiscovery {
    $repo = Split-Path (Split-Path $PSScriptRoot)
    # Names from `alias name=...` and `name() { ... }` lines
    $bashAliases = Select-String -Path (Join-Path $repo bash aliases.sh) -Pattern '^alias ([^=]+)=', '^(\w+)\(\)' |
        ForEach-Object { $_.Matches[0].Groups[1].Value }
}

BeforeAll {
    $profilePath = Join-Path (Split-Path (Split-Path $PSScriptRoot)) powershell profile.ps1

    # Loads the profile in a new pwsh, runs $Script, and returns its output via JSON.
    # A -Command string runs at global scope, as a real profile does. A script
    # block would run one scope down, where built-in aliases like gc still win.
    function Invoke-InProfile([string] $Script) {
        $command = "`$ErrorActionPreference = 'Stop'; . '{0}'; & {{ {1} }} | ConvertTo-Json -Compress -Depth 3" -f $profilePath.Replace("'", "''"), $Script
        $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($command))
        $json = & ([Environment]::ProcessPath) -NoProfile -NonInteractive -EncodedCommand $encoded
        if ($LASTEXITCODE) { throw "pwsh exited with $LASTEXITCODE" }
        $json | ConvertFrom-Json -AsHashtable
    }
}

Describe 'profile.ps1' {
    It 'loads without errors' {
        Invoke-InProfile "'loaded'" | Should -Be 'loaded'
    }

    Context 'aliases' {
        BeforeAll {
            $commandTypes = Invoke-InProfile {
                $types = @{}
                Get-Command -CommandType Alias, Function | ForEach-Object { $types[$_.Name] = "$($_.CommandType)" }
                $types
            }
        }

        It 'defines <_> as a function, as in bash/aliases.sh' -ForEach $bashAliases {
            $commandTypes[$_] | Should -Be 'Function'
        }
    }

    Context 'arguments' {
        BeforeAll {
            # Stand-ins for git and kubectl that echo their arguments, joined by |
            $calls = Invoke-InProfile {
                function global:git { $args -join '|' }
                function global:kubectl { $args -join '|' }
                @{
                    gcm  = gcm fix the 'thing'
                    gds  = gds --stat
                    gl   = gl -3
                    gco  = gco -b feature/x
                    kcns = kcns dev
                }
            }
        }

        It 'joins gcm arguments into one message' {
            $calls.gcm | Should -Be 'commit|--message|fix the thing'
        }

        It 'passes arguments that contain spaces through intact' {
            $calls.gds | Should -Be 'diff|--output-indicator-new= |--output-indicator-old= |--staged|--stat'
            $calls.gl | Should -Be 'log|--graph|--all|--pretty=format:%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n|-3'
        }

        It 'passes flags through rather than binding them' {
            $calls.gco | Should -Be 'checkout|-b|feature/x'
            $calls.kcns | Should -Be 'config|set-context|--current|--namespace|dev'
        }
    }

    It 'moves up a directory with ..' {
        $start = New-Item -ItemType Directory (Join-Path $TestDrive a b)
        $location = Invoke-InProfile "Set-Location -LiteralPath '$($start.FullName.Replace("'", "''"))'; ..; (Get-Location).Path"
        $location | Should -Be (Split-Path $start.FullName)
    }
}
