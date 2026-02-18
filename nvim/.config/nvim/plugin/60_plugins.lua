Config.now(function()
    vim.pack.add({ { src = "https://github.com/rose-pine/neovim", name = "rose-pine" } })

    vim.cmd.colorscheme("rose-pine")
end)

Config.later(function()
    vim.pack.add({
        "https://github.com/ibhagwan/fzf-lua",
        "https://github.com/elanmed/fzf-lua-frecency.nvim",
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

    local function lsp_attach(event)
        vim.keymap.set(
            "n",
            "gd",
            -- vim.lsp.buf.definition,
            function()
                fzf.lsp_definitions()
            end,
            { buffer = event.buf, desc = "vim.lsp.buf.definition" }
        )

        vim.keymap.set(
            "n",
            "grr",
            -- vim.lsp.buf.references,
            function()
                fzf.lsp_references()
            end,
            { buffer = event.buf, desc = "vim.lsp.buf.references" }
        )
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = Config.custom_augroup,
        callback = lsp_attach,
        desc = "Attach custom LSP keymaps (FZF definitions and references)",
    })
end)

Config.now_if_args(function()
    vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

    require("oil").setup({
        view_options = {
            show_hidden = true,
        },
    })

    vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
end)

Config.later(function()
    vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })

    local quicker = require("quicker")
    quicker.setup({
        quickfix = { open = true, close = true, stay = true },
        loclist = { open = true, close = true, stay = true },
        keys = {
            { "<a-p>", quicker.toggle_expand, desc = "Toggle quickfix content" },
        },
    })
end)

Config.later(function()
    vim.pack.add({
        "https://github.com/tpope/vim-fugitive",
        "https://github.com/tpope/vim-rhubarb",
    })

    vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })
end)

Config.later(function()
    vim.pack.add({ "https://github.com/lervag/vimtex" })
end)
