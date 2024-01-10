return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/neodev.nvim", -- awesome neovim dev tools
      "j-hui/fidget.nvim", -- lsp progress messages

      -- install deps
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",

      -- autocomplete
      "hrsh7th/nvim-cmp",

      -- completion capabilities
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",

      -- Snippet Engine & its associated nvim-cmp source
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require("neodev").setup()
      require("fidget").setup({
        notification = {
          window = {
            winblend = 0,
            border = "rounded",
          },
        },
      })
      require("mason").setup()
      require('lspconfig.ui.windows').default_options.border = 'rounded'

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "html",
          "lua_ls",
          "tailwindcss",
          "tsserver",
        },
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
            })
          end,

          ["lua_ls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({
              settings = {
                lua = {
                  workspace = { checkthirdparty = false },
                  telemetry = { enable = false },
                  hint = { enable = true },
                  diagnostics = { disable = { "missing-fields" } },
                },
              },
            })
          end,

          ["tsserver"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.tsserver.setup({
              settings = {
                -- taken from https://github.com/typescript-language-server/typescript-language-server#workspacedidchangeconfiguration
                javascript = {
                  inlayhints = {
                    includeinlayenummembervaluehints = true,
                    includeinlayfunctionlikereturntypehints = true,
                    includeinlayfunctionparametertypehints = true,
                    includeinlayparameternamehints = "all",
                    includeinlayparameternamehintswhenargumentmatchesname = true,
                    includeinlaypropertydeclarationtypehints = true,
                    includeinlayvariabletypehints = true,
                  },
                },
                typescript = {
                  inlayhints = {
                    includeinlayenummembervaluehints = true,
                    includeinlayfunctionlikereturntypehints = true,
                    includeinlayfunctionparametertypehints = true,
                    includeinlayparameternamehints = "all",
                    includeinlayparameternamehintswhenargumentmatchesname = true,
                    includeinlaypropertydeclarationtypehints = true,
                    includeinlayvariabletypehints = true,
                  },
                },
              },
            })
          end,
        },
      })

      -- [[ configure cmp ]]
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = "menu,menuone,noinsert",
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "path" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
