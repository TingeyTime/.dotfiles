return {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
        { "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
        {
            "]t",
            function()
                require("trouble").next({ skip_groups = true, jump = true })
            end,
            desc = "Next Trouble item",
        },
        {
            "[t",
            function()
                require("trouble").prev({ skip_groups = true, jump = true })
            end,
            desc = "Previous Trouble item",
        },
    },
}
