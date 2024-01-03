return {
  {
    "rose-pine/neovim",
    lazy = true,
    name = "rose-pine",
  },

  -- Configure LazyVim to load catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },

  -- neo-tree to the right
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right",
      },
    },
  },

  {
    "stevearc/oil.nvim",
    opts = {
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
  },
}
