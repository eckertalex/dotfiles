return {
  {
    "jose-elias-alvarez/typescript.nvim",
    init = function() table.insert(astronvim.lsp.skip_setup, "tsserver") end,
    ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
    opts = function() return { server = require("astronvim.utils.lsp").config "tsserver" } end
  },
  { "neovim/nvim-lspconfig", dependencies = {
    { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
  } },
}
