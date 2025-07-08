return {
    {
        "tpope/vim-dadbod",
        cmd = { "DB", "DBUI", "DBExec", "DBOpen" },
        ft = { "sql", "psql", "mysql", "dadbod" },
        config = function ()
            M = {}
            function M.setup()
                vim.g.dadbod_use_nvim_cmd = 1
                vim.g.dadbod_query_type = "split"
                vim.g.dadbod_completion_case = "perserve"
                vim.api.nvim_create_autocomd("FileType", {
                    pattern = { "sql", "psql", "mysql", "dadbod" },
                    callback = function ()
                        -- execute current statement
                        vim.keymap.set("n", "<leader>e", "<cmd>DBExec<CR>", {
                            desc = "DB: Execute current query",
                            buffer = true
                        })
                        -- execute selected text
                        vim.keymap.set("v", "<leader>e", "<C-u>DBExec<CR>", {
                            desc = "DB: Excute visual selection",
                            buffer = true,
                        })
                        -- toggle Dadbod UI
                        vim.keymap.set("n", "<leader>u", "<cmd>DBUIToggle<CR>", {
                            desc = "DB: Toggle Dadbod UI",
                            buffer = true,
                        })
                    end,
                })
            end
            return M
        end
    },
}
