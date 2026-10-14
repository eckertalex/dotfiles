local augroup = require("utils").augroup

-- Load filetype plugins now instead of after init.lua, so FileType autocmds
-- below run after them and can override what they set
vim.cmd("filetype plugin indent on")

-- General ====================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.o.undofile = true
vim.o.writebackup = false

-- UI =========================================================================
vim.o.breakindent = true
vim.o.colorcolumn = "+1"
vim.o.cursorline = true
vim.o.cursorlineopt = "screenline,number"
vim.o.linebreak = true
vim.o.number = true
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4
vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.o.winborder = "rounded"
vim.o.wrap = false

vim.opt.fillchars:append("eob: ")
vim.o.list = true
vim.o.listchars = "tab:> ,extends:…,precedes:…,nbsp:␣"
vim.o.pumblend = 10
vim.o.pumheight = 10
vim.o.winblend = 10
vim.opt.shortmess:append("Wc")

vim.o.foldlevel = 10
vim.o.foldcolumn = "1"
vim.o.foldmethod = "indent"
vim.o.foldnestmax = 10

-- Editing ====================================================================
vim.o.expandtab = true
-- Drop the default "-uu" so ~/.config/ripgrep/rc (hidden files, no .git) and .gitignore apply
vim.o.grepprg = "rg --vimgrep --smart-case"
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions = "rqnl1j"
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.infercase = true
vim.o.shiftwidth = 4
vim.o.smartcase = true
vim.o.spelloptions = "camel"
vim.o.tabstop = 4
vim.o.timeoutlen = 300
vim.o.updatetime = 200
vim.o.virtualedit = "block"

-- Built-in completion. "o" pulls LSP items through 'omnifunc' (see plugin/lsp.lua)
vim.o.autocomplete = true
vim.o.complete = "o,.,w,b,kspell"
vim.o.completeopt = "menuone,noselect,popup,fuzzy"

-- vim.provider ===============================================================
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- built-in plugins ===========================================================
vim.cmd.packadd("cfilter")
-- `nvim -d dir1 dir2` (`git difftool -d`) lists changed files in quickfix
vim.cmd.packadd("nvim.difftool")
vim.cmd.packadd("nvim.undotree")

-- oil.nvim handles directories
vim.g.loaded_nvim_dir_plugin = 1

-- ui2 ========================================================================
require("vim._core.ui2").enable()

-- Diagnostics ================================================================
vim.diagnostic.config({
    signs = {
        priority = 9999,
        severity = { min = vim.diagnostic.severity.WARN },
    },
    virtual_text = {
        current_line = true,
        severity = vim.diagnostic.severity.ERROR,
    },
})

-- Colorscheme ================================================================
vim.pack.add({
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
})
vim.cmd.colorscheme("rose-pine")

-- Keymaps ====================================================================
-- Move by visible lines when there is no count
vim.keymap.set({ "n", "x" }, "j", [[v:count == 0 ? 'gj' : 'j']], { expr = true })
vim.keymap.set({ "n", "x" }, "k", [[v:count == 0 ? 'gk' : 'k']], { expr = true })

-- System clipboard
vim.keymap.set({ "n", "x" }, "gy", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "gp", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("x", "gp", '"+P', { desc = "Paste from system clipboard" })

-- Move lines
vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")

-- Join lines without moving the cursor
vim.keymap.set("n", "J", function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal! " .. vim.v.count1 .. "J")
    vim.api.nvim_win_set_cursor(0, cursor)
end)

-- center search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Center on half page scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- notes
vim.keymap.set("n", "<leader>n", "<cmd>drop ~/code/work/notes.md<cr>", { desc = "Notes" })

-- better indenting
vim.keymap.set("x", "<", "<gv")
vim.keymap.set("x", ">", ">gv")

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

vim.keymap.set("n", "<leader>tv", "<cmd>vertical terminal<cr>", { desc = "Vertical terminal" })

-- Open a terminal at the bottom of the screen with a fixed height. Split the
-- current buffer (not `:new`) so the terminal starts in its directory (:bcd)
vim.keymap.set("n", "<leader>tb", function()
    vim.cmd("botright 12split")
    vim.wo.winfixheight = true
    vim.cmd.term()
end, { desc = "Bottom terminal" })

-- Yank the file path, plus the line range in Visual mode (e.g. "file.lua:12-18")
local function yank_path(path)
    if vim.fn.mode():match("[vV\22]") then
        local first, last = vim.fn.line("v"), vim.fn.line(".")
        first, last = math.min(first, last), math.max(first, last)
        path = path .. ":" .. (first == last and first or first .. "-" .. last)
    end
    vim.fn.setreg("+", path)
    vim.notify("Yanked: " .. path)
end

vim.keymap.set({ "n", "x" }, "<leader>yp", function()
    yank_path(vim.fn.expand("%:p"))
end, { desc = "Yank absolute path" })
vim.keymap.set({ "n", "x" }, "<leader>yr", function()
    yank_path("./" .. vim.fn.expand("%:."))
end, { desc = "Yank relative path" })

-- Autocommands ===============================================================
vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Resize splits when window is resized",
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = augroup,
    callback = function()
        vim.hl.hl_op()
    end,
    desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("TermOpen", {
    group = augroup,
    command = "startinsert",
    desc = "Start terminal in Insert mode",
})

vim.api.nvim_create_autocmd("ModeChanged", {
    group = augroup,
    -- \22 is CTRL-V, the mode name for blockwise Visual
    pattern = { "*:[V\22]*", "[V\22]*:*" },
    callback = function()
        vim.wo.relativenumber = vim.wo.number and vim.fn.mode():match("^[V\22]") ~= nil
    end,
    desc = "Relative line numbers in linewise and blockwise Visual mode",
})

-- Buffer-local, so the global cwd (saved by sessions) stays where Nvim started
vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    group = augroup,
    callback = function(event)
        if vim.bo[event.buf].buftype ~= "" then
            return
        end
        local root = vim.fs.root(event.buf, ".git")
        if root then
            vim.cmd.bcd(root)
        end
    end,
    desc = "Set the buffer's directory to its git root",
})

vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = augroup,
    pattern = { "grep", "vimgrep" },
    command = "cwindow",
    desc = "Open quickfix window after :grep",
})

vim.api.nvim_create_autocmd("BufReadPost", {
    group = augroup,
    callback = function()
        local line = vim.fn.line([['"]])
        local skip = vim.bo.filetype:match("commit") or vim.bo.filetype == "gitrebase"
        if not skip and line >= 1 and line <= vim.fn.line("$") then
            vim.cmd([[normal! g`"zz]])
        end
    end,
    desc = "Restore cursor position when opening a file",
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function()
        vim.bo.formatoptions = vim.bo.formatoptions:gsub("[co]", "")
    end,
    desc = "Proper 'formatoptions'",
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = {
        "fugitiveblame",
        "help",
        "nvim-undotree",
        "qf",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Close special buffers with 'q' and exclude from buffer list",
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "text", "plaintex", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
    desc = "Wrap and check spelling in text-like files",
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = { "json", "jsonc", "json5", "markdown" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
    desc = "Set conceallevel to 0 for JSON and Markdown files",
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=4 sw=4
