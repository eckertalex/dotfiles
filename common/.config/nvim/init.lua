--[[
=====================================================================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""""-.|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||       NEOVIM       ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------(""`   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
--]]

local augroup = require("utils").augroup

-- General ====================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- UI =========================================================================
vim.o.colorcolumn = "+1"
vim.o.cursorlineopt = "screenline,number"
vim.o.scrolloff = 4
vim.o.sidescrolloff = 4
vim.o.winborder = "rounded"

vim.o.foldlevel = 10
vim.o.foldcolumn = "1"
vim.o.foldmethod = "indent"
vim.o.foldnestmax = 10

-- Editing ====================================================================
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.formatoptions = "rqnl1j"
vim.o.inccommand = "split"
vim.o.shiftwidth = 4
vim.o.spelloptions = "camel"
vim.o.tabstop = 4
vim.o.timeoutlen = 300
vim.o.updatetime = 200

vim.o.iskeyword = "@,48-57,_,192-255,-"

vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

-- Built-in completion
vim.o.complete = ".,w,b,kspell"
vim.o.completeopt = "menuone,noselect,fuzzy,nosort"

-- vim.provider ===============================================================
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- built-in plugins ===========================================================
vim.cmd.packadd("nvim.undotree")

-- ui2 ========================================================================
require("vim._core.ui2").enable({})

-- Diagnostics ================================================================
vim.diagnostic.config({
    signs = {
        priority = 9999,
        severity = {
            min = vim.diagnostic.severity.WARN,
            max = vim.diagnostic.severity.ERROR,
        },
    },
    underline = {
        severity = {
            min = vim.diagnostic.severity.HINT,
            max = vim.diagnostic.severity.ERROR,
        },
    },
    virtual_lines = false,
    virtual_text = {
        current_line = true,
        severity = {
            min = vim.diagnostic.severity.ERROR,
            max = vim.diagnostic.severity.ERROR,
        },
    },
    update_in_insert = false,
})

vim.pack.add({
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})
vim.cmd.colorscheme("rose-pine-dawn")

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

-- center search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Center on half page scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- yank/delete into registers
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete _" })

-- replace word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })

-- buffers
local function new_scratch_buffer()
    vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

vim.keymap.set("n", "<leader>bb", "<Cmd>b#<CR>", { desc = "Alternate" })
vim.keymap.set("n", "<leader>bs", new_scratch_buffer, { desc = "Scratch" })

-- notes
vim.keymap.set("n", "<leader>n", require("notes").open, { desc = "Notes" })

-- Clear search with <esc>
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>xr", vim.diagnostic.reset, { desc = "Reset Diagnostic" })

-- highlights under cursor
vim.keymap.set("n", "<leader>xi", vim.show_pos, { desc = "Inspect Pos" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

vim.keymap.set("n", "<leader>tv", "<cmd>vertical terminal<cr>", { desc = "Vertical terminal" })

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>tb", function()
    vim.cmd.new()
    vim.api.nvim_win_set_height(0, 12)
    vim.wo.winfixheight = true
    vim.cmd.term()
end, { desc = "Bottom terminal" })

-- get full absolute path
local function get_absolute_path()
    return vim.fn.expand("%:p")
end

-- get path relative to Git root (fallback to cwd)
local function get_relative_path()
    local file = vim.fn.expand("%:p")
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

    local relpath
    if vim.v.shell_error == 0 and git_root and vim.fn.isdirectory(git_root) == 1 then
        relpath = vim.fn.fnamemodify(file, ":." .. git_root)
    else
        relpath = vim.fn.expand("%:.")
    end

    return "./" .. relpath
end

-- format visual range, e.g., "12-18"
local function get_visual_range()
    local start_line = vim.fn.line("v")
    local end_line = vim.fn.line(".")
    if start_line > end_line then
        start_line, end_line = end_line, start_line
    end
    if start_line == end_line then
        return tostring(start_line)
    else
        return string.format("%d-%d", start_line, end_line)
    end
end

-- Copy text to clipboard
local function copy_to_clipboard(text)
    vim.fn.setreg("+", text)
    vim.notify("Yanked: " .. text)
end

-- yank absolute path (and visual line range if applicable)
local function yank_absolute()
    local path = get_absolute_path()
    if vim.fn.mode():match("[vV]") then
        path = path .. ":" .. get_visual_range()
    end
    copy_to_clipboard(path)
end

-- yank relative path (and visual line range if applicable)
local function yank_relative()
    local path = get_relative_path()
    if vim.fn.mode():match("[vV]") then
        path = path .. ":" .. get_visual_range()
    end
    copy_to_clipboard(path)
end

vim.keymap.set({ "n", "v" }, "<leader>yp", yank_absolute, { desc = "Yank absolute path" })
vim.keymap.set({ "n", "v" }, "<leader>yr", yank_relative, { desc = "Yank relative path" })

vim.api.nvim_create_autocmd("VimResized", {
    group = augroup,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Resize splits when window is resized",
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    callback = function()
        vim.cmd("setlocal formatoptions-=c formatoptions-=o")
    end,
    desc = "Proper 'formatoptions'",
})

vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = {
        "netrw",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "startuptime",
        "tsplayground",
        "checkhealth",
        "fugitiveblame",
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
