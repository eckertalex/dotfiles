return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		---@class wk.Opts
		opts = {
			preset = "helix",
			spec = {
				{ "<leader>b", group = "Buffers" },
				{ "<leader>f", group = "Find" },
				{ "<leader>g", group = "Git" },
				{ "<leader>h", group = "Git Hunk", mode = { "n", "v" } },
				{ "<leader>q", group = "Quit/Sessions" },
				{ "<leader>s", group = "Search", mode = { "n", "v" } },
				{ "<leader>t", group = "Toggle" },
				{ "<leader>x", group = "Diagnostics/Quickfix" },
			},
		},
		keys = {
			{
				"<leader>?",
				function()
					require("which-key").show({ global = false })
				end,
				desc = "Buffer Local Keymaps (which-key)",
			},
		},
	},
}
