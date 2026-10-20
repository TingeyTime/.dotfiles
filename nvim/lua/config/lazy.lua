local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Every file in lua/plugins/ returns one or more plugin specs.
require("lazy").setup("plugins", {
    install = { colorscheme = { "catppuccin" } },
    change_detection = { notify = false },
    rocks = { enabled = false },
})
