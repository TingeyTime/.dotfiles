-- Language servers use Neovim's native vim.lsp.config API (0.11+).
-- nvim-lspconfig supplies each server's defaults, mason installs the servers,
-- and mason-lspconfig calls vim.lsp.enable() for every installed server.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "j-hui/fidget.nvim",
    },
    config = function()
        vim.lsp.config("*", {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = {
                        globals = { "vim", "bit", "describe", "it", "before_each", "after_each" },
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = { vim.env.VIMRUNTIME },
                    },
                },
            },
        })

        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "rust_analyzer", "pyright" },
        })

        vim.diagnostic.config({
            float = {
                border = "rounded",
                source = true,
                header = "",
                prefix = "",
            },
        })
    end,
}
