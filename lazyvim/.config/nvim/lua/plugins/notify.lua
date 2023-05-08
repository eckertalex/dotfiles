return {
  {
    "rcarriga/nvim-notify",
    opts = {
      top_down = false,
      level = vim.log.levels.WARN, -- help vim.log.levels
      render = "minimal",
      stages = "static",
    },
  },
}
