-- [[ Basic Keymaps ]]

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Move lines
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv'")
vim.keymap.set('v', 'K', ":m '>-2<CR>gv=gv'")

vim.keymap.set('n', 'J', 'mzJ`z')

-- center search
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

-- Center on half page scroll
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

-- yank/delete into registers
vim.keymap.set('x', '<leader>p', '"_dP', { desc = 'paste without losing register' })

vim.keymap.set('n', '<leader>y', '"+y', { desc = 'yank into system clipboard' })
vim.keymap.set('v', '<leader>y', '"+y', { desc = 'yank to system clipboard' })

vim.keymap.set('n', '<leader>d', '"_d', { desc = 'delete to empty register' })
vim.keymap.set('v', '<leader>d', '"_d', { desc = 'delete to empty register' })

vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

vim.keymap.set('n', '<leader>r', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = 'replace current word' })

