return {
    {
        "christoomey/vim-tmux-navigator",
        config = function()
            local map = function(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { desc = desc })
            end

            map("<C-h>", "<cmd>TmuxNavigateLeft<cr>", "Navigate to left tmux pane")
            map("<C-j>", "<cmd>TmuxNavigateDown<cr>", "Navigate to below tmux pane")
            map("<C-k>", "<cmd>TmuxNavigateUp<cr>", "Navigate to above tmux pane")
            map("<C-l>", "<cmd>TmuxNavigateRight<cr>", "Navigate to right tmux pane")
            map("<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", "Navigate to last tmux pane")
        end,
    },
}
