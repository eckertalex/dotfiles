local augroup = require("utils").augroup

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/b0o/SchemaStore.nvim",
})

vim.lsp.enable({
    "clangd",
    "cssls",
    "eslint",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "ruff",
    "tsc",
    "ty",
    "yamlls",
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(event)
        local buf = event.buf
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then
            return
        end

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "vim.lsp.buf.definition" })

        -- LSP items reach 'autocomplete' through 'omnifunc' (the "o" in 'complete').
        -- Enabling here applies snippets, auto-imports and docs when accepting with <C-y>.
        if client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
        end

        if client:supports_method("textDocument/documentHighlight") then
            local highlight_group = vim.api.nvim_create_augroup("lsp-highlight-" .. buf, {})
            vim.api.nvim_create_autocmd("CursorHold", {
                group = highlight_group,
                buffer = buf,
                callback = vim.lsp.buf.document_highlight,
                desc = "Highlight references of the word under cursor",
            })
            vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
                group = highlight_group,
                buffer = buf,
                callback = vim.lsp.buf.clear_references,
                desc = "Clear reference highlights",
            })
        end
    end,
    desc = "Attach LSP keymaps, completion and reference highlights",
})

vim.keymap.set("n", "<leader>xh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

vim.api.nvim_create_autocmd("LspProgress", {
    group = augroup,
    callback = function(event)
        local value = event.data.params.value
        vim.api.nvim_echo({ { value.message or "done" } }, false, {
            id = "lsp" .. event.data.client_id,
            kind = "progress",
            source = "vim.lsp",
            title = value.title,
            status = value.kind ~= "end" and "running" or "success",
            percent = value.percentage,
        })
    end,
    desc = "Show LSP progress",
})

vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(bufnr)
        local ignore_filetypes = { "sql", "java", "c", "cpp" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
        end
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
            return
        end
        return { timeout_ms = 3000 }
    end,
    formatters_by_ft = {
        css = { "prettier" },
        go = { "gofmt" },
        graphql = { "prettier" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        scss = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
    },
})

-- Route the built-in `gq` operator through conform. Takes precedence over the
-- LSP default, which only sets 'formatexpr' when it is empty
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
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
