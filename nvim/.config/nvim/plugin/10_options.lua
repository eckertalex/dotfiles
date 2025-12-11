-- General ====================================================================
vim.g.mapleader = " " -- Use `<Space>` as <Leader> key

-- UI =========================================================================
vim.o.colorcolumn = "+1" -- Draw column on the right of maximum width
vim.o.cursorlineopt = "screenline,number" -- Show cursor line per screen line
vim.o.scrolloff = 4 -- Lines of context
vim.o.sidescrolloff = 4 -- Columns of context
vim.o.winborder = "rounded" -- Use border in floating windows

vim.o.foldlevel = 10 -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldcolumn = "1"
vim.o.foldmethod = "indent" -- Fold based on indent level
vim.o.foldnestmax = 10 -- Limit number of fold levels

-- Editing ====================================================================
vim.o.autoindent = true -- Use auto indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j" -- Improve comment editing
vim.o.inccommand = "split" -- shows partial off-screen results in a preview window
vim.o.shiftwidth = 4 -- Use this number of spaces for indentation
vim.o.spelloptions = "camel" -- Treat camelCase word parts as separate words
vim.o.tabstop = 4 -- Number of spaces tabs count for
vim.o.timeoutlen = 300 -- timeout
vim.o.updatetime = 200 -- Save swap file and trigger CursorHold

vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.o.complete = ".,w,b,kspell" -- Use less sources
vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior

-- Autocommands ===============================================================

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
local ensure_fo = function()
    vim.cmd("setlocal formatoptions-=c formatoptions-=o")
end
_G.Config.new_autocmd("FileType", "*", ensure_fo, "Proper 'formatoptions'")

-- Diagnostics ================================================================

-- Neovim has built-in support for showing diagnostic messages. This configures
-- a more conservative display while still being useful.
local diagnostic_opts = {
    -- Show signs on top of any other sign, but only for warnings and errors
    signs = {
        priority = 9999,
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
    },

    -- Show all diagnostics as underline
    underline = {
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
    },

    -- Show more details immediately for errors on the current line
    virtual_lines = false,
    virtual_text = {
        current_line = true,
        severity = {
            min = vim.diagnostic.severity.ERROR,
            max = vim.diagnostic.severity.ERROR,
        },
    },

    -- Don't update diagnostics when typing
    update_in_insert = false,
}

MiniDeps.later(function()
    vim.diagnostic.config(diagnostic_opts)
end)
