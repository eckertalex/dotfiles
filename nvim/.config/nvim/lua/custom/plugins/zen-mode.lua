return {
    {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup({
                window = {
                    options = {
                        signcolumn = "no", -- disable signcolumn
                        number = false, -- disable number column
                        relativenumber = false, -- disable relative numbers
                        cursorline = false, -- disable cursorline
                        cursorcolumn = false, -- disable cursor column
                        foldcolumn = "0", -- disable fold column
                        list = false, -- disable whitespace characters
                    },
                },
                plugins = {
                    options = {
                        enabled = true,
                        laststatus = 0,
                    },
                    gitsigns = { enabled = true },
                    tmux = { enabled = true },
                },
                on_open = function()
                    vim.b.miniindentscope_disable = true
                end,
                on_close = function()
                    vim.b.miniindentscope_disable = false
                end,
            })

            vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<cr>", { desc = "Zen" })
        end,
    },
}
