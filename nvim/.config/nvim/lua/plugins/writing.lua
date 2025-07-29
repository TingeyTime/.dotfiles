return {
    {
        "preservim/vim-pencil",
        init = function()
            vim.g["pencil#wrapModeDefault"] = 'soft'
        end,
        config = function ()
            vim.cmd("Pencil")
        end
    }
}
