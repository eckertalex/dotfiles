return {
  after = 'mason-lspconfig.nvim',
  config = function() require 'user.plugins.rust-tools.config' end,
}
