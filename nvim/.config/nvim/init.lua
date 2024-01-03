-- [[ Setting leader ]]
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ Configure plugins ]]
require('lazy').setup({
  -- Git related plugins
  'tpope/vim-fugitive',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'folke/neodev.nvim',
    },
  },

  { 'folke/which-key.nvim', opts = {} },

  {
    'rose-pine/neovim',
    name = 'rose-pine',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'rose-pine'
    end,
  },

  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        enabled = vim.fn.executable 'make' == 1,
      },
    },
  },

  {
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },
}, {})

-- [[ Setting options ]]

-- vim.opt.clipboard = 'unnamedplus'             -- Sync with system clipboard
vim.opt.completeopt = 'menu,menuone,noselect' -- Set completeopt to have a better completion experience
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- Enable highlighting of the current line
vim.opt.hlsearch = false -- Set highlight on search
vim.opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
vim.opt.laststatus = 3 -- global statusline
vim.opt.mouse = 'a' -- Enable mouse mode
vim.opt.number = true -- Print line number
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.signcolumn = 'yes' -- Keep signcolumn on by default
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- true color support
vim.opt.timeoutlen = 300 -- timeout
vim.opt.undofile = true -- Save undo history
vim.opt.updatetime = 250 -- Decrease update time

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

-- [[ Autocmds ]]

-- [[ Highlight on yank ]]
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ go to last loc when opening a buffer ]]
local last_loc_group = vim.api.nvim_create_augroup('last_loc', { clear = true })
vim.api.nvim_create_autocmd('BufReadPost', {
  group = last_loc_group,
  callback = function(event)
    local exclude = { 'gitcommit' }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
      return
    end
    vim.b[buf].lazyvim_last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- [[ close some filetypes with <q> ]]
local close_with_q_group = vim.api.nvim_create_augroup('close_with_q', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = close_with_q_group,
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'query',
    'spectre_panel',
    'startuptime',
    'tsplayground',
    'neotest-output',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true })
  end,
})

-- [[ Configure Telescope ]]

require('telescope').setup {}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
  -- Use the current buffer's path as the starting point for the git search
  local current_file = vim.api.nvim_buf_get_name(0)
  local current_dir
  local cwd = vim.fn.getcwd()
  -- If the buffer is not associated with a file, return nil
  if current_file == '' then
    current_dir = cwd
  else
    -- Extract the directory from the current file's path
    current_dir = vim.fn.fnamemodify(current_file, ':h')
  end

  -- Find the Git root directory from the current file's path
  local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
  if vim.v.shell_error ~= 0 then
    print 'Not a git repository. Searching on current working directory'
    return cwd
  end
  return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
  local git_root = find_git_root()
  if git_root then
    require('telescope.builtin').live_grep {
      search_dirs = { git_root },
    }
  end
end

vim.api.nvim_create_user_command('LiveGrepGitRoot', live_grep_git_root, {})

vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>ff', require('telescope.builtin').find_files, { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fb', require('telescope.builtin').buffers, { desc = 'Buffers' })
vim.keymap.set('n', '<leader>fr', require('telescope.builtin').oldfiles, { desc = 'Recent' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = 'Help' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = 'Grep' })
vim.keymap.set('n', '<leader>sG', '<cmd>LiveGrepGitRoot<cr>', { desc = 'Grep (cwd)' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = 'Current Word' })
vim.keymap.set('n', '<leader>sr', require('telescope.builtin').resume, { desc = 'Resume' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>gf', require('telescope.builtin').git_files, { desc = 'Git Files' })

-- [[ Configure Treesitter ]]
-- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = {
      'bash',
      'css',
      'dockerfile',
      'gitcommit',
      'gitignore',
      'go',
      'html',
      'java',
      'javascript',
      'json',
      'kotlin',
      'lua',
      'lua',
      'markdown',
      'php',
      'python',
      'scss',
      'tsx',
      'typescript',
      'vim',
      'vimdoc',
      'yaml',
    },

    -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
    auto_install = false,

    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-space>',
        node_incremental = '<c-space>',
        scope_incremental = '<c-s>',
        node_decremental = '<M-space>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          -- You can use the capture groups defined in textobjects.scm
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>a'] = '@parameter.inner',
        },
        swap_previous = {
          ['<leader>A'] = '@parameter.inner',
        },
      },
    },
  }
end, 0)

-- Setup neovim lua configuration
require('neodev').setup()

-- [[ Oil ]]
vim.keymap.set('n', '-', '<cmd>Oil<cr>')

-- [[ Lazy ]]
vim.keymap.set('n', '<leader>l', '<cmd>Lazy<cr>', { desc = 'Lazy' })

-- [[ which-key ]]
require('which-key').register {
  ['g'] = { name = '+goto' },
  -- ["gs"] = { name = "+surround" },
  [']'] = { name = '+next' },
  ['['] = { name = '+prev' },
  -- ["<leader><tab>"] = { name = "+tabs" },
  ['<leader>b'] = { name = '+buffer' },
  -- ["<leader>c"] = { name = "+code" },
  -- ["<leader>f"] = { name = "+file/find" },
  ['<leader>f'] = { name = '+find' },
  ['<leader>g'] = { name = '+git' },
  -- ["<leader>q"] = { name = "+quit/session" },
  ['<leader>s'] = { name = '+search' },
  -- ["<leader>u"] = { name = "+ui" },
  -- ["<leader>w"] = { name = "+windows" },
  -- ["<leader>x"] = { name = "+diagnostics/quickfix" },
}
