vim.api.nvim_create_autocmd("LspProgress", {
    group = Config.custom_augroup,
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

vim.api.nvim_create_autocmd("VimResized", {
    group = Config.custom_augroup,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Resize splits when window is resized",
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
vim.api.nvim_create_autocmd("FileType", {
    group = Config.custom_augroup,
    callback = function()
        vim.cmd("setlocal formatoptions-=c formatoptions-=o")
    end,
    desc = "Proper 'formatoptions'",
})

vim.api.nvim_create_autocmd("FileType", {
    group = Config.custom_augroup,
    pattern = {
        "netrw",
        "help",
        "lspinfo",
        "man",
        "notify",
        "qf",
        "query",
        "startuptime",
        "tsplayground",
        "checkhealth",
        "fugitiveblame",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
    desc = "Close special buffers with 'q' and exclude from buffer list",
})

vim.api.nvim_create_autocmd("FileType", {
    group = Config.custom_augroup,
    pattern = { "text", "plaintex", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
    desc = "Wrap and check spelling in text-like files",
})

vim.api.nvim_create_autocmd("FileType", {
    group = Config.custom_augroup,
    pattern = { "json", "jsonc", "json5", "markdown" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
    desc = "Set conceallevel to 0 for JSON and Markdown files",
})
