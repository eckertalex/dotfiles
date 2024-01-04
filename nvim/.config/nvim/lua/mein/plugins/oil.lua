return {
  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '-', '<cmd>Oil<cr>', desc = 'Open parent directory' },
    },
    config = function()
      require('oil').setup()
    end,
  },
}
