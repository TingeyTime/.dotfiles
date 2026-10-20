return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- jsregexp only adds snippet transformations, so skip it where there is no
    -- make (most Windows machines) rather than fail the build
    build = vim.fn.executable("make") == 1 and "make install_jsregexp" or nil,
    lazy = true,
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
        local ls = require("luasnip")

        require("luasnip.loaders.from_vscode").lazy_load()
        ls.filetype_extend("javascript", { "jsdoc" })

        vim.keymap.set("i", "<C-s>e", ls.expand, { silent = true, desc = "Expand snippet" })
        vim.keymap.set({ "i", "s" }, "<C-s>;", function()
            ls.jump(1)
        end, { silent = true, desc = "Next snippet field" })
        vim.keymap.set({ "i", "s" }, "<C-s>,", function()
            ls.jump(-1)
        end, { silent = true, desc = "Previous snippet field" })
        vim.keymap.set({ "i", "s" }, "<C-e>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true, desc = "Next snippet choice" })
    end,
}
