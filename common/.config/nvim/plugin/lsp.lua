local augroup = vim.api.nvim_create_augroup("config-lsp", {})

vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/b0o/SchemaStore.nvim",
})

vim.lsp.enable({
    "cssls",
    "eslint",
    "gopls",
    "html",
    "jsonls",
    "lua_ls",
    "ols",
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
    end,
    desc = "Attach LSP keymaps and completion",
})

vim.keymap.set("n", "<leader>xh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

local last_report = {}

vim.api.nvim_create_autocmd("LspProgress", {
    group = augroup,
    callback = function(event)
        local value = event.data.params.value
        local token = event.data.params.token
        if value.kind == "report" then
            local now = vim.uv.now()
            if now - (last_report[token] or 0) < 500 then
                return
            end
            last_report[token] = now
        end

        if value.kind == "end" then
            last_report[token] = nil
        end

        local message = value.message or (value.kind == "end" and "done" or "")
        vim.api.nvim_echo({ { message } }, false, {
            id = "lsp" .. token,
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
        local ft = vim.bo[bufnr].filetype
        if vim.tbl_contains({ "sql", "java" }, ft) then
            return
        end
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        if vim.api.nvim_buf_get_name(bufnr):match("/node_modules/") then
            return
        end
        local c_like = vim.tbl_contains({ "c", "cpp", "objc" }, ft)
        return { timeout_ms = 3000, lsp_format = c_like and "never" or "fallback" }
    end,
    formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        objc = { "clang-format" },
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
    formatters = {
        ["clang-format"] = {
            -- Only projects that opt in with a .clang-format get formatted
            condition = function(_, ctx)
                return vim.fs.root(ctx.dirname, ".clang-format") ~= nil
            end,
        },
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
