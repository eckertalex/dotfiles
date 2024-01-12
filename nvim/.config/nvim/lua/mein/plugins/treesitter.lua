return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    config = function()
      vim.defer_fn(function()
        require("nvim-treesitter.configs").setup({
          highlight = { enable = true },
          ensure_installed = {
            "bash",
            "css",
            "diff",
            "dockerfile",
            "gitcommit",
            "gitignore",
            "go",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "lua",
            "luadoc",
            "luap",
            "markdown",
            "markdown_inline",
            "query",
            "regex",
            "scss",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "vimdoc",
            "yaml",
          },
        })
      end, 0)
    end,
  },
}
