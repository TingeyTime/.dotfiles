# Git

Global git configuration, linked to `~/.config/git`. Git reads `~/.config/git/config` and `~/.config/git/ignore` automatically, so no `~/.gitconfig` is needed. This includes Git for Windows, where `~` is `%USERPROFILE%`.

## Files

| File | Purpose |
|---|---|
| `config` | Global settings, colors, URL shortcuts, and the GitHub credential helper. |
| `ignore` | Global ignore list (virtual environments, ad hoc files). |
| `template` | Commit message template with [Conventional Commits](https://www.conventionalcommits.org/) types. |
| `config.local` | Optional, untracked per-machine overrides (see below). |

## Highlights

- `pull.rebase` and `rebase.autoStash`: pulls rebase, and uncommitted work is stashed and restored automatically.
- `push.autoSetupRemote`: `git push` on a new branch sets the upstream with no `-u` needed.
- `fetch.prune`: deleted remote branches disappear locally on fetch.
- `diff.renames = copies`: detects copies as well as renames.
- `gh:` URL shortcut: `git clone gh:owner/repo` clones over SSH.
- HTTPS authentication to GitHub goes through `gh auth git-credential`.
- Status is short by default and shows stashes and every untracked file.

## Per-machine overrides

`config` includes `~/.config/git/config.local` last, so anything there wins. Because `~/.config/git` links to this folder, the file lives at `git/config.local`, which is gitignored. For example, to use a work email on a work laptop:

```ini
[user]
    email = me@work.example
```

To use it only for repos under one folder, add an `includeIf` in `config.local`:

```ini
[includeIf "gitdir:~/work/"]
    path = ~/.config/git/work.config
```

## Dependencies

`git`. Optional: `gh` (logged in with `gh auth login`) for HTTPS authentication.
