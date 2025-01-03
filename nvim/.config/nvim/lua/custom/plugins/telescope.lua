return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = { "Telescope" },
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
				config = function()
					local telescope = require("telescope")
					telescope.load_extension("fzf")
				end,
			},
			{
				"nvim-telescope/telescope-ui-select.nvim",
				config = function()
					local telescope = require("telescope")
					telescope.load_extension("ui-select")
				end,
			},
		},
		keys = {
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Search Help" },
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Search Files" },
			{ "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "Search current Word" },
			{ "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "Search by Grep" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Search Diagnostics" },
			{ "<leader>sr", "<cmd>Telescope resume<cr>", desc = "Search Resume" },
			{ "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = "Search Recent Files" },
			{
				"<leader><leader>",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Search Buffers",
			},
			{
				"<leader>/",
				"<cmd>Telescope current_buffer_fuzzy_find<cr>",
				desc = "Fuzzily search in current buffer",
			},
			{
				"<leader>s/",
				"<cmd>Telescope live_grep grep_open_files=true prompt_title=Live\\ Grep\\ in\\ Open\\ Files<cr>",
				desc = "Search in Open Files",
			},
			{ "<leader>gsb", "<cmd>Telescope git_branches<cr>", desc = "Search Git Branches" },
			{ "<leader>gss", "<cmd>Telescope git_status<cr>", desc = "Search Git Status" },
			{ "<leader>gsf", "<cmd>Telescope git_files<cr>", desc = "Search Git Files" },
			{
				"<leader>sn",
				function()
					require("telescope.builtin").find_files({
						cwd = vim.fn.stdpath("config"),
					})
				end,
				desc = "Search config",
			},
			{
				"<leader>sp",
				function()
					require("telescope.builtin").find_files({
						cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
					})
				end,
				desc = "Search plugins",
			},
		},
		opts = function()
			local actions = require("telescope.actions")
			local action_layout = require("telescope.actions.layout")

			return {
				pickers = {
					find_files = {
						follow = true,
						hidden = true,
					},
				},
				defaults = {
					path_display = {
						filename_first = true,
					},
					mappings = {
						i = {
							["<C-h>"] = action_layout.toggle_preview,
						},
						n = {
							["<C-h>"] = action_layout.toggle_preview,
							["q"] = actions.close,
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			}
		end,
	},
}
