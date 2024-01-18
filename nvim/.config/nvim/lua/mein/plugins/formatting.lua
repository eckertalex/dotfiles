return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {},
      },
    },
    opts = {
      ensure_installed = {
        "prettier",
        "shfmt",
        "stylua",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    dependencies = {},
    keys = {
      {
        "<leader>cF",
        function()
          require("conform").format()
        end,
        mode = { "n", "v" },
        desc = "Format (Conform)",
      },
      {
        "<leader>vc",
        "<cmd>ConformInfo<cr>",
        desc = "Conform Info",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      format = {
        timeout_ms = 3000,
        async = false,
        quiet = false,
      },
      formatters_by_ft = {
        ["lua"] = { "stylua" },
        ["sh"] = { "shfmt" },
        ["javascript"] = { "prettier" },
        ["javascriptreact"] = { "prettier" },
        ["typescript"] = { "prettier" },
        ["typescriptreact"] = { "prettier" },
        ["vue"] = { "prettier" },
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["less"] = { "prettier" },
        ["html"] = { "prettier" },
        ["json"] = { "prettier" },
        ["jsonc"] = { "prettier" },
        ["yaml"] = { "prettier" },
        ["markdown"] = { "prettier" },
        ["markdown.mdx"] = { "prettier" },
        ["graphql"] = { "prettier" },
        ["handlebars"] = { "prettier" },
      },
      formatters = {
        injected = {
          options = {
            ignore_errors = true,
          },
        },
      },
    },
  },
}
