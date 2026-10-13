vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
    delete_to_trash = true,
    view_options = {
        show_hidden = true,
    },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })

local quicker = require("quicker")
quicker.setup({
    keys = {
        { ">", quicker.toggle_expand, desc = "Toggle quickfix context" },
    },
})

vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

vim.pack.add({ "https://github.com/MeanderingProgrammer/render-markdown.nvim" })
