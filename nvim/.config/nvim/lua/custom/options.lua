-- [[ Setting options ]]

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.number = true -- Print line number
vim.o.relativenumber = true -- Relative line numbers

vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"

vim.o.mouse = "a" -- Enable mouse mode

vim.o.showmode = false -- Dont show mode since we have a statusline

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
vim.schedule(function()
	vim.o.clipboard = "unnamedplus" -- Sync with system clipboard
end)

vim.o.wrap = false -- Disable line wrap
vim.o.breakindent = true -- Enable break indent

vim.o.undofile = true -- Save undo history

vim.o.ignorecase = true -- Ignore case
vim.o.smartcase = true -- Don't ignore case with capitals

vim.o.signcolumn = "yes" -- Keep signcolumn on by default

vim.o.updatetime = 200 -- Save swap file and trigger CursorHold
vim.o.timeoutlen = 300 -- timeout

vim.o.splitbelow = true -- Put new windows below current
vim.o.splitright = true -- Put new windows right of current

vim.o.list = true
vim.o.listchars = "tab:» ,trail:·,nbsp:␣"

vim.o.inccommand = "split" -- shows partial off-screen results in a preview window

vim.o.cursorline = true -- Enable highlighting of the current line

vim.o.scrolloff = 10 -- Lines of context
vim.o.sidescrolloff = 8 -- Columns of context

vim.o.shiftround = true -- Round indent
vim.o.shiftwidth = 4 -- Size of an indent
vim.o.tabstop = 4 -- Number of spaces tabs count for
-- vim.o.expandtab = true -- Use spaces instead of tabs

vim.o.conceallevel = 3 -- Hide * markup for bold and italic

vim.o.pumheight = 10 -- Maximum number of entries in a popup

vim.o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode

vim.o.winminwidth = 5 -- Minimum window width

vim.o.winborder = "rounded" -- Border style of floating windows

vim.o.winbar = "%=%m %f" -- Buffer local statusline
vim.o.laststatus = 3
