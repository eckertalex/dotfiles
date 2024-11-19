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

-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- [[ Setting options ]]
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers

vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.mouse = "a" -- Enable mouse mode

vim.opt.showmode = false -- Dont show mode since we have a statusline

-- vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard
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

-- [[ Basic Keymaps ]]

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

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
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without losing register" })

vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete to empty register" })

-- Basic clipboard interaction
vim.keymap.set({ "n", "x", "o" }, "gy", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "x", "o" }, "gp", '"+p', { desc = "Paste clipboard text" })

-- replace word
vim.keymap.set(
    "n",
    "<leader>r",
    [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
    { desc = "Replace word in Buffer" }
)

-- new file
vim.keymap.set("n", "<leader>n", "<cmd>enew<cr>", { desc = "New file" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>ba", "<cmd>%bd|e#|bd#<cr>", { desc = "Delete all buffers" })

-- Clear search with <esc>
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- toggle diagnostics
local enabled = true
vim.keymap.set("n", "<leader>xd", function()
    enabled = not enabled
    if enabled then
        vim.diagnostic.enable()
        vim.notify("Enabled diagnostics", vim.log.levels.INFO)
    else
        vim.diagnostic.enable(false)
        vim.notify("Disabled diagnostics", vim.log.levels.WARN)
    end
end, { desc = "Toggle Diagnostics" })

vim.keymap.set("n", "<leader>xr", vim.diagnostic.reset, { desc = "Reset Diagnostic" })

-- highlights under cursor
vim.keymap.set("n", "<leader>xi", vim.show_pos, { desc = "Inspect Pos" })

-- Quickfix
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- [[ User Commands ]]
vim.api.nvim_create_user_command("ReportStartupPerformance", function()
    local stats = require("lazy").stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
    vim.notify(
        "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
        vim.log.levels.INFO
    )
end, {})

-- [[ Basic Autocommands ]]
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "Highlight when yanking (copying) text",
    group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = vim.api.nvim_create_augroup("last_loc", { clear = true }),
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("close_with_q", { clear = true }),
    pattern = {
        "PlenaryTestPopup",
        "netrw",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "tsplayground",
        "checkhealth",
        "fugitiveblame",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

local colorscheme = "rose-pine-moon"

-- [[ Configure and install plugins ]]
require("lazy").setup({
    {
        "rose-pine/neovim",
        as = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({})

            vim.cmd.colorscheme(colorscheme)
        end,
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                integrations = {
                    cmp = true,
                    gitsigns = true,
                    lsp_trouble = true,
                    mason = true,
                    mini = true,
                    native_lsp = {
                        enabled = true,
                        underlines = {
                            errors = { "undercurl" },
                            hints = { "undercurl" },
                            warnings = { "undercurl" },
                            information = { "undercurl" },
                        },
                    },
                    semantic_tokens = true,
                    telescope = true,
                    treesitter = true,
                    treesitter_context = true,
                },
            })

            vim.cmd.colorscheme(colorscheme)
        end,
    },

    {
        "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
    },

    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>gg", "<cmd>Git<cr>", { desc = "Fugitive" })
            vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs = package.loaded.gitsigns

                    local function map(mode, l, r, opts)
                        opts = opts or {}
                        opts.buffer = bufnr
                        vim.keymap.set(mode, l, r, opts)
                    end

                    -- Navigation
                    map({ "n", "v" }, "]c", function()
                        if vim.wo.diff then
                            return "]c"
                        end
                        vim.schedule(function()
                            gs.next_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Next hunk" })

                    map({ "n", "v" }, "[c", function()
                        if vim.wo.diff then
                            return "[c"
                        end
                        vim.schedule(function()
                            gs.prev_hunk()
                        end)
                        return "<Ignore>"
                    end, { expr = true, desc = "Previous hunk" })

                    -- Actions
                    -- visual mode
                    map("v", "<leader>ghs", function()
                        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Stage hunk" })
                    map("v", "<leader>ghr", function()
                        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                    end, { desc = "Reset hunk" })
                    -- normal mode
                    map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
                    map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
                    map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
                    map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
                    map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
                    map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
                    map("n", "<leader>ghb", function()
                        gs.blame_line({ full = false })
                    end, { desc = "Blame line" })
                    map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
                    map("n", "<leader>ghD", function()
                        gs.diffthis("~")
                    end, { desc = "Diff this ~" })
                end,
            })
        end,
    },

    {
        "stevearc/oil.nvim",
        config = function()
            require("oil").setup({
                view_options = {
                    show_hidden = true,
                },
            })

            vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
        end,
    },

    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require("ts_context_commentstring").setup({
                enable_autocmd = false,
            })
        end,
    },

    {
        "echasnovski/mini.comment",
        config = function()
            require("mini.comment").setup({
                options = {
                    custom_commentstring = function()
                        return require("ts_context_commentstring.internal").calculate_commentstring()
                            or vim.bo.commentstring
                    end,
                },
            })
        end,
    },

    {
        "echasnovski/mini.icons",
        config = function()
            require("mini.icons").setup()
        end,
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },

    {
        "echasnovski/mini.surround",
        config = function()
            require("mini.surround").setup()
        end,
    },

    {
        "echasnovski/mini.indentscope",
        config = function()
            require("mini.indentscope").setup({
                symbol = "│",
                options = {
                    try_as_border = true,
                },
            })
        end,
    },

    {
        "echasnovski/mini.bufremove",
        config = function()
            require("mini.bufremove").setup({})

            vim.keymap.set("n", "<leader>bd", function()
                local bd = require("mini.bufremove").delete
                if vim.bo.modified then
                    local choice =
                        vim.fn.confirm(("Save changes to %q?"):format(vim.fn.bufname()), "&Yes\n&No\n&Cancel")
                    if choice == 1 then -- Yes
                        vim.cmd.write()
                        bd(0)
                    elseif choice == 2 then -- No
                        bd(0, true)
                    end
                else
                    bd(0)
                end
            end, { desc = "Delete Buffer" })

            vim.keymap.set("n", "<leader>bD", function()
                require("mini.bufremove").delete(0, true)
            end, { desc = "Delete Buffer (Force)" })
        end,
    },

    {
        "echasnovski/mini.cursorword",
        config = function()
            require("mini.cursorword").setup({})
        end,
    },

    {
        "echasnovski/mini.notify",
        config = function()
            require("mini.notify").setup({})
        end,
    },

    {
        "echasnovski/mini.tabline",
        enabled = false,
        config = function()
            require("mini.tabline").setup()
        end,
    },

    {
        "echasnovski/mini.statusline",
        config = function()
            require("mini.statusline").setup({
                set_vim_settings = false,
            })
        end,
    },

    {
        "echasnovski/mini.clue",
        enabled = true,
        config = function()
            local miniclue = require("mini.clue")
            miniclue.setup({
                window = {
                    delay = 0,
                    config = {
                        width = "auto",
                    },
                },
                triggers = {
                    -- Leader triggers
                    { mode = "n", keys = "<leader>" },
                    { mode = "x", keys = "<leader>" },

                    -- `g` key
                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    -- Marks
                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    -- Registers
                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    -- Window commands
                    { mode = "n", keys = "<C-w>" },

                    -- `z` key
                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },
                },
                -- Add descriptions for mapping groups
                clues = {
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                    { mode = "n", keys = "<leader>b", desc = "+Buffers" },
                    { mode = "n", keys = "<leader>c", desc = "+Copilot" },
                    { mode = "n", keys = "<leader>g", desc = "+Git" },
                    { mode = "n", keys = "<leader>gh", desc = "+Hunk" },
                    { mode = "n", keys = "<leader>gs", desc = "+Search" },
                    { mode = "n", keys = "<leader>q", desc = "+Quit/Sessions" },
                    { mode = "n", keys = "<leader>s", desc = "+Search" },
                    { mode = "n", keys = "<leader>x", desc = "+Diagnostics/Quickfix" },
                },
            })
        end,
    },

    {
        "echasnovski/mini.starter",
        enabled = false,
        config = function()
            require("mini.starter").setup({
                query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",
            })
        end,
    },

    {
        "folke/persistence.nvim",
        config = function()
            require("persistence").setup({})

            vim.keymap.set("n", "<leader>qs", function()
                require("persistence").load()
            end, { desc = "Load current session" })
            vim.keymap.set("n", "<leader>qS", function()
                require("persistence").select()
            end, { desc = "Select session" })
            vim.keymap.set("n", "<leader>ql", function()
                require("persistence").load({ last = true })
            end, { desc = "Last session" })
            vim.keymap.set("n", "<leader>qd", function()
                require("persistence").stop()
            end, { desc = "Stop persistence" })
        end,
    },

    {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({
                window = {
                    options = {
                        signcolumn = "no", -- disable signcolumn
                        number = false, -- disable number column
                        relativenumber = false, -- disable relative numbers
                        cursorline = false, -- disable cursorline
                        cursorcolumn = false, -- disable cursor column
                        foldcolumn = "0", -- disable fold column
                        list = false, -- disable whitespace characters
                    },
                },
                plugins = {
                    options = {
                        enabled = true,
                        laststatus = 0,
                    },
                    gitsigns = { enabled = true },
                    tmux = { enabled = true },
                },
                on_open = function()
                    vim.b.miniindentscope_disable = true
                end,
                on_close = function()
                    vim.b.miniindentscope_disable = false
                end,
            })

            vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen" })
        end,
    },

    {
        "folke/todo-comments.nvim",
        config = function()
            require("todo-comments").setup({})

            vim.keymap.set("n", "]t", function()
                require("todo-comments").jump_next()
            end, { desc = "Next todo comment" })

            vim.keymap.set("n", "[t", function()
                require("todo-comments").jump_prev()
            end, { desc = "Previous todo comment" })

            vim.keymap.set("n", "<leader>xt", "<cmd>Trouble todo toggle<cr>", { desc = "Todo (Trouble)" })

            vim.keymap.set(
                "n",
                "<leader>xT",
                "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>",
                { desc = "Todo/Fix/Fixme (Trouble)" }
            )

            vim.keymap.set("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Todo" })

            vim.keymap.set(
                "n",
                "<leader>sT",
                "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
                { desc = "Todo/Fix/Fixme" }
            )
        end,
    },

    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({ use_diagnostic_signs = true })

            vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })

            vim.keymap.set(
                "n",
                "<leader>xX",
                "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
                { desc = "Buffer Diagnostics (Trouble)" }
            )

            vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })

            vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })

            vim.keymap.set("n", "[q", function()
                if require("trouble").is_open() then
                    require("trouble").prev({}, {})
                else
                    local ok, err = pcall(vim.cmd.cprev)
                    if not ok and err then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end, { desc = "Previous trouble/quickfix item" })

            vim.keymap.set("n", "]q", function()
                if require("trouble").is_open() then
                    require("trouble").next({}, {})
                else
                    local ok, err = pcall(vim.cmd.cnext)
                    if not ok and err then
                        vim.notify(err, vim.log.levels.ERROR)
                    end
                end
            end, { desc = "Next trouble/quickfix item" })
        end,
    },

    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({})

            vim.keymap.set("n", "<C-e>", function()
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end, { desc = "Harpoon List" })

            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon file" })

            vim.keymap.set("n", "<C-h>", function()
                harpoon:list():select(1)
            end, { desc = "Harpoon to file 1" })

            vim.keymap.set("n", "<C-j>", function()
                harpoon:list():select(2)
            end, { desc = "Harpoon to file 2" })

            vim.keymap.set("n", "<C-k>", function()
                harpoon:list():select(3)
            end, { desc = "Harpoon to file 3" })

            vim.keymap.set("n", "<C-l>", function()
                harpoon:list():select(4)
            end, { desc = "Harpoon to file 4" })
        end,
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function()
                    return vim.fn.executable("make") == 1
                end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },
        },
        config = function()
            local telescope = require("telescope")
            pcall(telescope.load_extension, "fzf")
            pcall(telescope.load_extension, "ui-select")
            local actions = require("telescope.actions")
            local action_layout = require("telescope.actions.layout")

            telescope.setup({
                defaults = {
                    path_display = {
                        filename_first = true,
                    },
                    mappings = {
                        i = {
                            ["<C-h>"] = action_layout.toggle_preview,
                        },
                        n = {
                            ["<C-h>"] = action_layout.toggle_preview,
                            ["q"] = actions.close,
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                },
            })

            vim.keymap.set("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Search Help" })

            vim.keymap.set("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Search Files" })

            vim.keymap.set("n", "<leader>sw", "<cmd>Telescope grep_string<cr>", { desc = "Search current Word" })

            vim.keymap.set("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Search by Grep" })

            vim.keymap.set("n", "<leader>sd", "<cmd>Telescope diagnostics<cr>", { desc = "Search Diagnostics" })

            vim.keymap.set("n", "<leader>sr", "<cmd>Telescope resume<cr>", { desc = "Search Resume" })

            vim.keymap.set("n", "<leader>s.", "<cmd>Telescope oldfiles<cr>", { desc = "Search Recent Files" })

            vim.keymap.set(
                "n",
                "<leader><leader>",
                "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
                { desc = "Search Buffers" }
            )

            vim.keymap.set(
                "n",
                "<leader>/",
                "<cmd>Telescope current_buffer_fuzzy_find<cr>",
                { desc = "Fuzzily search in current buffer" }
            )

            vim.keymap.set(
                "n",
                "<leader>s/",
                "<cmd>Telescope live_grep grep_open_files=true prompt_title=Live\\ Grep\\ in\\ Open\\ Files<cr>",
                { desc = "Search in Open Files" }
            )

            vim.keymap.set("n", "<leader>gsb", "<cmd>Telescope git_branches<cr>", { desc = "Search Git Branches" })

            vim.keymap.set("n", "<leader>gss", "<cmd>Telescope git_status<cr>", { desc = "Search Git Status" })

            vim.keymap.set("n", "<leader>gsf", "<cmd>Telescope git_files<cr>", { desc = "Search Git Files" })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
        },
        config = function()
            require("nvim-treesitter.configs").setup({
                auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },
                ensure_installed = {
                    "astro",
                    "bash",
                    "c",
                    "css",
                    "diff",
                    "dockerfile",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "gomod",
                    "gosum",
                    "gowork",
                    "html",
                    "javascript",
                    "jsdoc",
                    "json",
                    "json5",
                    "jsonc",
                    "lua",
                    "luadoc",
                    "luap",
                    "markdown",
                    "markdown_inline",
                    "query",
                    "regex",
                    "scss",
                    "toml",
                    "tsx",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = false,
                        node_decremental = "<bs>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                        },
                    },
                },
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({
                max_lines = 3,
            })
        end,
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",

            {
                "folke/lazydev.nvim",
                ft = "lua",
                config = function()
                    require("lazydev").setup({
                        library = {
                            -- Load luvit types when the `vim.uv` word is found
                            { path = "luvit-meta/library", words = { "vim%.uv" } },
                        },
                    })
                end,
            },
            { "Bilal2453/luvit-meta", lazy = true },

            "b0o/SchemaStore.nvim",
        },
        config = function()
            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                severity_sort = true,
            })

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    -- diagnostics

                    -- <C-W>d show diagnostic float
                    -- vim.diagnostic.open_float
                    -- :help CTRL-W_d-default

                    -- [d jump to next diagnostic
                    -- vim.diagnostic.goto_prev
                    -- :help [d-default

                    -- ]d jump to previous diagnostic
                    -- vim.diagnostic.goto_next
                    -- :help ]d-default

                    -- :help lsp-defaults

                    -- K hover
                    -- vim.lsp.buf.hover
                    -- :help K-lsp-default

                    -- <C-]> definition
                    -- <C-W>] definition in new window
                    -- vim.lsp.buf.definition
                    -- :help CTRL-] CTRL-W_]
                    -- To jump back, press <C-T>.
                    vim.keymap.set(
                        "n",
                        "gd",
                        -- vim.lsp.buf.definition,
                        require("telescope.builtin").lsp_definitions,
                        { buffer = event.buf, desc = "vim.lsp.buf.definition" }
                    )

                    -- these should be default in neovim v11
                    vim.keymap.set("n", "grn", vim.lsp.buf.rename, { buffer = event.buf, desc = "vim.lsp.buf.rename" })
                    vim.keymap.set(
                        "n",
                        "gra",
                        vim.lsp.buf.code_action,
                        { buffer = event.buf, desc = "vim.lsp.buf.code_action" }
                    )
                    vim.keymap.set(
                        "n",
                        "grr",
                        -- vim.lsp.buf.references,
                        require("telescope.builtin").lsp_references,
                        { buffer = event.buf, desc = "vim.lsp.buf.references" }
                    )
                    vim.keymap.set(
                        "i",
                        "<C-s>",
                        vim.lsp.buf.signature_help,
                        { buffer = event.buf, desc = "vim.lsp.buf.signature_help" }
                    )

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.keymap.set("n", "<leader>xh", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                        end, { desc = "Toggle inlay hints" })
                    end
                end,
            })

            local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                has_cmp and cmp_nvim_lsp.default_capabilities() or {}
            )

            local servers = {
                astro = {},
                cssls = {},
                cssmodules_ls = {},
                eslint = {
                    settings = {
                        workingDirectories = { mode = "auto" },
                    },
                    on_attach = function()
                        vim.keymap.set("", "<leader>cx", "<cmd>EslintFixAll<cr>", { desc = "EslintFixAll" })
                    end,
                },
                gopls = {
                    settings = {
                        gopls = {
                            gofumpt = true,
                            codelenses = {
                                gc_details = false,
                                generate = true,
                                regenerate_cgo = true,
                                run_govulncheck = true,
                                test = true,
                                tidy = true,
                                upgrade_dependency = true,
                                vendor = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            analyses = {
                                fieldalignment = true,
                                nilness = true,
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                            },
                            usePlaceholders = true,
                            completeUnimported = true,
                            staticcheck = true,
                            directoryFilters = {
                                "-.git",
                                "-.vscode",
                                "-.idea",
                                "-.vscode-test",
                                "-node_modules",
                            },
                            semanticTokens = true,
                        },
                    },
                },
                graphql = {},
                html = {},
                jsonls = {
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                        vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
                    end,
                    settings = {
                        format = {
                            json = {
                                enable = true,
                            },
                            validate = { enable = true },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            telemetry = {
                                enable = false,
                            },
                            diagnostics = {
                                disable = {
                                    "missing-fields",
                                },
                            },
                            hint = {
                                enable = true,
                            },
                        },
                    },
                },
                marksman = {},
                sqls = {},
                tailwindcss = {},
                vtsls = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                parameterNames = { enabled = "literals" },
                                parameterTypes = { enabled = true },
                                variableTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                enumMemberValues = { enabled = true },
                            },
                        },
                    },
                },
            }

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "gofumpt",
                "goimports",
                "markdownlint",
                "prettier",
                "shfmt",
                "stylua",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },

    {
        "lervag/vimtex",
    },

    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
            },
            "saadparwaiz1/cmp_luasnip",

            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",

            {
                "rafamadriz/friendly-snippets",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end,
            },
        },
        opts = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            luasnip.config.setup()

            return {
                completion = {
                    completeopt = "menu,menuone,noinsert",
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-p>"] = cmp.mapping.select_prev_item(),

                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),

                    ["<C-Space>"] = cmp.mapping.complete(),

                    ["<C-l>"] = cmp.mapping(function()
                        if luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        end
                    end, { "i", "s" }),
                    ["<C-h>"] = cmp.mapping(function()
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "lazydev", group_index = 0 },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                formatting = {
                    format = function(entry, item)
                        item.kind = require("mini.icons").get("lsp", item.kind)
                        item.menu = ({
                            nvim_lsp = "[LSP]",
                            luasnip = "[LuaSnip]",
                            buffer = "[Buffer]",
                            path = "[Path]",
                            copilot = "[Copilot]",
                            lazydev = "[LazyDev]",
                        })[entry.source.name]
                        return item
                    end,
                },
            }
        end,
    },

    {
        "stevearc/conform.nvim",
        config = function()
            require("conform").setup({
                notify_on_error = false,
                format_on_save = function(bufnr)
                    -- Disable autoformat on certain filetypes
                    local ignore_filetypes = { "sql", "java", "c", "cpp" }
                    if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                        return
                    end
                    -- Disable with a global or buffer-local variable
                    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                        return
                    end
                    -- Disable autoformat for files in a certain path
                    local bufname = vim.api.nvim_buf_get_name(bufnr)
                    if bufname:match("/node_modules/") then
                        return
                    end
                    return { timeout_ms = 3000, lsp_format = "fallback" }
                end,
                formatters_by_ft = {
                    ["astro"] = { "prettier" },
                    ["css"] = { "prettier" },
                    ["go"] = { "goimports", "gofumpt" },
                    ["html"] = { "prettier" },
                    ["javascript"] = { "prettier" },
                    ["javascriptreact"] = { "prettier" },
                    ["json"] = { "prettier" },
                    ["jsonc"] = { "prettier" },
                    ["lua"] = { "stylua" },
                    ["markdown"] = { "prettier" },
                    ["markdown.mdx"] = { "prettier" },
                    ["scss"] = { "prettier" },
                    ["sh"] = { "shfmt" },
                    ["typescript"] = { "prettier" },
                    ["typescriptreact"] = { "prettier" },
                    ["yaml"] = { "prettier" },
                },
            })

            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    -- FormatDisable! will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {
                desc = "Disable autoformat-on-save",
                bang = true,
            })

            vim.api.nvim_create_user_command("FormatEnable", function()
                vim.b.disable_autoformat = false
                vim.g.disable_autoformat = false
            end, {
                desc = "Re-enable autoformat-on-save",
            })

            vim.api.nvim_create_user_command("Format", function(args)
                local range = nil
                if args.count ~= -1 then
                    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                    range = {
                        start = { args.line1, 0 },
                        ["end"] = { args.line2, end_line:len() },
                    }
                end
                require("conform").format({ async = true, lsp_format = "fallback", range = range })
            end, { range = true })

            vim.keymap.set({ "n", "x" }, "gq", "<cmd>Format<cr>", { desc = "Format buffer" })
        end,
    },

    { import = "custom.plugins" },
}, {
    rocks = {
        enabled = false,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                -- "matchit",
                -- "matchparen",
                -- "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=4 sw=4
