return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git, { desc = "Git status" })

        -- Push/pull from the status buffer
        vim.api.nvim_create_autocmd("FileType", {
            group = vim.api.nvim_create_augroup("fugitive_keymaps", {}),
            pattern = "fugitive",
            callback = function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, vim.tbl_extend("force", opts, { desc = "Git push" }))
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull", "--rebase" })
                end, vim.tbl_extend("force", opts, { desc = "Git pull --rebase" }))
                vim.keymap.set(
                    "n",
                    "<leader>t",
                    ":Git push -u origin ",
                    vim.tbl_extend("force", opts, { desc = "Git push -u origin ..." })
                )
            end,
        })

        -- Resolve a merge conflict in a 3-way diff by taking the left (//2) or
        -- right (//3) side. Outside diff mode the keys keep their built-in meaning.
        local function diffget(side, key)
            return function()
                return vim.wo.diff and ("<cmd>diffget //" .. side .. "<CR>") or key
            end
        end
        vim.keymap.set(
            "n",
            "gu",
            diffget(2, "gu"),
            { expr = true, desc = "Diffget left (in diff)" }
        )
        vim.keymap.set(
            "n",
            "gh",
            diffget(3, "gh"),
            { expr = true, desc = "Diffget right (in diff)" }
        )
    end,
}
