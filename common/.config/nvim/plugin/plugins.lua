local augroup = require("utils").augroup

vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

local oil = require("oil")
oil.setup({
    view_options = {
        show_hidden = true,
        delete_to_trash = true,
    },
    keymaps = {
        -- create a new mapping, gs, to search and replace in the current directory
        gs = {
            callback = function()
                -- get the current directory
                local prefills = { paths = oil.get_current_dir() }

                local grug_far = require("grug-far")
                -- instance check
                if not grug_far.has_instance("explorer") then
                    grug_far.open({
                        instanceName = "explorer",
                        prefills = prefills,
                        staticTitle = "Find and Replace from Explorer",
                    })
                else
                    grug_far.get_instance("explorer"):open()
                    -- updating the prefills without clearing the search and other fields
                    grug_far.get_instance("explorer"):update_input_values(prefills, false)
                end
            end,
            desc = "oil: Search in directory",
        },
    },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })

vim.pack.add({ "https://github.com/stevearc/quicker.nvim" })

local quicker = require("quicker")
quicker.setup({
    quickfix = { open = true, close = true, stay = true },
    loclist = { open = true, close = true, stay = true },
    keys = {
        { "<a-p>", quicker.toggle_expand, desc = "Toggle quickfix content" },
    },
})

vim.pack.add({
    "https://github.com/tpope/vim-fugitive",
    "https://github.com/tpope/vim-rhubarb",
})

vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })

vim.pack.add({ "https://github.com/lervag/vimtex" })

vim.pack.add({ "https://github.com/MagicDuck/grug-far.nvim" })

vim.keymap.set({ "n", "x" }, "<leader>si", function()
    require("grug-far").open({ visualSelectionUsage = "auto-detect" })
end, { desc = "grug-far: Search within range" })
