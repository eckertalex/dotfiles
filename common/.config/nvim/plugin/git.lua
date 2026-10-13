vim.pack.add({
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-rhubarb",
    "https://github.com/nvim-mini/mini.diff",
})

vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })

require("mini.diff").setup()
vim.keymap.set("n", "<leader>gd", function()
    MiniDiff.toggle_overlay(0)
end, { desc = "Diff file" })
