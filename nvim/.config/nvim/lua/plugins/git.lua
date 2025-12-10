return {
    {
        "tpope/vim-fugitive",
        dependencies = {
            { "tpope/vim-rhubarb" },
        },
        config = function()
            vim.keymap.set("n", "<leader>gb", "<cmd>Git blame<cr>", { desc = "Blame file" })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        config = function()
            local gitsigns = require("gitsigns")

            local function on_attach(bufnr)
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                local function next_hunk()
                    if vim.wo.diff then
                        vim.cmd.normal({ args = { "]c" }, bang = true })
                    else
                        require("gitsigns").nav_hunk({ direction = "next" })
                    end
                end

                local function prev_hunk()
                    if vim.wo.diff then
                        vim.cmd.normal({ args = { "[c" }, bang = true })
                    else
                        require("gitsigns").nav_hunk({ direction = "prev" })
                    end
                end

                map({ "n", "v" }, "]c", next_hunk, { desc = "Next hunk" })
                map({ "n", "v" }, "[c", prev_hunk, { desc = "Previous hunk" })

                map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
                map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })

                map("v", "<leader>hs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Stage selected hunk" })
                map("v", "<leader>hr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, { desc = "Reset selected hunk" })

                map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
                map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
                map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
                map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })

                map("n", "<leader>hb", function()
                    gitsigns.blame_line({ full = true })
                end, { desc = "Blame line" })

                map("n", "<leader>hd", gitsigns.diffthis, { desc = "Diff this" })
                map("n", "<leader>hD", function()
                    gitsigns.diffthis({ base = "~" })
                end, { desc = "Diff this ~" })

                map("n", "<leader>hq", gitsigns.setqflist, { desc = "Populate qflist with hunks" })
                map("n", "<leader>hQ", function()
                    gitsigns.setqflist({ target = "all" })
                end, { desc = "Populate qflist with all hunks" })

                map("n", "\\g", gitsigns.toggle_current_line_blame, { desc = "Toggle git line blame" })
                map("n", "\\W", gitsigns.toggle_word_diff, { desc = "Toggle git word diff highlight" })

                map({ "o", "x" }, "gh", gitsigns.select_hunk, { desc = "Select hunk text object" })
            end

            gitsigns.setup({
                on_attach = on_attach,
            })
        end,
    },
}
