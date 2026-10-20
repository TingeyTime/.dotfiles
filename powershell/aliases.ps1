# Port of bash/aliases.sh. PowerShell aliases can't take arguments, so each one
# is a function that passes @args on. test/profile.Tests.ps1 checks that every
# bash alias has a function here, so add new ones to both files.

# These built-in aliases (gc = Get-Content, gl = Get-Location, ...) would win
# over functions of the same name.
foreach ($name in 'gc', 'gcm', 'gi', 'gl', 'gm', 'gp', 'gu') {
    Remove-Item "Alias:$name" -Force -ErrorAction Ignore
}
Remove-Variable name

# Git
function ga { git add @args }
function gap { git add --patch @args }
function gb { git branch @args }
function gba { git branch --all @args }
function gc { git commit @args }
function gca { git commit --amend --no-edit @args }
function gce { git commit --amend @args }
function gco { git checkout @args }
function gcl { git clone --recursive @args }
function gd { git diff '--output-indicator-new= ' '--output-indicator-old= ' @args }
function gds { gd --staged @args }
function gi { git init @args }
function gl { git log --graph --all '--pretty=format:%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n' @args }
function gm { git merge @args }
function gn { git checkout -b @args }  # new branch
function gp { git push @args }
function gr { git reset @args }
function gs { git status --short @args }
function gu { git pull @args }

function gcm { git commit --message "$args" }

# Docker
function dco { docker compose @args }
function dps { docker ps @args }
function dpa { docker ps -a @args }
function dl { docker ps -l -q @args }
function dx { docker exec -it @args }

# Dirs
function .. { Set-Location .. }
function ... { Set-Location ../.. }
function .... { Set-Location ../../.. }
function ..... { Set-Location ../../../.. }

function cl { Clear-Host }

# Kubernetes
function k { kubectl @args }
function ka { kubectl apply -f @args }
function kg { kubectl get @args }
function kd { kubectl describe @args }
function kdel { kubectl delete @args }
function kl { kubectl logs -f @args }
function kgpo { kubectl get pod @args }
function kgd { kubectl get deployments @args }
function ke { kubectl exec -it @args }
function kc { kubectx @args }
function kns { kubens @args }
function kcns { kubectl config set-context --current --namespace @args }
