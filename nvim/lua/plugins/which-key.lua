-- Shows pending keybindings (with their desc) after a short pause.
return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        delay = 500,
    },
}
