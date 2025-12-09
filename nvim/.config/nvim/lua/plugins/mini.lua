return {
    {
        "nvim-mini/mini.basics",
        config = function()
            require("mini.basics").setup({
                options = {
                    extra_ui = true,
                },
                mappings = {
                    windows = true,
                    move_with_alt = true,
                },
                autocommands = {
                    relnum_in_visual_mode = true,
                },
            })
        end,
    },

    {
        "nvim-mini/mini.bracketed",
        config = function()
            require("mini.bracketed").setup()
        end,
    },

    {
        "nvim-mini/mini.comment",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
        },
        config = function()
            require("mini.comment").setup({
                options = {
                    custom_commentstring = function()
                        return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
                    end,
                },
            })
        end,
    },

    {
        "nvim-mini/mini.icons",
        config = function()
            require("mini.icons").setup()
        end,
    },

    {
        "nvim-mini/mini.bufremove",
        config = function()
            require("mini.bufremove").setup()

            vim.keymap.set("n", "<leader>bd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Delete" })
            vim.keymap.set("n", "<leader>bD", "<cmd>lua MiniBufremove.delete(0, true)<cr>", { desc = "Delete!" })
        end,
    },

    {
        "nvim-mini/mini.cursorword",
        config = function()
            require("mini.cursorword").setup()
        end,
    },

    {
        "nvim-mini/mini.hipatterns",
        config = function()
            local hipatterns = require("mini.hipatterns")

            local function make_pattern(word)
                return string.format("()%%f[%%w_]%s()%%f[^%%w_]", word)
            end

            hipatterns.setup({
                highlighters = {
                    fixme = {
                        pattern = {
                            make_pattern("FIXME"),
                            make_pattern("FIX"),
                        },
                        group = "MiniHipatternsFixme",
                    },
                    hack = {
                        pattern = {
                            make_pattern("HACK"),
                            make_pattern("WARN"),
                            make_pattern("WARNING"),
                        },
                        group = "MiniHipatternsHack",
                    },
                    todo = {
                        pattern = make_pattern("TODO"),
                        group = "MiniHipatternsTodo",
                    },
                    note = {
                        pattern = {
                            make_pattern("NOTE"),
                            make_pattern("INFO"),
                        },
                        group = "MiniHipatternsNote",
                    },
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },

    {
        "nvim-mini/mini.indentscope",
        opts = {},
    },

    {
        "nvim-mini/mini.statusline",
        opts = {},
    },

    {
        "nvim-mini/mini.starter",
        config = function()
            local starter = require("mini.starter")
            starter.setup({
                query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",
                evaluate_single = true,
                items = {
                    starter.sections.builtin_actions(),
                    starter.sections.recent_files(9, true, false),
                },
                content_hooks = {
                    starter.gen_hook.adding_bullet(),
                    starter.gen_hook.indexing("all", { "Builtin actions" }),
                    starter.gen_hook.aligning("center", "center"),
                },
            })
        end,
    },

    {
        "nvim-mini/mini.notify",
        config = function()
            local win_config = function()
                local has_statusline = vim.o.laststatus > 0
                local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
                return { anchor = "SE", col = vim.o.columns, row = vim.o.lines - pad }
            end
            require("mini.notify").setup({
                window = {
                    config = win_config,
                },
            })
        end,
    },

    {
        "nvim-mini/mini.clue",
        config = function()
            local miniclue = require("mini.clue")
            miniclue.setup({
                window = {
                    delay = 0,
                },
                triggers = {
                    { mode = "n", keys = "<Leader>" },
                    { mode = "x", keys = "<Leader>" },

                    { mode = "n", keys = "[" },
                    { mode = "n", keys = "]" },

                    { mode = "n", keys = "\\" },

                    { mode = "i", keys = "<C-x>" },

                    { mode = "n", keys = "g" },
                    { mode = "x", keys = "g" },

                    { mode = "n", keys = "'" },
                    { mode = "n", keys = "`" },
                    { mode = "x", keys = "'" },
                    { mode = "x", keys = "`" },

                    { mode = "n", keys = '"' },
                    { mode = "x", keys = '"' },
                    { mode = "i", keys = "<C-r>" },
                    { mode = "c", keys = "<C-r>" },

                    { mode = "n", keys = "<C-w>" },

                    { mode = "n", keys = "z" },
                    { mode = "x", keys = "z" },
                },
                clues = {
                    { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
                    { mode = "n", keys = "<Leader>f", desc = "+Find" },
                    { mode = "n", keys = "<Leader>g", desc = "+Git" },
                    { mode = "n", keys = "<Leader>h", desc = "+Hunk" },
                    { mode = "x", keys = "<Leader>h", desc = "+Hunk" },
                    { mode = "n", keys = "<Leader>s", desc = "+Search" },
                    { mode = "x", keys = "<Leader>s", desc = "+Search" },
                    { mode = "n", keys = "<Leader>x", desc = "+Diagnostics" },
                    { mode = "n", keys = "<Leader>y", desc = "+Yank" },
                    { mode = "x", keys = "<Leader>y", desc = "+Yank" },
                    miniclue.gen_clues.square_brackets(),
                    miniclue.gen_clues.builtin_completion(),
                    miniclue.gen_clues.g(),
                    miniclue.gen_clues.marks(),
                    miniclue.gen_clues.registers(),
                    miniclue.gen_clues.windows(),
                    miniclue.gen_clues.z(),
                },
            })
        end,
    },
}
