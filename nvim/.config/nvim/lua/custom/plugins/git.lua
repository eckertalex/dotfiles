return {
	{
		"tpope/vim-fugitive",
		cmd = { "G", "Git" },
		keys = {
			{ "<leader>gg", "<cmd>Git<cr>", desc = "Fugitive" },
			{ "<leader>gb", "<cmd>Git blame<cr>", desc = "Blame file" },
		},
	},

	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map({ "n", "v" }, "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next hunk" })

				map({ "n", "v" }, "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous hunk" })

				-- Actions
				-- visual mode
				map("v", "<leader>ghs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk" })
				map("v", "<leader>ghr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset hunk" })
				-- normal mode
				map("n", "<leader>ghs", gs.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>ghr", gs.reset_hunk, { desc = "Reset hunk" })
				map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage buffer" })
				map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
				map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = false })
				end, { desc = "Blame line" })
				map("n", "<leader>ghd", gs.diffthis, { desc = "Diff this" })
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, { desc = "Diff this ~" })
			end,
		},
	},
}