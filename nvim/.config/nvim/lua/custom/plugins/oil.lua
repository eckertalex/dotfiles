return {
	{
		"stevearc/oil.nvim",
		lazy = false,
		cmd = { "Oil" },
		keys = {
			{ "-", "<cmd>Oil<cr>", desc = "Open parent directory" },
		},
		opts = {
			view_options = {
				show_hidden = true,
			},
		},
	},
}
