local toggle = require("mein.util.toggle")

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

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
vim.keymap.set("x", "<leader>p", '"_dP', { desc = "Paste without losing register" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system clipboard" })
vim.keymap.set("n", "<leader>d", '"_d', { desc = "Delete to empty register" })
vim.keymap.set("v", "<leader>d", '"_d', { desc = "Delete to empty register" })

-- search for word under cursor
vim.keymap.set("n", "<leader>sw", "*``", { desc = "Word (Buffer)" })

-- replace word
vim.keymap.set("n", "<leader>sr", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "Replace (Buffer)" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- window
vim.keymap.set("n", "<leader>ww", "<C-w>p", { desc = "Other window", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-w>c", { desc = "Delete window", remap = true })
vim.keymap.set("n", "<leader>w-", "<C-w>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>w|", "<C-w>v", { desc = "Split window right", remap = true })
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-w>v", { desc = "Split window right", remap = true })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- toggle options
vim.keymap.set("n", "<leader>us", function()
  toggle.option("spell")
end, { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>uw", function()
  toggle.option("wrap")
end, { desc = "Toggle Word Wrap" })
vim.keymap.set("n", "<leader>uL", function()
  toggle.option("relativenumber")
end, { desc = "Toggle Relative Line Numbers" })
vim.keymap.set("n", "<leader>ul", function()
  toggle.number()
end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>ud", function()
  toggle.diagnostics()
end, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set("n", "<leader>uc", function()
  toggle.option("conceallevel", false, { 0, conceallevel })
end, { desc = "Toggle Conceal" })
vim.keymap.set("n", "<leader>uT", function()
  toggle.treesitter_highlight()
end, { desc = "Toggle Treesitter Highlight" })
-- highlights under cursor
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- messages
vim.keymap.set("n", "<leader>um", "<cmd>messages<cr>", { desc = "View messages" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Diagnostics
-- Show diagnostics in a floating window
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
-- Move to the previous diagnostic
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Next Diagnostic" })
-- Move to the next diagnostic
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Prev Diagnostic" })

-- Quickfix
vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

vim.api.nvim_create_user_command("ReportStartupPerformance", function()
  local stats = require("lazy").stats()
  local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
  vim.notify("⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms",
    vim.log.levels.INFO)
end, {})

vim.keymap.set("n", "<leader>up", "<cmd>ReportStartupPerformance<cr>", { desc = "Report Startup Performance" })

-- netrw
vim.keymap.set("n", "-", vim.cmd.Ex, { desc = "Explorer" })

-- tmux
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
