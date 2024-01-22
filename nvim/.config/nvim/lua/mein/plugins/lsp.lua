return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- awesome neovim dev tools
      {
        "folke/neodev.nvim",
        opts = {},
      },
      -- lsp progress messages
      {
        "j-hui/fidget.nvim",
        opts = {
          notification = {
            window = {
              border = "rounded",
            },
          },
        },
      },

      -- install deps
      {
        "williamboman/mason.nvim",
        opts = {},
      },
      "williamboman/mason-lspconfig.nvim",

      -- json schema support
      {
        "b0o/SchemaStore.nvim",
        lazy = true,
        version = false, -- last release is way too old
      },
    },
    config = function()
      -- diagnostics
      for name, icon in pairs(require("mein.icons").diagnostics) do
        name = "DiagnosticSign" .. name
        vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
      end

      vim.diagnostic.config({
        float = {
          border = "rounded",
        },
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = function(diagnostic)
            local icons = require("mein.icons").diagnostics
            for d, icon in pairs(icons) do
              if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
                return icon
              end
            end
          end,
        },
        severity_sort = true,
      })

      require("lspconfig.ui.windows").default_options.border = "rounded"
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf

          -- Enable completion triggered by <c-x><c-o>
          vim.bo[buffer].omnifunc = "v:lua.vim.lsp.omnifunc"

          vim.keymap.set("n", "<leader>vl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
          -- Displays hover information about the symbol under the cursor
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = buffer, desc = "Hover Documentation" })
          -- Jump to the definition
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buffer, desc = "Definition" })
          -- Jump to declaration
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = buffer, desc = "Declaration" })
          -- Lists all the implementations for the symbol under the cursor
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = buffer, desc = "Implementation" })
          -- Jumps to the definition of the type symbol
          vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = buffer, desc = "Type Definition" })
          -- Lists all the references
          vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = buffer, desc = "References" })
          -- Displays a function's signature information
          vim.keymap.set(
            { "n", "i" },
            "<C-s>",
            vim.lsp.buf.signature_help,
            { buffer = buffer, desc = "Signature Documentation" }
          )
          -- Renames all references to the symbol under the cursor
          vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { buffer = buffer, desc = "Rename" })
          -- Selects a code action available at the current cursor position
          vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { buffer = buffer, desc = "Code Action" })
        end,
      })

      local autoformat_is_enabled = true
      vim.api.nvim_create_user_command("ToggleAutoformat", function()
        autoformat_is_enabled = not autoformat_is_enabled
        if autoformat_is_enabled then
          vim.notify("Enabled autoformatting", vim.log.levels.INFO)
        else
          vim.notify("Disabled autoformatting", vim.log.levels.WARN)
        end
      end, {})

      vim.keymap.set("n", "<leader>uf", "<cmd>ToggleAutoformat<cr>", { desc = "Toggle autoformatting" })

      -- Create an augroup that is used for managing our formatting autocmds.
      --      We need one augroup per client to make sure that multiple clients
      --      can attach to the same buffer without interfering with each other.
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = "lsp-format-" .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client then
            vim.notify("No client attached", vim.lsp.log_levels.WARN)
            return
          end

          if not client.server_capabilities.documentFormattingProvider then
            vim.notify("Client has formatting capability", vim.lsp.log_levels.WARN)
            return
          end

          local function format(opts)
            local ok, conform = pcall(require, "conform")
            if ok then
              conform.format({
                async = true,
                lsp_fallback = true,
              })
            else
              vim.lsp.buf.format(opts)
            end
          end

          vim.api.nvim_buf_create_user_command(buffer, "Format", function()
            format({ async = true })
          end, { desc = "Format current buffer" })

          vim.keymap.set("n", "<leader>cf", "<cmd>Format<cr>", { buffer = buffer, desc = "Format" })

          -- Create an autocmd that will run *before* we save the buffer.
          --  Run the formatting command for the LSP that has just attached.
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = buffer,
            callback = function()
              if not autoformat_is_enabled then
                return
              end

              format({
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              })
            end,
          })
        end,
      })

      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {}
      )

      require("mason-lspconfig").setup({
        ensure_installed = {
          "eslint",
          "gopls",
          "gopls",
          "html",
          "jsonls",
          "lua_ls",
          "marksman",
          "phpactor",
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
              capabilities = capabilities,
              settings = {
                Lua = {
                  workspace = {
                    checkThirdParty = false,
                  },
                  telemetry = {
                    enable = false,
                  },
                  diagnostics = {
                    disable = {
                      "missing-fields",
                    },
                  },
                },
              },
            })
          end,

          ["eslint"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.eslint.setup({
              capabilities = capabilities,
              settings = {
                workingDirectories = { mode = "auto" },
              },
            })
          end,

          ["tsserver"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.tsserver.setup({
              capabilities = capabilities,
              keys = {
                {
                  "<leader>co",
                  function()
                    vim.lsp.buf.code_action({
                      apply = true,
                      context = {
                        only = { "source.organizeImports.ts" },
                        diagnostics = {},
                      },
                    })
                  end,
                  desc = "Organize Imports",
                },
                {
                  "<leader>cR",
                  function()
                    vim.lsp.buf.code_action({
                      apply = true,
                      context = {
                        only = { "source.removeUnused.ts" },
                        diagnostics = {},
                      },
                    })
                  end,
                  desc = "Remove Unused Imports",
                },
              },
              settings = {
                typescript = {
                  format = {
                    indentSize = vim.o.shiftwidth,
                    convertTabsToSpaces = vim.o.expandtab,
                    tabSize = vim.o.tabstop,
                  },
                },
                javascript = {
                  format = {
                    indentSize = vim.o.shiftwidth,
                    convertTabsToSpaces = vim.o.expandtab,
                    tabSize = vim.o.tabstop,
                  },
                },
                completions = {
                  completeFunctionCalls = true,
                },
              },
            })
          end,

          ["gopls"] = function()
            local lspconfig = require("lspconfig")
            lspconfig.gopls.setup({
              capabilities = capabilities,
              settings = {
                gopls = {
                  gofumpt = true,
                  codelenses = {
                    gc_details = false,
                    generate = true,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                  },
                  hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                  },
                  analyses = {
                    fieldalignment = true,
                    nilness = true,
                    unusedparams = true,
                    unusedwrite = true,
                    useany = true,
                  },
                  usePlaceholders = true,
                  completeUnimported = true,
                  staticcheck = true,
                  directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                  semanticTokens = true,
                },
              },
            })
          end,

          ["jsonls"] = function()
            require("lspconfig").jsonls.setup({
              capabilities = capabilities,
              on_new_config = function(new_config)
                new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
              end,
              settings = {
                format = {
                  json = {
                    enable = true,
                  },
                  validate = { enable = true },
                },
              },
            })
          end,
        },
      })
    end,
  },
}
