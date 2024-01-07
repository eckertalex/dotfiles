-- [[ Setting leader ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]

-- vim.opt.clipboard = 'unnamedplus'             -- Sync with system clipboard
vim.opt.completeopt = "menu,menuone,noselect" -- Set completeopt to have a better completion experience
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.hlsearch = false -- Set highlight on search
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.opt.laststatus = 3 -- global statusline
vim.opt.mouse = "a" -- Enable mouse mode
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- true color support
vim.opt.timeoutlen = 300 -- timeout
vim.opt.undofile = true -- Save undo history
vim.opt.updatetime = 250 -- Decrease update time
