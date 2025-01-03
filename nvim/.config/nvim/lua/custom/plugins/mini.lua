return {
    {
        "echasnovski/mini.icons",
        event = "VeryLazy",
        opts = {},
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },

    {
        "echasnovski/mini.surround",
        event = "VeryLazy",
        opts = {},
    },

    {
        "echasnovski/mini.indentscope",
        event = "VeryLazy",
        opts = {},
    },

    {
        "echasnovski/mini.bufremove",
        event = "VeryLazy",
        opts = {},
        config = function()
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
        event = "VeryLazy",
        opts = {},
    },

    {
        "echasnovski/mini.notify",
        event = "VeryLazy",
        opts = {},
    },

    {
        "echasnovski/mini.tabline",
        enabled = false,
        event = "VeryLazy",
        opts = {},
    },

    {
        "echasnovski/mini.statusline",
        event = "VeryLazy",
        opts = {},
    },

    {
        "echasnovski/mini.clue",
        config = function()
            local miniclue = require("mini.clue")
            miniclue.setup({
                window = {
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
        opts = {
            query_updaters = "abcdefghijklmnopqrstuvwxyz0123456789_.",
        },
    },
}
