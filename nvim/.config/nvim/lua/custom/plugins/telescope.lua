return {
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
                pickers = {
                    find_files = {
                        follow = true,
                    },
                },
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

            local builtin = require("telescope.builtin")
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

            vim.keymap.set("n", "<leader>sn", function()
                builtin.find_files({ cwd = vim.fn.stdpath("config") })
            end, { desc = "Search config" })

            vim.keymap.set("n", "<space>sp", function()
                require("telescope.builtin").find_files({
                    cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
                })
            end, { desc = "Search plugins" })
        end,
    },
}
