-- [[ Setting options ]]

-- General ====================================================================
vim.g.mapleader = " " -- Use `<Space>` as <Leader> key

vim.o.mouse = "a" -- Enable mouse
vim.o.undofile = true -- Enable persistent undo

vim.o.backup = false -- Don't store backup while overwriting the file
vim.o.writebackup = false -- Don't store backup while overwriting the file

vim.cmd("filetype plugin indent on") -- Enable all filetype plugins

-- UI =========================================================================
vim.o.breakindent = true -- Indent wrapped lines to match line start
vim.o.colorcolumn = "+1" -- Draw column on the right of maximum width
vim.o.cursorline = true -- Highlight current line
vim.o.cursorlineopt = "screenline,number" -- Show cursor line per screen line
vim.o.fillchars = "eob: ,fold:╌"
vim.o.linebreak = true -- Wrap long lines at 'breakat' (if 'wrap' is set)
vim.o.list = true -- Show helpful text indicators
vim.o.number = true -- Show line numbers
vim.o.pumblend = 10 -- Make builtin completion menus slightly transparent
vim.o.pumheight = 10 -- Make popup menu smaller
vim.o.relativenumber = true -- Relative line numbers
vim.o.ruler = false -- Don't show cursor position in command line
vim.o.scrolloff = 4 -- Lines of context
vim.o.shortmess = "CFOSWaco" -- Disable some built-in completion messages
vim.o.showmode = false -- Don't show mode in command line
vim.o.sidescrolloff = 4 -- Columns of context
vim.o.signcolumn = "yes" -- Always show sign column (otherwise it will shift text)
vim.o.splitbelow = true -- Horizontal splits will be below
vim.o.splitkeep = "screen" -- Reduce scroll during window split
vim.o.splitright = true -- Vertical splits will be to the right
vim.o.termguicolors = true -- Enable gui colors
vim.o.winblend = 10 -- Make floating windows slightly transparent
vim.o.winborder = "rounded" -- Use border in floating windows
vim.o.wrap = false -- Display long lines as just one line

-- Special UI symbols
vim.o.listchars = "nbsp:␣,tab:> ,trail:⋅"

vim.o.foldlevel = 10 -- Fold nothing by default; set to 0 or 1 to fold
vim.o.foldmethod = "indent" -- Fold based on indent level
vim.o.foldnestmax = 10 -- Limit number of fold levels
vim.o.foldtext = "" -- Show text under fold with its highlighting
-- vim.o.foldcolumn = "1"
-- vim.o.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.o.foldmethod = "expr"

-- Editing ====================================================================
vim.o.autoindent = true -- Use auto indent
vim.o.expandtab = true -- Convert tabs to spaces
vim.o.formatoptions = "rqnl1j" -- Improve comment editing
vim.o.ignorecase = true -- Ignore case when searching (use `\C` to force not doing that)
vim.o.inccommand = "split" -- shows partial off-screen results in a preview window
vim.o.incsearch = true -- Show search results while typing
vim.o.infercase = true -- Infer letter cases for a richer built-in keyword completion
vim.o.shiftwidth = 4 -- Use this number of spaces for indentation
vim.o.smartcase = true -- Don't ignore case when searching if pattern has upper case
vim.o.smartindent = true -- Make indenting smart
vim.o.spelloptions = "camel" -- Treat camelCase word parts as separate words
vim.o.tabstop = 4 -- Number of spaces tabs count for
vim.o.timeoutlen = 300 -- timeout
vim.o.updatetime = 200 -- Save swap file and trigger CursorHold
vim.o.virtualedit = "block" -- Allow going past end of line in blockwise mode

vim.o.iskeyword = "@,48-57,_,192-255,-" -- Treat dash as `word` textobject part

-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.o.complete = ".,w,b,kspell" -- Use less sources
vim.o.completeopt = "menuone,noselect,fuzzy,nosort" -- Use custom behavior

-- vim.o.clipboard = "unnamedplus" -- Sync with system clipboard

-- Diagnostics ================================================================

-- Neovim has built-in support for showing diagnostic messages. This configures
-- a more conservative display while still being useful.
vim.diagnostic.config({
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
})

-- set default filetypes
vim.filetype.add({
    extension = {
        query = "graphql",
    },
})
