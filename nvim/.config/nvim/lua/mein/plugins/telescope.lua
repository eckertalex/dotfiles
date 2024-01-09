return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({})
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader><leader>", builtin.resume, { desc = "Resume Telescope" })

			-- find
			vim.keymap.set("n", "<leader>fb", function()
				builtin.buffers({ sort_mru = true, sort_lastused = true })
			end, { desc = "Buffers" })
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Files" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Recent" })

			-- git
			vim.keymap.set("n", "<leader>gc", builtin.git_commits, { desc = "Commits" })
			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Status" })
			vim.keymap.set("n", "<leader>gf", builtin.git_files, { desc = "Git files" })

			-- search
			vim.keymap.set("n", "<leader>sb", builtin.current_buffer_fuzzy_find, { desc = "Buffer" })
			vim.keymap.set("n", "<leader>sd", function()
				builtin.diagnostics({ bufnr = 0 })
			end, { desc = "Buffer Diagnostics" })
			vim.keymap.set("n", "<leader>sD", builtin.diagnostics, { desc = "Diagnostics" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "Grep" })
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "Help" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "Current Word" })
		end,
	},
}
