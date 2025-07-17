return {
	{
		"echasnovski/mini.icons",
		lazy = true,
		opts = {},
		init = function()
			package.preload["nvim-web-devicons"] = function()
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
	},

	{
		"echasnovski/mini.cursorword",
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		opts = {},
	},

	{
		"echasnovski/mini.statusline",
		opts = {},
	},
}
