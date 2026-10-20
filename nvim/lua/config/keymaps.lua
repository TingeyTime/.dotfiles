-- General keymaps. Plugin keymaps live with their plugin in lua/plugins/.
-- Neovim's defaults already cover quickfix/location lists (]q [q ]l [l),
-- diagnostics (]d [d), and LSP (K, grn, gra, grr, gri, gO).
local map = vim.keymap.set

map("n", "<leader>pv", vim.cmd.Ex, { desc = "File explorer" })

-- Move selected lines, re-indenting and keeping the selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the cursor in place when joining lines, and centered when jumping
map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("x", "<leader>p", [["_dP]], { desc = "Paste without overwriting the register" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without overwriting the register" })

-- <C-c> leaves insert mode like <Esc> (plain <C-c> skips InsertLeave autocmds)
map("i", "<C-c>", "<Esc>")
map("n", "Q", "<nop>")

map("n", "<leader>f", vim.lsp.buf.format, { desc = "Format buffer" })
map("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostic" })

map(
    "n",
    "<leader>s",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Substitute word under cursor" }
)
map("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make file executable" })
map("n", "<leader><leader>", "<cmd>source %<CR>", { desc = "Source current file" })
