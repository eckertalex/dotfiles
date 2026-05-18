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

-- Deferred to VimEnter: claudecode pulls in ~20 modules at require time
-- (~14ms cold). Nothing in it is needed until the user invokes <leader>a*,
-- so set it up after Neovim has finished starting. See `:h VimEnter`.
vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    once = true,
    desc = "Set up claudecode after startup",
    callback = function()
        vim.pack.add({ "https://github.com/coder/claudecode.nvim" })

        require("claudecode").setup()

        vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle claude" })
        vim.keymap.set("n", "<leader>af", "<cmd>ClaudeCodeFocus<cr>", { desc = "Focus claude" })
        vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume claude" })
        vim.keymap.set("n", "<leader>aC", "<cmd>ClaudeCode --continue<cr>", { desc = "Continue claude" })
        vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer" })
        vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to claude" })
        vim.keymap.set("n", "<leader>aa", "<cmd>ClaudeCodeAccept<cr>", { desc = "Accept diff" })
        vim.keymap.set("n", "<leader>ad", "<cmd>ClaudeCodeDeny<cr>", { desc = "Deny diff" })

        vim.api.nvim_create_autocmd("FileType", {
            group = augroup,
            pattern = { "oil", "minifiles", "netrw" },
            callback = function()
                vim.keymap.set("n", "<leader>as", "<cmd>ClaudeCodeTreeAdd<cr>", {
                    desc = "Add to claude",
                })
            end,
        })
    end,
})
