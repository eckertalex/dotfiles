vim.pack.add({
    "https://github.com/nvim-mini/mini.pick",
    "https://github.com/nvim-mini/mini.extra",
})

require("mini.pick").setup()
require("mini.extra").setup()

vim.ui.select = MiniPick.ui_select

local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { desc = desc })
end

local function grep_selection()
    local lines = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })
    vim.cmd.normal({ args = { vim.keycode("<Esc>") }, bang = true })
    MiniPick.builtin.grep({ pattern = table.concat(lines, "\n"), method = "plain" })
end

-- files
map("<leader>,", MiniPick.builtin.buffers, "Buffers")
map("<leader><leader>", MiniPick.builtin.files, "Find files")
map("<leader>fo", function()
    MiniExtra.pickers.oldfiles({ current_dir = true })
end, "Recent files (cwd)")

-- grep
map("<leader>sg", MiniPick.builtin.grep_live, "Grep project")
map("<leader>sw", function()
    MiniPick.builtin.grep({ pattern = vim.fn.expand("<cword>"), method = "plain" })
end, "Grep word")
map("<leader>sw", grep_selection, "Grep selection", "x")

-- search / misc
map("<leader>sh", MiniPick.builtin.help, "Search help")
map("<leader>sr", MiniPick.builtin.resume, "Resume")
map("<leader>sd", MiniExtra.pickers.diagnostic, "Diagnostics (Workspace)")
map("<leader>sD", function()
    MiniExtra.pickers.diagnostic({ scope = "current" })
end, "Diagnostics (Buffer)")
