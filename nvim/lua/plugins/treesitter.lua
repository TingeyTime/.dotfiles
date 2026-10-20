return {
    "nvim-treesitter/nvim-treesitter",
    -- The default branch (main) is an incompatible rewrite that also needs the
    -- tree-sitter CLI. Stay on master, which is frozen but works, until migrating.
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
        ensure_installed = {
            "bash",
            "c",
            "javascript",
            "jsdoc",
            "lua",
            "markdown",
            "markdown_inline",
            "python",
            "rust",
            "typescript",
            "vimdoc",
            "vue",
            "yaml",
        },
        -- Install a missing parser when a buffer of that language opens (needs a C compiler)
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "markdown" },
        },
        indent = { enable = true },
    },
}
