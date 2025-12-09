local group = vim.api.nvim_create_augroup("BasicAutocommands", {})

vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Resize splits when window is resized",
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
    group = group,
    callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].lazyvim_last_loc then
            return
        end
        vim.b[buf].lazyvim_last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
    desc = "Restore cursor position to last known location when reopening files",
})

-- Don't auto-wrap comments and don't insert comment leader after hitting 'o'.
-- Do on `FileType` to always override these changes from filetype plugins.
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function()
        vim.cmd("setlocal formatoptions-=c formatoptions-=o")
    end,
    desc = "Don't auto-wrap comments or continue comment on 'o' or 'O'",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = {
        "PlenaryTestPopup",
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
    group = group,
    pattern = { "text", "plaintex", "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
    desc = "Wrap and check spelling in text-like files",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "haskell", "cabal" },
    callback = function()
        vim.opt_local.expandtab = true
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
    end,
    desc = "Use spaces instead of tabs for Haskell and Cabal files",
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = { "json", "jsonc", "json5", "markdown" },
    callback = function()
        vim.opt_local.conceallevel = 0
    end,
    desc = "Set conceallevel to 0 for JSON and Markdown files",
})
