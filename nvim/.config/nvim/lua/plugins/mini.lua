return {
    {
        "nvim-mini/mini.icons",
        lazy = true,
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },

    {
        "nvim-mini/mini.bufremove",
        opts = {},
        config = function(_, opts)
            require("mini.bufremove").setup(opts)

            vim.keymap.set("n", "<leader>bd", "<cmd>lua MiniBufremove.delete()<cr>", { desc = "Delete" })
            vim.keymap.set("n", "<leader>bD", "<cmd>lua MiniBufremove.delete(0, true)<cr>", { desc = "Delete!" })
        end,
    },

    {
        "nvim-mini/mini.cursorword",
        opts = {},
    },

    {
        "nvim-mini/mini.hipatterns",
        config = function()
            local hipatterns = require("mini.hipatterns")
            hipatterns.setup({
                highlighters = {
                    fixme = { pattern = { "FIXME", "FIX" }, group = "MiniHipatternsFixme" },
                    hack = { pattern = { "HACK", "WARN", "WARNING" }, group = "MiniHipatternsHack" },
                    todo = { pattern = "TODO", group = "MiniHipatternsTodo" },
                    note = { pattern = { "NOTE", "INFO" }, group = "MiniHipatternsNote" },
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
        opts = {
            query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",
        },
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
