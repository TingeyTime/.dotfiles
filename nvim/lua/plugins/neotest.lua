return {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-neotest/nvim-nio",
        "nvim-treesitter/nvim-treesitter",
        "nvim-neotest/neotest-python",
        "marilari88/neotest-vitest",
    },
    keys = {
        {
            "<leader>tc",
            function()
                require("neotest").run.run()
            end,
            desc = "Run nearest test",
        },
        {
            "<leader>tf",
            function()
                require("neotest").run.run(vim.fn.expand("%"))
            end,
            desc = "Run tests in file",
        },
        {
            "<leader>ts",
            function()
                require("neotest").summary.toggle()
            end,
            desc = "Toggle test summary",
        },
    },
    config = function()
        require("neotest").setup({
            adapters = {
                require("neotest-python"),
                require("neotest-vitest"),
            },
        })
    end,
}
