return {
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
}
