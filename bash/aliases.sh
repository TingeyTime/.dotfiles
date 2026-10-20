# shellcheck shell=bash
# Git
alias ga='git add'
alias gap='ga --patch'
alias gb='git branch'
alias gba='gb --all'
alias gc='git commit'
alias gca='gc --amend --no-edit'
alias gce='gc --amend'
alias gco='git checkout'
alias gcl='git clone --recursive'
alias gd='git diff --output-indicator-new=" " --output-indicator-old=" "'
alias gds='gd --staged'
alias gi='git init'
alias gl='git log --graph --all --pretty=format:"%C(magenta)%h %C(white) %an  %ar%C(blue)  %D%n%s%n"'
alias gm='git merge'
alias gn='git checkout -b'  # new branch
alias gp='git push'
alias gr='git reset'
alias gs='git status --short'
alias gu='git pull'

gcm() { git commit --message "$*"; }

# Docker
alias dco='docker compose'
alias dps='docker ps'
alias dpa='docker ps -a'
alias dl='docker ps -l -q'
alias dx='docker exec -it'

# Dirs
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias cl='clear'

# Kubernetes
alias k='kubectl'
alias ka='kubectl apply -f'
alias kg='kubectl get'
alias kd='kubectl describe'
alias kdel='kubectl delete'
alias kl='kubectl logs -f'
alias kgpo='kubectl get pod'
alias kgd='kubectl get deployments'
alias ke='kubectl exec -it'
alias kc='kubectx'
alias kns='kubens'
alias kcns='kubectl config set-context --current --namespace'
