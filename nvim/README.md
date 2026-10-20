# Neovim

Neovim configuration, linked to `~/.config/nvim`. Requires Neovim 0.11+ (tested on 0.12). Plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim), which bootstraps itself on first launch and installs the versions pinned in `lazy-lock.json`.

## Layout

| Path | Purpose |
|---|---|
| `init.lua` | Loads options, keymaps, then lazy.nvim. |
| `lua/config/options.lua` | Editor options. Also sets the leader key, which must happen before plugins load. |
| `lua/config/keymaps.lua` | General keymaps. Plugin keymaps live with their plugin. |
| `lua/config/lazy.lua` | lazy.nvim bootstrap and setup. |
| `lua/plugins/*.lua` | One file per plugin or closely related group. Each returns lazy.nvim specs. |
| `lazy-lock.json` | Pinned plugin commits. |
| `test/smoke.lua` | Headless smoke test (see below). |

## Plugins

| File | Plugins |
|---|---|
| `lsp.lua` | nvim-lspconfig, mason, mason-lspconfig, fidget: installs and enables `lua_ls`, `rust_analyzer`, `pyright` |
| `completion.lua`, `snippets.lua` | nvim-cmp, LuaSnip, friendly-snippets |
| `treesitter.lua` | nvim-treesitter (pinned to `master`; see the comment in the file) |
| `telescope.lua` | telescope |
| `fugitive.lua` | vim-fugitive |
| `trouble.lua` | trouble (v3) |
| `neotest.lua` | neotest with Python (pytest) and Vitest adapters |
| `database.lua` | vim-dadbod and vim-dadbod-ui |
| `quarto.lua` | quarto-nvim and otter |
| `writing.lua`, `zenmode.lua` | vim-pencil (prose filetypes only), zen-mode |
| `colorscheme.lua` | catppuccin (mocha, transparent) |
| `nvim-tmux-navigation.lua`, `undotree.lua`, `which-key.lua`, `cloak.lua`, `icons.lua`, `fun.lua` | Navigation, undo history, key hints, `.env` masking, icons, and toys |

Most plugins lazy-load on their keys, commands, or filetypes. Run `:Lazy profile` to see startup cost.

## Key mappings

Leader is `<Space>`. Press it and wait for which-key to list everything.

| Keys | Action |
|---|---|
| `<leader>pf` / `<C-p>` | Find files / git files |
| `<leader>ps` | Grep for input |
| `<leader>pws` / `<leader>pWs` | Grep for word / WORD under cursor |
| `<leader>vh` | Search help |
| `<leader>pv` | File explorer (netrw) |
| `<leader>gs` | Git status (fugitive); in it, `<leader>p` push, `<leader>P` pull |
| `gu` / `gh` | In a 3-way merge diff, take left / right |
| `<leader>tt`, `]t`, `[t` | Trouble diagnostics; next / previous item |
| `<leader>tc`, `<leader>tf`, `<leader>ts` | Run nearest test / file tests; test summary |
| `<leader>D` | Database UI (`<leader>S` runs a query) |
| `<leader>u` | Undo tree |
| `<leader>zz` / `<leader>zZ` | Zen mode / without line numbers |
| `<leader>f` | Format buffer (LSP) |
| `<leader>s` | Substitute word under cursor |
| `<leader>p` (visual), `<leader>d` | Paste / delete without overwriting the register |
| `gl` | Show diagnostic under cursor |
| `<C-h/j/k/l>` | Move between splits and tmux panes |

Neovim's built-in defaults also apply: LSP (`K`, `grn` rename, `gra` code action, `grr` references, `gri` implementation, `<C-]>` definition), diagnostics (`]d`/`[d`), and quickfix/location lists (`]q`/`[q`, `]l`/`[l`).

## Updating plugins

```bash
nvim --headless "+Lazy! update" +qa              # update and rewrite lazy-lock.json
nvim --headless -c "luafile nvim/test/smoke.lua"  # from the repo root
```

Commit `lazy-lock.json` if the smoke test passes. To roll back, use `:Lazy restore`.

## Smoke test

`test/smoke.lua` opens a file of each language, force-loads every plugin so each `config` runs, checks that prose buffers wrap and code buffers do not, checks key mappings and the colorscheme, and exits non-zero if any error was raised or echoed. CI runs it against a fresh install of the locked plugins.

## Dependencies

`nvim` 0.11+, `git`, a C compiler (treesitter parsers), `make` (LuaSnip), `ripgrep` (telescope grep), `node`/`npm` (mason installs pyright with it), and a [Nerd Font](https://www.nerdfonts.com/).

GitHub Copilot was removed when the subscription ended. To add it back, create `lua/plugins/copilot.lua` returning `{ "github/copilot.vim" }`.
