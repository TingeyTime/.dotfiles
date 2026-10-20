local prose = { "markdown", "text", "quarto" }

return {
    -- Soft-wrapped prose editing, enabled only for prose filetypes
    {
        "preservim/vim-pencil",
        ft = prose,
        init = function()
            vim.g["pencil#wrapModeDefault"] = "soft"
        end,
        config = function()
            vim.api.nvim_create_autocmd("FileType", {
                group = vim.api.nvim_create_augroup("pencil", {}),
                pattern = prose,
                callback = function()
                    vim.fn["pencil#init"]()
                end,
            })
            -- The FileType event that loaded the plugin has already fired
            vim.fn["pencil#init"]()
        end,
    },
}
