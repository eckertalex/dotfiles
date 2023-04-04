vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.autowrite = true -- Enable auto write
opt.backup = false -- dont store backup while overwriting the file
opt.breakindent = true -- Indent wrapped lines to match line start
opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menuone,noinsert,noselect" -- Customize completions
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- highlight the current line
opt.expandtab = true -- convert tabs to spaces
opt.fileencoding = "utf-8" -- the encoding written to a file
opt.fillchars = "eob: " -- Don't show `~` outside of buffer
opt.formatoptions = "jcroqlnt1" -- This is a sequence of letters which describes how automatic formatting is to be done
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- ignore case in search patterns
opt.inccommand = "nosplit" -- preview incremental substitute
opt.incsearch = true -- Show search results while typing
opt.infercase = true -- Infer letter cases for a richer built-in keyword completion
opt.iskeyword:append("-") -- treats words with `-` as single words
opt.laststatus = 0 -- only the last window will always have a status line
opt.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
opt.list = true -- show some invisible characters
opt.listchars = "extends:…,precedes:…,nbsp:␣" -- Define which helper symbols to show
opt.mouse = "a" -- allow the mouse to be used in neovim
opt.number = true -- Show line numbers
opt.pumblend = 10 -- Make builtin completion menus slightly transparent
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = true -- relative line numbers
opt.ruler = false -- Don't show cursor position in command line
opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- round indent
opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false -- dont show mode since we have a statusline
opt.sidescrolloff = 8 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartcase = true -- Don't ignore case when searching if pattern has upper case
opt.smartindent = true -- make indenting smarter again
opt.softtabstop = 2
opt.spelllang = { "en" }
opt.splitbelow = true -- force all horizontal splits to go below current window
opt.splitright = true -- force all vertical splits to go to the right of current window
opt.swapfile = false -- creates a swapfile
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300 -- time to wait for a mapped sequence to complete (in milliseconds)
opt.undofile = true -- enable persistent undo
opt.undolevels = 10000
opt.updatetime = 50 -- faster completion (4000ms default)
opt.virtualedit = "block" -- Allow going past the end of line in visual block mode
opt.whichwrap:append("<,>,[,],h,l") -- keys allowed to move to the previous/next line when the beginning/end of line is reached
opt.wildmode = "longest:full,full" -- command-line completion mode
opt.winblend = 10 -- Make floating windows slightly transparent
opt.winminwidth = 5 -- minimum window width
opt.wrap = false -- display lines as one long line
opt.writebackup = false -- Don't store backup while overwriting the file

if vim.fn.has("nvim-0.9.0") == 1 then
  opt.splitkeep = "screen"
  opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
