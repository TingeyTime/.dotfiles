local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("vim-options")
require("vim-set")

-- local plugins_dir = lazypath .. "lua/plugins"
-- local plugins_files = vim.fn.glob(plugins_dir .."/*.lua", true, true)
-- local filtered_plugins = {}
-- for _, file in ipairs(plugins_files) do
--     if not file:match("%.old%.lua$") then
--         table.insert(filtered_plugins, file)
--     end
-- end
-- require("lazy").setup(filtered_plugins)
require("lazy").setup("plugins", {
    rocks = {
        enabled = false,
    },
})
