# Bash

Shell aliases and prompt setup, layered on top of the distro's `~/.bashrc`.

Linked to `~/.config/bash`. `~/.bashrc` itself is not tracked: it stays machine-local, and `install.sh` appends one line to it that sources `bashrc.sh`.

## Files

| File | Purpose |
|---|---|
| `bashrc.sh` | Entry point. Loads the aliases and starts [starship](../starship) if it is installed. |
| `aliases.sh` | Git, Docker, Kubernetes, and directory-navigation aliases. |

## Aliases

- **Git:** `ga`, `gap` (patch add), `gc`, `gca` (amend, no edit), `gcm "msg"`, `gco`, `gn` (new branch), `gd`/`gds` (diff / staged diff), `gl` (graph log), `gs`, `gp`, `gu`
- **Docker:** `dco` (compose), `dps`, `dpa`, `dx` (exec -it)
- **Kubernetes:** `k`, `kg`, `kd`, `ka`, `kl` (logs -f), `ke` (exec -it), `kc`/`kns` (kubectx / kubens), `kcns` (set namespace)
- **Dirs:** `..`, `...`, `....`, `.....`

## Dependencies

Optional: `starship`, `docker`, `kubectl`, `kubectx`/`kubens`.
