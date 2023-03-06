return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        position = "right",
      },
    },
    keys = {
      {
        "<leader>o",
        "<cmd>Neotree<cr>",
        desc = "Focus NeoTree",
      },
    },
  },
}
