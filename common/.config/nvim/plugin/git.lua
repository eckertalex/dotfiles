local augroup = vim.api.nvim_create_augroup("config-git", {})

vim.pack.add({
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-rhubarb",
    "https://github.com/nvim-mini/mini.diff",
})

-- rhubarb's omnifunc hits the GitHub API synchronously; keep it out of
-- 'autocomplete' and use <C-x><C-o> to trigger it manually.
vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "gitcommit",
    callback = function()
        vim.opt_local.complete:remove("o")
    end,
})

vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })

require("mini.diff").setup()
vim.keymap.set("n", "<leader>gd", function()
    MiniDiff.toggle_overlay(0)
end, { desc = "Diff file" })
