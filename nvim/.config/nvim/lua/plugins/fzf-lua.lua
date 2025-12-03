return {
    {
        "ibhagwan/fzf-lua",
        dependencies = {
            "nvim-mini/mini.icons",
            "elanmed/fzf-lua-frecency.nvim",
        },
        ---@module "fzf-lua"
        ---@type function|fzf-lua.Config
        config = function()
            local fzf = require("fzf-lua")
            fzf.setup({
                keymap = {
                    builtin = {
                        ["<alt-p>"] = "toggle-preview",
                    },
                },
                defaults = {
                    formatter = "path.filename_first",
                },
            })

            fzf.register_ui_select()

            local fzf_frecency = require("fzf-lua-frecency")

            -- helper to simplify repetitive mapping pattern
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
        end,
    },
}
