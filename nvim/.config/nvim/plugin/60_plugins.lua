Config.now(function()
    vim.pack.add({
        { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
        { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
    })

    vim.cmd.colorscheme("rose-pine-dawn")
end)

Config.later(function()
    vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

    local fzf = require("fzf-lua")
    fzf.setup({
        fzf_colors = true,
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

    local map = function(lhs, rhs, desc, mode)
        vim.keymap.set(mode or "n", lhs, rhs, { desc = desc })
    end

    map("<leader>,", fzf.buffers, "Buffers")

    map("<leader><leader>", function()
        fzf.combine({ pickers = "buffers;oldfiles;git_files", cwd_only = true })
    end, "Find (buffers/recent/git) cwd")
    map("<leader>fr", function()
        fzf.combine({ pickers = "buffers;oldfiles;git_files", cwd_only = false })
    end, "Find (buffers/recent/git) global")

    map("<leader>ff", fzf.files, "Find all files")
    map("<leader>fg", fzf.git_files, "Find git files")

    map("<leader>fo", function()
        fzf.oldfiles({ cwd_only = true })
    end, "Recent files (cwd)")
    map("<leader>fO", fzf.oldfiles, "Recent files (global)")

    -- git
    map("<leader>gc", fzf.git_branches, "Branches")
    map("<leader>gl", fzf.git_commits, "Log")
    map("<leader>gf", fzf.git_bcommits, "Log file")
    map("<leader>gs", fzf.git_status, "Status")
    map("<leader>gB", fzf.git_blame, "Blame file (fzf)")
    map("<leader>gS", fzf.git_stash, "Stash")

    -- grep
    map("<leader>sb", fzf.lines, "Buffer lines")
    map("<leader>sB", fzf.grep_curbuf, "Grep open buffers")
    map("<leader>sg", fzf.live_grep_native, "Grep project")
    map("<leader>sw", fzf.grep_cword, "Grep word")
    map("<leader>sw", fzf.grep_visual, "Grep selection", "x")

    -- search / misc
    map("<leader>sh", fzf.help_tags, "Search help")
    map("<leader>sc", fzf.command_history, "Command history")
    map("<leader>s/", fzf.search_history, "Search history")
    map("<leader>sC", fzf.commands, "Commands")
    map('<leader>s"', fzf.registers, "Registers")
    map("<leader>sm", fzf.marks, "Marks")
    map("<leader>sr", fzf.resume, "Resume")
    map("<leader>sd", fzf.diagnostics_workspace, "Diagnostics (Workspace)")
    map("<leader>sD", fzf.diagnostics_document, "Diagnostics (Buffer)")
    map("<leader>sq", fzf.quickfix, "Quickfix list")
    map("<leader>sl", fzf.loclist, "Location list")

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

    local oil = require("oil")
    oil.setup({
        view_options = {
            show_hidden = true,
            delete_to_trash = true,
        },
        keymaps = {
            -- create a new mapping, gs, to search and replace in the current directory
            gs = {
                callback = function()
                    -- get the current directory
                    local prefills = { paths = oil.get_current_dir() }

                    local grug_far = require("grug-far")
                    -- instance check
                    if not grug_far.has_instance("explorer") then
                        grug_far.open({
                            instanceName = "explorer",
                            prefills = prefills,
                            staticTitle = "Find and Replace from Explorer",
                        })
                    else
                        grug_far.get_instance("explorer"):open()
                        -- updating the prefills without clearing the search and other fields
                        grug_far.get_instance("explorer"):update_input_values(prefills, false)
                    end
                end,
                desc = "oil: Search in directory",
            },
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

Config.now_if_args(function()
    vim.pack.add({
        "https://github.com/tpope/vim-fugitive",
        "https://github.com/tpope/vim-rhubarb",
    })

    vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })
end)

Config.later(function()
    vim.pack.add({ "https://github.com/lervag/vimtex" })
end)

Config.later(function()
    vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

    vim.keymap.set({ "n", "x" }, "<leader>si", function()
        require("grug-far").open({ visualSelectionUsage = "auto-detect" })
    end, { desc = "grug-far: Search within range" })
end)
