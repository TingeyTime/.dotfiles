-- Headless smoke test for the Neovim config. Run from the repo root:
--   nvim --headless -c "luafile nvim/test/smoke.lua"
-- Opens a file of each language, loads every lazy plugin so all config
-- functions run, checks a few behaviors, and exits non-zero on any error.

local failures = {}

local function fail(msg)
    table.insert(failures, msg)
end

-- Plugins report problems through vim.notify; treat ERROR level as a failure
local notify = vim.notify
vim.notify = function(msg, level, opts)
    if level == vim.log.levels.ERROR then
        fail("notify: " .. tostring(msg))
    end
    return notify(msg, level, opts)
end

local function check(name, fn)
    local ok, err = pcall(fn)
    if not ok then
        fail(name .. ": " .. tostring(err))
    end
end

local function settle()
    vim.wait(500)
end

local dir = vim.fn.tempname()
vim.fn.mkdir(dir, "p")

local samples = {
    { file = "a.lua", wrap = false },
    { file = "a.py", wrap = false },
    { file = "a.rs", wrap = false },
    { file = "a.sh", wrap = false },
    { file = "a.sql", wrap = false },
    { file = "a.yaml", wrap = false },
    { file = "a.md", wrap = true },
    { file = "a.txt", wrap = true },
    { file = "a.qmd", wrap = true },
}

for _, sample in ipairs(samples) do
    check("open " .. sample.file, function()
        local path = dir .. "/" .. sample.file
        vim.fn.writefile({ "x" }, path)
        vim.cmd.edit(path)
        settle()
        if vim.wo.wrap ~= sample.wrap then
            error(("expected wrap=%s, got %s"):format(sample.wrap, vim.wo.wrap))
        end
    end)
end

-- Load every lazy-loaded plugin so each config function runs at least once
check("load all plugins", function()
    require("lazy").load({ plugins = vim.tbl_keys(require("lazy.core.config").plugins) })
    settle()
end)

check("colorscheme", function()
    assert(vim.g.colors_name and vim.g.colors_name:match("^catppuccin"), "catppuccin not active")
end)

for _, lhs in ipairs({ "<leader>pf", "<leader>gs", "<leader>tt", "<leader>u", "<C-h>" }) do
    check("keymap " .. lhs, function()
        assert(vim.fn.maparg(lhs, "n") ~= "", "not mapped")
    end)
end

-- Anything that went wrong but was only echoed
local messages = vim.api.nvim_exec2("messages", { output = true }).output
for line in messages:gmatch("[^\n]+") do
    if line:match("^E%d+:") or line:match("^Error") or line:match("stack traceback") then
        fail("message: " .. line)
    end
end

if #failures > 0 then
    io.stderr:write("nvim smoke test FAILED\n  " .. table.concat(failures, "\n  ") .. "\n")
    vim.cmd("cquit 1")
else
    io.stdout:write("nvim smoke test passed\n")
    vim.cmd("qall!")
end
