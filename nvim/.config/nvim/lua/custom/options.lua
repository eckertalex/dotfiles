-- [[ Setting options ]]

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers

vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.mouse = "a" -- Enable mouse mode

vim.opt.showmode = false -- Dont show mode since we have a statusline

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
end)

vim.opt.wrap = false -- Disable line wrap
vim.opt.breakindent = true -- Enable break indent

vim.opt.undofile = true -- Save undo history

vim.opt.ignorecase = true -- Ignore case
vim.opt.smartcase = true -- Don't ignore case with capitals

vim.opt.signcolumn = "yes" -- Keep signcolumn on by default

vim.opt.updatetime = 200 -- Save swap file and trigger CursorHold
vim.opt.timeoutlen = 300 -- timeout

vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current

vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.inccommand = "split" -- shows partial off-screen results in a preview window

vim.opt.cursorline = true -- Enable highlighting of the current line

vim.opt.scrolloff = 10 -- Lines of context
vim.opt.sidescrolloff = 8 -- Columns of context

vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 4 -- Size of an indent
vim.opt.tabstop = 4 -- Number of spaces tabs count for
-- vim.opt.expandtab = true -- Use spaces instead of tabs

vim.opt.conceallevel = 3 -- Hide * markup for bold and italic

vim.opt.pumheight = 10 -- Maximum number of entries in a popup

vim.opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

vim.opt.winminwidth = 5 -- Minimum window width

vim.opt.winbar = "%=%m %f" -- Buffer local statusline
vim.opt.laststatus = 3
