Config.now_if_args(function()
    vim.pack.add({ "https://github.com/neovim/nvim-lspconfig" })

    vim.lsp.enable({
        "astro",
        "cssls",
        "eslint",
        "gopls",
        "html",
        "jsonls",
        "kotlin_lsp",
        "lua_ls",
        "tailwindcss",
        "vtsls",
        "yamlls",
    })
end)

Config.now_if_args(function()
    vim.pack.add({ "https://github.com/b0o/SchemaStore.nvim" })
end)

Config.later(function()
    vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

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
            astro = { "prettier" },
            css = { "prettier" },
            go = { "gofmt" },
            graphql = { "prettier" },
            html = { "prettier" },
            javascript = { "prettier" },
            javascriptreact = { "prettier" },
            json = { "prettier" },
            lua = { "stylua" },
            markdown = { "prettier" },
            ["markdown.mdx"] = { "prettier" },
            scss = { "prettier" },
            typescript = { "prettier" },
            typescriptreact = { "prettier" },
            yaml = { "prettier" },
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

Config.now_if_args(function()
    vim.pack.add({
        {
            src = "https://github.com/saghen/blink.cmp",
            version = "v1.9.1",
        },
        "https://github.com/rafamadriz/friendly-snippets",
    })

    require("blink.cmp").setup({
        keymap = {
            preset = "default",

            ["<C-l>"] = { "snippet_forward", "fallback" },
            ["<C-h>"] = { "snippet_backward", "fallback" },
        },
        completion = {
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 500,
            },
        },
    })
end)

-- set default filetypes
vim.filetype.add({
    extension = {
        query = "graphql",
    },
})
