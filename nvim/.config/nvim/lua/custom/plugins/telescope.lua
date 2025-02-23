local live_multigrep = function()
	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local make_entry = require("telescope.make_entry")
	local conf = require("telescope.config").values

	local opts = {
		cwd = vim.uv.cwd(),
		shortcuts = {
			globs = {
				["l"] = "*.lua",
				["g"] = "*.go",
				["js"] = "*.js",
				["jsx"] = "*.jsx",
				["ts"] = "*.ts",
				["tsx"] = "*.tsx",
				["s"] = "*.test.*",
				["T"] = "!*.test.*",
			},
			paths = {
				["tm"] = "product-areas/time-money/",
				["ds"] = "product-areas/design-system/",
			},
		},
		pattern = "%s",
	}

	local finder = finders.new_async_job({
		command_generator = function(prompt)
			if not prompt or prompt == "" then
				return nil
			end

			local prompt_split = vim.split(prompt, "  ")
			local args = { "rg" }
			if prompt_split[1] then
				table.insert(args, "-e")
				table.insert(args, prompt_split[1])
			end

			for i = 2, #prompt_split do
				if vim.startswith(prompt_split[i], "in:") then
					local path = prompt_split[i]:sub(4)
					if opts.shortcuts.paths[path] then
						path = opts.shortcuts.paths[path]
					end

					table.insert(args, path)
				else
					local pattern
					if opts.shortcuts.globs[prompt_split[i]] then
						pattern = opts.shortcuts.globs[prompt_split[i]]
					else
						pattern = prompt_split[i]
					end

					table.insert(args, "-g")
					table.insert(args, string.format(opts.pattern, pattern))
				end
			end

			return vim.iter({
				args,
				{ "--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case" },
			})
				:flatten()
				:totable()
		end,
		entry_maker = make_entry.gen_from_vimgrep(opts),
		cwd = opts.cwd,
	})

	pickers
		.new(opts, {
			debounce = 100,
			prompt_title = "Multi Grep",
			finder = finder,
			previewer = conf.grep_previewer(opts),
			sorter = require("telescope.sorters").empty(),
		})
		:find()
end

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
				"stevearc/dressing.nvim",
				opts = {
					select = {
						telescope = require("telescope.themes").get_cursor(),
					},
				},
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
			{
				"<leader>sm",
				live_multigrep,
				desc = "Search Multi Grep",
			},
			{ "<leader>gsb", "<cmd>Telescope git_branches<cr>", desc = "Search Git Branches" },
			{ "<leader>gss", "<cmd>Telescope git_status<cr>", desc = "Search Git Status" },
			{ "<leader>gsf", "<cmd>Telescope git_files<cr>", desc = "Search Git Files" },
			{
				"<leader>sn",
				function()
					require("telescope.builtin").find_files({
						cwd = vim.fn.stdpath("config"),
						prompt_title = "Config files",
					})
				end,
				desc = "Search config",
			},
			{
				"<leader>sp",
				function()
					require("telescope.builtin").find_files({
						cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
						prompt_title = "Plugins data",
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
			}
		end,
	},
}
