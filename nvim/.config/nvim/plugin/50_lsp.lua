local add, later = MiniDeps.add, MiniDeps.later
local now_if_args = _G.Config.now_if_args

now_if_args(function()
    add({
        source = "neovim/nvim-lspconfig",
        depends = {
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
        },
    })

    local servers = {
        astro = {},
        cssls = {},
        cssmodules_ls = {},
        eslint = {
            settings = {
                workingDirectories = { mode = "auto" },
            },
            on_attach = function()
                vim.keymap.set("", "<leader>cx", "<cmd>LspEslintFixAll<cr>", { desc = "LspEslintFixAll" })
            end,
        },
        elixirls = {},
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
                    completion = { callSnippet = "Replace" },
                    telemetry = { enable = false },
                    diagnostics = { disable = { "missing-fields" } },
                    hint = { enable = true },
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
    require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_enable = true,
        handlers = {
            function(server_name)
                local server = servers[server_name] or {}
                require("lspconfig")[server_name].setup(server)
            end,
        },
    })

    require("mason-tool-installer").setup({
        ensure_installed = {
            "gofumpt",
            "goimports",
            "markdownlint",
            "prettier",
            "shfmt",
            "stylua",
        },
        automatic_enable = true,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
        callback = function(event)
            local fzf = require("fzf-lua")

            vim.keymap.set(
                "n",
                "gd",
                -- vim.lsp.buf.definition,
                function()
                    fzf.lsp_definitions()
                end,
                { buffer = event.buf, desc = "vim.lsp.buf.definition" }
            )

            vim.keymap.set(
                "n",
                "grr",
                -- vim.lsp.buf.references,
                function()
                    fzf.lsp_references()
                end,
                { buffer = event.buf, desc = "vim.lsp.buf.references" }
            )
        end,
    })
end)

later(function()
    add("stevearc/conform.nvim")

    local prettier = { "prettierd", "prettier", stop_after_first = true }
    require("conform").setup({
        format_on_save = function(bufnr)
            -- Disable autoformat on certain filetypes
            local ignore_filetypes = { "sql", "java", "c", "cpp" }
            if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
                return
            end
            -- Disable with a global or buffer-local variable
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
            end
            -- Disable autoformat for files in a certain path
            local bufname = vim.api.nvim_buf_get_name(bufnr)
            if bufname:match("/node_modules/") then
                return
            end
            return { timeout_ms = 3000, lsp_format = "fallback" }
        end,
        formatters_by_ft = {
            ["astro"] = prettier,
            ["css"] = prettier,
            ["go"] = { "goimports", "gofumpt" },
            ["graphql"] = prettier,
            ["html"] = prettier,
            ["javascript"] = prettier,
            ["javascriptreact"] = prettier,
            ["json"] = prettier,
            ["jsonc"] = prettier,
            ["lua"] = { "stylua" },
            ["markdown"] = prettier,
            ["markdown.mdx"] = prettier,
            ["scss"] = prettier,
            ["sh"] = { "shfmt" },
            ["typescript"] = prettier,
            ["typescriptreact"] = prettier,
            ["yaml"] = prettier,
        },
    })

    vim.keymap.set({ "n", "x" }, "gq", "<cmd>Format<cr>", { desc = "Format buffer" })

    vim.api.nvim_create_user_command("FormatDisable", function(args)
        if args.bang then
            -- FormatDisable! will disable formatting just for this buffer
            vim.b.disable_autoformat = true
        else
            vim.g.disable_autoformat = true
        end
    end, {
        desc = "Disable autoformat-on-save",
        bang = true,
    })

    vim.api.nvim_create_user_command("FormatEnable", function()
        vim.b.disable_autoformat = false
        vim.g.disable_autoformat = false
    end, {
        desc = "Re-enable autoformat-on-save",
    })

    vim.api.nvim_create_user_command("Format", function(args)
        local range = nil
        if args.count ~= -1 then
            local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
            range = {
                start = { args.line1, 0 },
                ["end"] = { args.line2, end_line:len() },
            }
        end
        require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
end)

later(function()
    add({
        source = "saghen/blink.cmp",
        checkout = "v1.7.0",
    })

    require("blink.cmp").setup({
        keymap = { preset = "default" },
        appearance = {
            nerd_font_variant = "mono",
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
        },
        sources = {
            default = { "lsp", "path", "buffer" },
        },
        signature = { enabled = true },
        fuzzy = { implementation = "prefer_rust_with_warning" },
    })
end)

-- set default filetypes
vim.filetype.add({
    extension = {
        query = "graphql",
    },
})
