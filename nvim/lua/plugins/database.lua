-- Database client. In a query buffer opened from the UI, <leader>S runs the query.
return {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        { "tpope/vim-dadbod", lazy = true },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    keys = {
        { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Database UI" },
    },
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
    end,
}
