return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = {
      on_highlights = function(hl, c)
        hl.WinBar = {
          bg = c.none,
          fg = c.teal,
        }
        hl.WinBarNC = {
          bg = c.none,
          fg = c.comment,
        }
      end,
    },
    init = function()
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
