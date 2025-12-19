-- Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

-- center search
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Center on half page scroll
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- yank/delete into registers
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d', { desc = "Delete _" })

-- replace word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace word" })

-- buffers
local new_scratch_buffer = function()
    vim.api.nvim_win_set_buf(0, vim.api.nvim_create_buf(true, true))
end

vim.keymap.set("n", "<leader>bb", "<Cmd>b#<CR>", { desc = "Alternate" })
vim.keymap.set("n", "<leader>bs", new_scratch_buffer, { desc = "Scratch" })

-- Clear search with <esc>
vim.keymap.set("n", "<esc>", "<cmd>nohlsearch<cr>", { desc = "Clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<leader>xr", vim.diagnostic.reset, { desc = "Reset Diagnostic" })

-- highlights under cursor
vim.keymap.set("n", "<leader>xi", vim.show_pos, { desc = "Inspect Pos" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- Easily hit escape in terminal mode.
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>")

-- Open a terminal at the bottom of the screen with a fixed height.
vim.keymap.set("n", "<leader>ts", function()
    vim.cmd.new()
    vim.cmd.wincmd("J")
    vim.api.nvim_win_set_height(0, 12)
    vim.wo.winfixheight = true
    vim.cmd.term()
end)

-- tmux-sessionizer
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww ~/.local/bin/tmux-sessionizer<CR>")
