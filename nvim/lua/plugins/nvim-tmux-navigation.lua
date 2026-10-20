-- <C-h/j/k/l> moves between Neovim splits and tmux panes
-- (pairs with christoomey/vim-tmux-navigator on the tmux side).
return {
    "alexghergh/nvim-tmux-navigation",
    opts = {},
    keys = {
        { "<C-h>", "<cmd>NvimTmuxNavigateLeft<CR>", desc = "Window/pane left" },
        { "<C-j>", "<cmd>NvimTmuxNavigateDown<CR>", desc = "Window/pane down" },
        { "<C-k>", "<cmd>NvimTmuxNavigateUp<CR>", desc = "Window/pane up" },
        { "<C-l>", "<cmd>NvimTmuxNavigateRight<CR>", desc = "Window/pane right" },
    },
}
