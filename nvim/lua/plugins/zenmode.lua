return {
    "folke/zen-mode.nvim",
    keys = {
        {
            "<leader>zz",
            function()
                require("zen-mode").toggle({ window = { width = 90 } })
            end,
            desc = "Zen mode",
        },
        {
            "<leader>zZ",
            function()
                require("zen-mode").toggle({
                    window = {
                        width = 80,
                        options = { number = false, relativenumber = false },
                    },
                })
            end,
            desc = "Zen mode (no line numbers)",
        },
    },
}
