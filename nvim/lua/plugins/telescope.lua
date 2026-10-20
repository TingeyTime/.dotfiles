local function builtin(name, opts)
    return function()
        require("telescope.builtin")[name](type(opts) == "function" and opts() or opts)
    end
end

return {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    opts = {},
    keys = {
        { "<leader>pf", builtin("find_files"), desc = "Find files" },
        { "<C-p>", builtin("git_files"), desc = "Find git files" },
        {
            "<leader>ps",
            builtin("grep_string", function()
                return { search = vim.fn.input("Grep > ") }
            end),
            desc = "Grep",
        },
        {
            "<leader>pws",
            builtin("grep_string", function()
                return { search = vim.fn.expand("<cword>") }
            end),
            desc = "Grep word under cursor",
        },
        {
            "<leader>pWs",
            builtin("grep_string", function()
                return { search = vim.fn.expand("<cWORD>") }
            end),
            desc = "Grep WORD under cursor",
        },
        { "<leader>vh", builtin("help_tags"), desc = "Search help" },
    },
}
