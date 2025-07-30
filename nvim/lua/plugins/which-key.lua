return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy", -- Load only when needed
        opts = {
            -- Default options are well-documented in the plugin's README
            -- You can customize the popup appearance and behavior here
            -- Example customizations:
            timeout = 500, -- Delay in milliseconds before showing the popup
            show_help = true,
        },
        config = function(_, opts)
            require("which-key").setup(opts)
        end
    }
}