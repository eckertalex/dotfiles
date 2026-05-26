vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

local fzf = require("fzf-lua")
local augroup = require("utils").augroup

fzf.setup({
    fzf_colors = true,
    winopts = {
        ---@diagnostic disable-next-line: missing-fields
        preview = {
            layout = "vertical",
        },
    },
    keymap = {
        builtin = {
            ["<a-p>"] = "toggle-preview",
        },
    },
    defaults = {
        formatter = "path.filename_first",
    },
})

fzf.register_ui_select()

local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { desc = desc })
end

map("<leader>,", fzf.buffers, "Buffers")

map("<leader><leader>", function()
    fzf.combine({ pickers = "buffers;oldfiles;git_files", cwd_only = true })
end, "Find (buffers/recent/git) cwd")
map("<leader>fr", function()
    fzf.combine({ pickers = "buffers;oldfiles;git_files", cwd_only = false })
end, "Find (buffers/recent/git) global")

map("<leader>ff", fzf.files, "Find all files")
map("<leader>fg", fzf.git_files, "Find git files")

map("<leader>fo", function()
    fzf.oldfiles({ cwd_only = true })
end, "Recent files (cwd)")

-- git
map("<leader>gc", fzf.git_branches, "Branches")
map("<leader>gl", fzf.git_commits, "Log")
map("<leader>gf", fzf.git_bcommits, "Log file")
map("<leader>gs", fzf.git_status, "Status")
map("<leader>gB", fzf.git_blame, "Blame file (fzf)")
map("<leader>gS", fzf.git_stash, "Stash")

-- grep
map("<leader>sb", fzf.lines, "Buffer lines")
map("<leader>sB", fzf.grep_curbuf, "Grep open buffers")
map("<leader>sg", fzf.live_grep_native, "Grep project")
map("<leader>sw", fzf.grep_cword, "Grep word")
map("<leader>sw", fzf.grep_visual, "Grep selection", "x")

-- search / misc
map("<leader>sh", fzf.help_tags, "Search help")
map("<leader>sr", fzf.resume, "Resume")
map("<leader>sd", fzf.diagnostics_workspace, "Diagnostics (Workspace)")
map("<leader>sD", fzf.diagnostics_document, "Diagnostics (Buffer)")
map("<leader>sq", fzf.quickfix, "Quickfix list")
map("<leader>sl", fzf.loclist, "Location list")

vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup,
    callback = function(event)
        vim.keymap.set("n", "gd", function()
            fzf.lsp_definitions()
        end, { buffer = event.buf, desc = "vim.lsp.buf.definition" })

        vim.keymap.set("n", "grr", function()
            fzf.lsp_references()
        end, { buffer = event.buf, desc = "vim.lsp.buf.references" })
    end,
    desc = "Attach custom LSP keymaps (FZF definitions and references)",
})
