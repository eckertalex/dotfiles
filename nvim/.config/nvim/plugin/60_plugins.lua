local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
local now_if_args = _G.Config.now_if_args

now(function()
    add("rose-pine/neovim")

    vim.cmd.colorscheme("rose-pine")
end)

later(function()
    add({
        source = "ibhagwan/fzf-lua",
        depends = {
            "nvim-mini/mini.icons",
            "elanmed/fzf-lua-frecency.nvim",
        },
    })

    local fzf = require("fzf-lua")
    fzf.setup({
        winopts = {
            ---@diagnostic disable-next-line: missing-fields
            preview = {
                layout = "vertical",
            },
        },
        keymap = {
            builtin = {
                ["<a-p>"] = "toggle-preview",
            },
        },
        defaults = {
            formatter = "path.filename_first",
        },
    })

    fzf.register_ui_select()

    local fzf_frecency = require("fzf-lua-frecency")

    local map = function(lhs, rhs, desc, mode)
        vim.keymap.set(mode or "n", lhs, rhs, { desc = desc })
    end

    map("<leader>,", fzf.buffers, "Buffers")
    map("<leader><leader>", function()
        fzf_frecency.frecency({ cwd_only = true, all_files = true })
    end, "Project Frecency")
    map("<leader>fr", function()
        fzf_frecency.frecency({ cwd_only = false, all_files = false })
    end, "Global Frecency")

    -- find
    map("<leader>ff", fzf.files, "Find Files")
    map("<leader>fg", fzf.git_files, "Find Git Files")

    -- git
    map("<leader>gc", fzf.git_branches, "Git Branches")
    map("<leader>gl", fzf.git_commits, "Git Log")
    map("<leader>gf", fzf.git_bcommits, "Git Log (File)")
    map("<leader>gs", fzf.git_status, "Git Status")
    map("<leader>gS", fzf.git_stash, "Git Stash")
    map("<leader>gd", fzf.git_diff, "Git Diff")

    -- grep
    map("<leader>sb", fzf.lines, "Buffer Lines")
    map("<leader>sB", fzf.grep_curbuf, "Grep Open Buffers")
    map("<leader>sg", fzf.live_grep_native, "Grep Project")
    map("<leader>sw", fzf.grep_cword, "Grep Word")
    map("<leader>sw", fzf.grep_visual, "Grep Selection", "x")

    -- search / misc
    map("<leader>sh", fzf.help_tags, "Search Help")
    map("<leader>sc", fzf.command_history, "Command History")
    map("<leader>s/", fzf.search_history, "Search History")
    map("<leader>sC", fzf.commands, "Commands")
    map('<leader>s"', fzf.registers, "Registers")
    map("<leader>sm", fzf.marks, "Marks")
    map("<leader>sr", fzf.resume, "Resume")
    map("<leader>sd", fzf.diagnostics_workspace, "Diagnostics (Workspace)")
    map("<leader>sD", fzf.diagnostics_document, "Diagnostics (Buffer)")
    map("<leader>sq", fzf.quickfix, "Quickfix List")
    map("<leader>sl", fzf.loclist, "Location List")
end)

now_if_args(function()
    add("stevearc/oil.nvim")

    require("oil").setup({
        view_options = {
            show_hidden = true,
        },
    })

    vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
end)

later(function()
    add("stevearc/quicker.nvim")

    local quicker = require("quicker")
    quicker.setup({
        quickfix = { open = true, close = true, stay = true },
        loclist = { open = true, close = true, stay = true },
        keys = {
            { "<a-p>", quicker.toggle_expand, desc = "Toggle quickfix content" },
        },
    })
end)

later(function()
    add({
        source = "tpope/vim-fugitive",
        depends = { "tpope/vim-rhubarb" },
    })

    vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })
end)

later(function()
    add("lewis6991/gitsigns.nvim")

    local gitsigns = require("gitsigns")

    local function on_attach(bufnr)
        local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
        end

        local function next_hunk()
            if vim.wo.diff then
                vim.cmd.normal({ args = { "]c" }, bang = true })
            else
                require("gitsigns").nav_hunk({ direction = "next" })
            end
        end

        local function prev_hunk()
            if vim.wo.diff then
                vim.cmd.normal({ args = { "[c" }, bang = true })
            else
                require("gitsigns").nav_hunk({ direction = "prev" })
            end
        end

        map({ "n", "v" }, "]c", next_hunk, { desc = "Next hunk" })
        map({ "n", "v" }, "[c", prev_hunk, { desc = "Previous hunk" })

        map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
        map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

        map("v", "<leader>hs", function()
            gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Stage selected hunk" })
        map("v", "<leader>hr", function()
            gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
        end, { desc = "Reset selected hunk" })

        map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
        map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

        map("n", "<leader>hb", function()
            gitsigns.blame_line({ full = true })
        end, { desc = "Blame line" })

        map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
        map("n", "<leader>hD", function()
            gitsigns.diffthis({ base = "~" })
        end, { desc = "Diff this ~" })

        map("n", "<leader>hq", gitsigns.setqflist, { desc = "Populate qflist with hunks" })
        map("n", "<leader>hQ", function()
            gitsigns.setqflist({ target = "all" })
        end, { desc = "Populate qflist with all hunks" })

        map("n", "\\g", gitsigns.toggle_current_line_blame, { desc = "Toggle git line blame" })
        map("n", "\\W", gitsigns.toggle_word_diff, { desc = "Toggle git word diff highlight" })

        map({ "o", "x" }, "gh", gitsigns.select_hunk, { desc = "Select hunk text object" })
    end

    gitsigns.setup({
        on_attach = on_attach,
    })
end)

later(function()
    add("lervag/vimtex")
end)
