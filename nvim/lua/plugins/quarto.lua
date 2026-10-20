-- Quarto documents: LSP features inside code chunks via otter.nvim.
return {
    "quarto-dev/quarto-nvim",
    ft = "quarto",
    dependencies = {
        "jmbuhr/otter.nvim",
        "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
}
