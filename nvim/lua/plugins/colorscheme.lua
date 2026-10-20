-- Catppuccin Mocha, matching tmux and starship.
return {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
        flavour = "mocha",
        transparent_background = true,
        term_colors = true,
        styles = {
            keywords = { "bold" },
            types = { "italic", "bold" },
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        vim.cmd.colorscheme("catppuccin")
    end,
}
