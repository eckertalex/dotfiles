return {
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
}
