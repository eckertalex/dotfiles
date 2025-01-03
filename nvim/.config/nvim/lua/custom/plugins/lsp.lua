return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
            "nvim-telescope/telescope.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            {
                "folke/lazydev.nvim",
                opts = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
                callback = function(event)
                    vim.keymap.set(
                        "n",
                        "gd",
                        -- vim.lsp.buf.definition,
                        require("telescope.builtin").lsp_definitions,
                        { buffer = event.buf, desc = "vim.lsp.buf.definition" }
                    )

                    vim.keymap.set(
                        "n",
                        "grr",
                        -- vim.lsp.buf.references,
                        require("telescope.builtin").lsp_references,
                        { buffer = event.buf, desc = "vim.lsp.buf.references" }
                    )

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
                        vim.keymap.set("n", "<leader>xh", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
                        end, { desc = "Toggle inlay hints" })
                    end
                end,
            })

            local blink_cmp = require("blink.cmp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                blink_cmp.get_lsp_capabilities()
            )

            local servers = {
                astro = {},
                cssls = {},
                cssmodules_ls = {},
                eslint = {
                    settings = {
                        workingDirectories = { mode = "auto" },
                    },
                    on_attach = function()
                        vim.keymap.set("", "<leader>cx", "<cmd>EslintFixAll<cr>", { desc = "EslintFixAll" })
                    end,
                },
                gopls = {
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
                                fieldalignment = false,
                                nilness = true,
                                unusedparams = true,
                                unusedwrite = true,
                                useany = true,
                            },
                            usePlaceholders = true,
                            completeUnimported = true,
                            staticcheck = true,
                            directoryFilters = {
                                "-.git",
                                "-.vscode",
                                "-.idea",
                                "-.vscode-test",
                                "-node_modules",
                            },
                            semanticTokens = true,
                        },
                    },
                },
                graphql = {},
                html = {},
                jsonls = {
                    on_new_config = function(new_config)
                        new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                    end,
                    settings = {
                        format = {
                            json = {
                                enable = true,
                            },
                            validate = { enable = true },
                        },
                    },
                },
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            telemetry = {
                                enable = false,
                            },
                            diagnostics = {
                                disable = {
                                    "missing-fields",
                                },
                            },
                            hint = {
                                enable = true,
                            },
                        },
                    },
                },
                marksman = {},
                sqls = {},
                tailwindcss = {},
                vtsls = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                parameterNames = { enabled = "literals" },
                                parameterTypes = { enabled = true },
                                variableTypes = { enabled = true },
                                propertyDeclarationTypes = { enabled = true },
                                functionLikeReturnTypes = { enabled = true },
                                enumMemberValues = { enabled = true },
                            },
                        },
                    },
                },
            }

            require("mason").setup()

            local ensure_installed = vim.tbl_keys(servers or {})
            vim.list_extend(ensure_installed, {
                "gofumpt",
                "goimports",
                "markdownlint",
                "prettier",
                "shfmt",
                "stylua",
            })
            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        local server = servers[server_name] or {}
                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                        require("lspconfig")[server_name].setup(server)
                    end,
                },
            })
        end,
    },
}
