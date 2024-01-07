return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({})
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Files" })
      vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "Git files" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Current Word" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "Resume" })
      vim.keymap.set("n", "<leader><leader>", builtin.resume, { desc = "Resume Telescope" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "Diagnostics" })
    end,
  },
}
