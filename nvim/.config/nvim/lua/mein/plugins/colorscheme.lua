return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {},
    init = function()
      vim.cmd.colorscheme("tokyonight-night")
    end
  }
}
